process check_input {
    // TODO tag ""
    // TODO label 
    container 'https://depot.galaxyproject.org/singularity/python:3.8.3'

    input:
		path input
    
    output:
    path 'samplesheet.csv' , emit: samplesheet

    script: // This process runs ../bin/samplesheetchecker.py 
    """
		samplesheetchecker.py \\
        $input \\
        samplesheet.csv
    """
}
