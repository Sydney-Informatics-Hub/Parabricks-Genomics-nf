#!/usr/bin/env nextflow

/// To use DSL-2 will need to include this
nextflow.enable.dsl=2

// =================================================================
// main.nf is the pipeline script for a nextflow pipeline
// Should contain the following sections:
	// Process definitions
    // Channel definitions
    // Workflow structure
	// Workflow summary logs 

// Examples are included for each section. Remove them and replace
// with project-specific code. For more information see:
// https://www.nextflow.io/docs/latest/index.html.
//
// ===================================================================

// Import processes to be run in the workflow
include { check_input_temp } from './modules/check_input_temp' 
include { bwa_index } from './modules/bwa_index'

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
fasta				: ${params.fasta}
workDir     : ${workflow.workDir}
=======================================================================================

"""

/// Help function 
// This is an example of how to set out the help function that 
// will be run if run command is incorrect or missing. 

def helpMessage() {
    log.info"""
  Usage:  nextflow run main.nf --input <samples.tsv> 

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
//input = Channel.fromPath("${params.input}")
//		.splitCsv(header: true)
//		.map { row -> tuple(row.sample, row.fq1, row.fq2, row.platform, row.library, row.center)}

// INDEX REFERENCE
bwa_index(params.fasta)

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
