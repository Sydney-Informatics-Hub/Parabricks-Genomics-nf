#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import processes to be run in the workflow
include { extract_flowcell_lane } from './modules/extract_flowcell_lane' 
include { bwa_index } from './modules/bwa_index'
include { fastqc  } from './modules/fastqc'
include { pb_fq2bam } from './modules/pb_fq2bam'
include { pb_collectmetrics } from './modules/pb_collectmetrics'
include { pb_deepvariant } from './modules/pb_deepvar'
include { glnexus_joint_call } from './modules/glnexus_joint'
include { bcftools_convert } from './modules/convert_bcf'
include { bcftools_stats } from './modules/vcf_stats'
include { download_vep } from './modules/download_vep'
include { annotate_vcf } from './modules/annotate_vcf'
include { multiqc } from './modules/multiqc'

// Print a header upon execution 
log.info """\

\033[1m\033[36m=======================================================================================
Genomics001: Parabricks-Genomics-nf 
=======================================================================================\033[0m

\033[35mCreated by Georgie Samaha\033[0m
\033[35mFind documentation @ https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf\033[0m
\033[35mCite this pipeline @ INSERT DOI\033[0m

\033[1m\033[33m=======================================================================================
Workflow run parameters 
=======================================================================================\033[0m
\033[32minput_samples\033[0m : ${params.input}
\033[32mcohort_name\033[0m   : ${params.cohort_name}
\033[32mresults_dir\033[0m   : ${params.outdir}
\033[32mreference\033[0m     : ${params.ref}
\033[32mvep_species\033[0m   : ${params.vep_species}
\033[32mvep_assembly\033[0m  : ${params.vep_assembly}
\033[32mworkDir\033[0m       : ${workflow.workDir}
\033[1m\033[33m=======================================================================================\033[0m

"""

/// Help function 
// This is an example of how to set out the help function that 
// will be run if run command is incorrect or missing. 

def helpMessage() {
    log.info"""
  \033[1m\033[36mUsage:\033[0m  nextflow run main.nf --input <samples.csv> --ref <reference.fasta> --gadi_account <project code>

  \033[1m\033[33mRequired Arguments:\033[0m

  \033[32m--input\033[0m               Specify full path and name of sample input file (tab separated).

  \033[32m--ref\033[0m                 Specify full path and name of reference genome (FASTA format).

  \033[32m--gadi_account\033[0m        Specify NCI Gadi project code for accounting and storage.

  \033[1m\033[33mOptional Arguments:\033[0m

  \033[34m--outdir\033[0m              Specify path to output directory. 

  \033[34m--cohort_name\033[0m         Specify prefix for joint called VCF file. 

  \033[34m--storage_account\033[0m     Specify NCI Gadi storage paths. For example, "scratch/ab01+gdata/xy89"

  \033[34m--download_vep_cache\033[0m  Download the required cache (default: false).

  \033[34m--vep_species\033[0m         Specify which species cache to download from VEP (default: false).        

  \033[34m--vep_assembly\033[0m        Specify which assembly cache to download from VEP (default: false).   

""".stripIndent()
}

