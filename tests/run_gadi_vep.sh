#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -P<project> -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/<project>

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash tests/run_gadi_vep.sh
module load nextflow/25.04.6
module load ingularity

nextflow run main.nf \
	-params-file tests/params/gadi_vep.json
    -profile gadi -resume
