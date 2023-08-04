// Define the process
process processTwo {
	// Define directives 
	// See: https://www.nextflow.io/docs/latest/process.html#directives
	debug = true //turn to false to stop printing command stdout to screen
	publishDir "${params.outDir}/process2", mode: 'copy'

	// Define input 
	// See: https://www.nextflow.io/docs/latest/process.html#inputs
	input:
	file("process1out.txt")

	// Define output(s)
	// See: https://www.nextflow.io/docs/latest/process.html#outputs
	output:
	path("process2out.txt")

	// Define code to execute 
	// See: https://www.nextflow.io/docs/latest/process.html#script
	script:
	"""
    tac processed_cohort.txt | rev \
    	> process2out.txt
	"""
 }