// Define workflow structure. Include some input/runtime tests here.
// See https://www.nextflow.io/docs/latest/dsl2.html?highlight=workflow#workflow
workflow {

// Show help message if --help is run or (||) a required parameter (input) is not provided

if ( params.help == true || params.input == false || params.ref == false ){   
// Invoke the help function above and exit
	helpMessage()
	exit 1

// If none of the above are a problem, then run the workflow
} else {
	
// CREATE FASTA INDEXES 
def refFile = file(params.ref)
def refDir = refFile.parent
def refName = refFile.name

bwa_index_ch = file("${refDir}/${refName}.bwt").exists() ?
    Channel.value(file("${refDir}/${refName}.*")) :
    // If doesn't exist run indexing 
    bwa_index(refFile).fa_index

// VALIDATE INPUT SAMPLES 
reads_ch = channel.fromPath(params.input, checkIfExists: true)
  .splitCsv( header: true )
  // Convert fqs to paths
  .map { row -> [row.sample, file(row.fq1, checkIfExists: true), file(row.fq2, checkIfExists: true), row.platform, row.library, row.center] }

// Parse the flowcell and lanes from the fq1 header
extract_flowcell_lane(reads_ch)

// Get the flowcell and lane info from file
parsed_reads_ch = extract_flowcell_lane.out
  .map { sample, fq1, fq2, platform, library, center, flowcell_file, lane_file ->
    def flowcell = flowcell_file.readLines()[0]
    def lane = lane_file.readLines()[0]
    return [sample, fq1, fq2, platform, library, center, flowcell, lane]
  }

// FASTQC ON INPUT READS
fastqc_in = parsed_reads_ch
  // Goal of this is to group all pe-reads by sample
  // e.g. [ sample, [fq_a_1, fq_a_2, fq_b_1, fq_b_2, ..., fq_N_1, fq_N_2]]
  .map { sample, fq1, fq2, _platform, _library, _center, _flowcell, _lane -> [sample, fq1, fq2] }
  .map { sample, fq1, fq2 -> [sample, [fq1, fq2]] }
  .groupTuple(by: 0)
  .map { sample, fq_pair -> [ sample, fq_pair.flatten() ] }

fastqc(fastqc_in)

align_in = parsed_reads_ch
  // Group by sample, platform, library, center, flowcell, lane
  // For samples with multiple fastq read pairs, these will be passed into
  // pb_fq2bam while retaining read pairs are grouped correctly
  .map { sample, fq1, fq2, platform, library, center, flowcell, lane -> 
    [
      [fq1, fq2], // paired fqs
      sample, 
      platform, 
      library, 
      center, 
      flowcell, 
      lane 
    ]
  }
  .groupTuple(by:[1, 2, 3, 4, 5, 6, 7])

// ALIGN READS
pb_fq2bam(align_in, refFile, bwa_index_ch)

// QC ALIGNMENTS 
pb_collectmetrics(pb_fq2bam.out.bam, refFile, bwa_index_ch)

// CALL VARIANTS
// CURRENTLY pb_deepvariant ONLY OUTPUTS GVCF OR VCF PER SAMPLE, NOT BOTH 
pb_deepvariant(pb_fq2bam.out.bam, refFile, bwa_index_ch)

// JOINT GENOTYPE VARIANTS FOR COHORT
gvcf_list = pb_deepvariant.out.gvcf
  .map { _sample, gvcf -> [gvcf] }
  .collect()

glnexus_joint_call(gvcf_list)

// CONVERT BCF TO VCF
bcftools_convert(glnexus_joint_call.out.cohort_bcf)

// QC SUMMARY OF ALL SAMPLES IN COHORT VCF 
bcftools_stats(bcftools_convert.out.cohort_vcf, bcftools_convert.out.cohort_vcf_tbi)

// DOWNLOAD VEP CACHE AND ANNOTATE WITH DOWNLOADED CACHE
if (params.download_vep_cache){

	download_vep(params.vep_assembly, params.vep_species) 
  annotate_vcf(params.cohort_name, 
              bcftools_convert.out.cohort_vcf, 
              bcftools_convert.out.cohort_vcf_tbi,  
              params.vep_assembly, 
              params.vep_species,
              download_vep.out.cache)
}

// GENERATE MULTIQC REPORT
vep_report_ch = params.download_vep_cache ? annotate_vcf.out.vep_report : Channel.empty()

multiqc_in = fastqc.out.fastqc_results
          .concat(pb_fq2bam.out.qc_metrics, 
          pb_fq2bam.out.duplicate_metrics, 
          pb_collectmetrics.out.bam_metrics, 
          bcftools_stats.out.vcf_stats,
          vep_report_ch)
          .collect().ifEmpty([])

multiqc(multiqc_in, params.multiqc_config)
}}
