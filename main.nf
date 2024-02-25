#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import processes to be run in the workflow
include { check_input_temp } from './modules/check_input_temp' 
include { bwa_index } from './modules/bwa_index'
include { pb_fq2bam } from './modules/pb_fq2bam'

// Print a header upon execution 
log.info """\

=======================================================================================
Genomics001: Parabricks-Genomics-nf 
=======================================================================================

Created by <YOUR NAME> 
Find documentation @ https://sydney-informatics-hub.github.io/Nextflow_DSL2_template_guide/
Cite this pipeline @ INSERT DOI

=======================================================================================
Workflow run parameters 
=======================================================================================
input       : ${params.input}
outdir      : ${params.outdir}
ref       	: ${params.ref}
workDir     : ${workflow.workDir}
=======================================================================================

"""

/// Help function 
// This is an example of how to set out the help function that 
// will be run if run command is incorrect or missing. 

def helpMessage() {
    log.info"""
  Usage:  nextflow run main.nf --input <samples.tsv> --ref <reference.fasta>

  Required Arguments:

  --input	Specify full path and name of sample
		input file (tab separated).

  Optional Arguments:

  --outdir	Specify path to output directory. 
	
""".stripIndent()
}

// Define workflow structure. Include some input/runtime tests here.
// See https://www.nextflow.io/docs/latest/dsl2.html?highlight=workflow#workflow
workflow {

// Show help message if --help is run or (||) a required parameter (input) is not provided

if ( params.help == true || params.input == false){   
// Invoke the help function above and exit
	helpMessage()
	exit 1
	// consider adding some extra contigencies here.
	// could validate path of all input files in list?
	// could validate indexes for reference exist?

// If none of the above are a problem, then run the workflow
} else {
	
// Define channels 
// See https://www.nextflow.io/docs/latest/channel.html#channels
// See https://training.nextflow.io/basic_training/channels/ 

//fasta = Channel.value("${params.fasta}")

outdir = Channel.value("${params.outdir}")

// VALIDATE INDEX 
check_input_temp(Channel.fromPath(params.input, checkIfExists: true))
input = Channel.fromPath("${params.input}")
		.splitCsv(header: true)
		.map { row -> tuple(row.sample, file(row.fq1), file(row.fq2), row.platform, row.library, row.center)}

// TODO make this work so we can validate inputs from samplesheet 
// TODO will need to capture multiple fq input pairs per sample i.e. split across lanes  
// TODO as per https://training.nextflow.io/advanced/grouping/ and https://github.sydney.edu.au/informatics/PIPE-4135-CMT_neurogenomics/blob/master/300_preprocessing/T2T-scripts/pb_fq2bam_make_input.sh 

//input = Channel.fromPath("${params.input}")
//		.splitCsv(header: true)
//		.map { row -> tuple(row.sample, row.fq1, row.fq2, row.platform, row.library, row.center)}

// INDEX REFERENCE
bwa_index(params.fasta)

// ALIGN READS
pb_fq2bam(input, params.fasta, bwa_index.out.fa_index)

}}

// Print workflow execution summary 
workflow.onComplete {
summary = """
=======================================================================================
Workflow execution summary
=======================================================================================

Duration    : ${workflow.duration}
Success     : ${workflow.success}
workDir     : ${workflow.workDir}
Exit status : ${workflow.exitStatus}
Output      : ${params.outdir}

=======================================================================================
  """
println summary

}
