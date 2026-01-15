#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -P<project> -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/<project>

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash bin/run_script.sh
ref=${PWD}/test_data/test_chr21.fa
input=${PWD}/test_data/samplesheets/multipair_samples.csv
gadi_account=er01
storage_account=er01

module load nextflow
module load singularity

nextflow run main.nf \
    --ref ${ref} \
    --input ${input} \
    --gadi_account ${gadi_account} \
    --storage_account ${storage_account} \
    --whoami $(whoami) \
    -resume -profile gadi
