#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Import processes to be run in the workflow
include { check_input } from './modules/check_input' 
include { bwa_index } from './modules/bwa_index'
//include { pb_fq2bam } from './modules/pb_fq2bam'

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

//ref = Channel.value("${params.ref}")

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
samplesheet_out = check_input.out.samplesheet
		.splitCsv(header: true)
		.map { row -> tuple(row.sample, row.fq1, row.fq2, row.platform, row.library, row.center, row.flowcell, row.lane)}
    //.view()

// ALIGN READS
//pb_fq2bam(check_input.out.samplesheet, params.ref, bwa_index.out.fa_index)

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
