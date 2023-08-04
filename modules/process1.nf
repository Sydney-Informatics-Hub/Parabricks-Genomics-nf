// Define the process
process processOne {	
	// Define directives 
	// See: https://www.nextflow.io/docs/latest/process.html#directives
	debug = true //turn to false to stop printing command stdout to screen
	publishDir "${params.outDir}/process1", mode: 'copy'

	// Define input 
	// See: https://www.nextflow.io/docs/latest/process.html#inputs
	input:
	val input

	// Define output(s)
	// See: https://www.nextflow.io/docs/latest/process.html#outputs
	output:
	path ("process1out.txt"), emit: File
	
	// Define code to execute 
	// See: https://www.nextflow.io/docs/latest/process.html#script
	script:
	"""
	echo $params.input | tr '[a-z]' '[A-Z]' \
		> process1out.txt
	"""
}