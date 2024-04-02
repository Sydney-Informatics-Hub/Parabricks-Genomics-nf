#!/bin/bash 

#### THIS IS A TESTING SCRIPT #####
## FOR LOCAL TESTING, BEFORE RUNNING THIS SCRIPT, ENTER A INTERACTIVE JOB WITH:  
## qsub -I -Piz89 -qgpuvolta -lncpus=24,ngpus=2,mem=380GB,storage=scratch/er01 

## RUN THIS SCRIPT FROM THE Parabricks-Genomics-nf DIRECTORY WITH:
## bash bin/run_script.sh

ref=/scratch/er01/gs5517/workflowDev/Parabricks-Genomics-nf/test/test_chr21.fa
input=/scratch/er01/gs5517/workflowDev/Parabricks-Genomics-nf/test/multipair_samples.csv
vep_species=homo_sapiens
vep_assembly=GRCh38
vep_cachedir=/scratch/er01/gs5517/workflowDev/Parabricks-Genomics-nf/test/VEPcache

module load nextflow
module load singularity

nextflow run main.nf \
    --ref ${ref} \
    --download_vep_cache \
    --vep_cachedir ${vep_cachedir} \
    --vep_assembly ${vep_assembly} \
    --vep_species ${vep_species} \
    --input ${input} \
    --cohort_name myname \
    --outdir results \
    --gadi_account iz89 \
    --storage_account er01 \
    --whoami gs5517 \
    -resume -profile gadi
