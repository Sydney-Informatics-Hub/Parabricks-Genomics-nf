#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import processes to be run in the workflow
include { check_input } from './modules/check_input' 
include { bwa_index } from './modules/bwa_index'
include { pb_fq2bam } from './modules/pb_fq2bam'
include { pb_deepvariant } from './modules/pb_deepvar'

// Print a header upon execution 
log.info """\

=======================================================================================
Genomics001: Parabricks-Genomics-nf 
=======================================================================================

Created by Georgie Samaha
Find documentation @ https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf
Cite this pipeline @ INSERT DOI

=======================================================================================
Workflow run parameters 
=======================================================================================
input       : ${params.input}
outdir      : ${params.outdir}
ref         : ${params.ref}
workDir     : ${workflow.workDir}
=======================================================================================

"""

/// Help function 
// This is an example of how to set out the help function that 
// will be run if run command is incorrect or missing. 

def helpMessage() {
    log.info"""
  Usage:  nextflow run main.nf --input <samples.csv> --ref <reference.fasta> --gadi_account <project code>

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
outdir = Channel.value("${params.outdir}")

// CREATE FASTA INDEXES 
def refFile = file(params.ref)
def refDir = refFile.parent
def refName = refFile.name

// CHECK IF INDEXES EXIST
if (!file("${refDir}/${refName}.bwt").exists()) {
    // If the index file does not exist, run the bwa_index process
    bwa_index(params.ref)
} else {
    log.info "BWA indexes already exist for ${params.ref}" 
}

// VALIDATE INPUT SAMPLES 
check_input(Channel.fromPath(params.input, checkIfExists: true))

// ALIGN READS
// TODO dry this out, its very verbose because I don't understand Groovy
align_in = check_input.out.samplesheet
  .splitCsv(header: true)
  .map { row -> tuple(row.sample, row.fq1, row.fq2, row.platform, row.library, row.center, row.flowcell, row.lane)}
  .map{it -> 
    def sample = it[0]
    def fq1 = it[1]
    def fq2 = it[2]
    def platform = it[3]
    def library = it[4]
    def center = it[5]
    def flowcell = it[6]
    def lane = it[7]
    def fq_in = "--in-fq $fq1 $fq2"
    return [sample, fq_in, platform, library, center, flowcell, lane]}
  .groupTuple(by: [0, 2, 3, 4, 5, 6])
  .map { it -> 
    def sample = it[0]
    def fq_in_list = it[1].join(' ')
    def platform = it[2]
    def library = it[3]
    def center = it[4]
    def flowcell = it[5]
    def lane = it[6]
    return [sample, fq_in_list, platform, library, center, flowcell, lane] } // Group by sample, platform, library, center
  .groupTuple(by:[0, 2, 3, 4, 5, 6])
  //.view()

pb_fq2bam(align_in, params.ref, bwa_index.out.fa_index)

// CALL VARIANTS
pb_deepvariant(pb_fq2bam.out.bam, params.ref, bwa_index.out.fa_index)
}}