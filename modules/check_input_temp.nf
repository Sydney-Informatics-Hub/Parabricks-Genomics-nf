process check_input_temp {
// TODO replace this with check_input.nf
	
	input:
	path input

	output:
	file "samplesheet.csv"
		
	script:
	"""
	cat "${params.input}" > samplesheet.csv
	"""
}
