#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -P<project> -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/<project>

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash bin/run_script.sh

ref=<path>/Parabricks-Genomics-nf/test/test_chr21.fa
input=<path>/Parabricks-Genomics-nf/test/multipair_samples.csv
vep_species=homo_sapiens
vep_assembly=GRCh38
vep_cachedir=<path>/Parabricks-Genomics-nf/test/VEPcache

module load nextflow
module load singularity

nextflow run main.nf \
    --ref ${ref} \
    --download_vep_cache \
    --vep_cachedir ${vep_cachedir} \
    --vep_assembly ${vep_assembly} \
    --vep_species ${vep_species} \
    --input ${input} \
    --cohort_name test \
    --outdir test \
    --gadi_account <ACCOUNT> \
    --storage_account <ACCOUNT> \
    --whoami $(whoami) \
    -resume -profile gadi
