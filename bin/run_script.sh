#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -Piz89 -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/er01 

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash bin/run_script.sh

ref=/scratch/er01/gs5517/workflowDev/Parabricks-Genomics-nf/test/test_chr21.fa
input=/scratch/er01/gs5517/workflowDev/Parabricks-Genomics-nf/test/multipair_samples.csv

module load nextflow
module load singularity

nextflow run main.nf \
    --ref $ref \
    --input $input \
    --outdir test -resume
