#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -P<project> -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/<project>

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash bin/run_gadi_simple.sh
module load nextflow/25.04.6
module load singularity

nextflow run main.nf \
    -params-file params/gadi_simple.json \
    -profile gadi -resume
