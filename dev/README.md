# Dev Assets

This folder contains scripts and assets for benchmarking and optimisation. These are not required for production runs or ongoing testing.


## Download data 

RM83898_U1a: tiny NA12878 subset total of 9GB FASTQ reads

platinum3: n=3 platinum genomes at ~30x.

`dl_giab_small.sh` and `dl_platinum.sh` contains the code to get paired-end FASTQ reads. These are stored in `/g/data/er01/parabricks_4.6.0`.

Reference genome used is `/g/data/if89/data_library/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna`

## Running the tests

CSV samplesheets are in each of the dataset subfolders. Change this in the following script and run:

```bash
# cd into repo root
bash tests/run_gadi_benchmark.sh
```

## Getting the log outputs.

Use SIH's [`HPC_usage_reports`](https://github.com/Sydney-Informatics-Hub/HPC_usage_reports/tree/match_nf_logs) to pull out PBS logs for each process. Example for one run:

```bash
# Get work dirs and task names
nextflow log thirsty_shockley -f 'name,status,native_id,workdir' > nf_log.txt

# Get usage stats from PBS logs
HPC_usage_reports/Scripts/gadi_nfcore_report.sh

# Combine
HPC_usage_reports/Scripts/match_nf_logs.py -n nf_log.tsv -l gadi_nf-core-joblogs.tsv
```

## Save and store

```bash
#!/bin/bash

#PBS -P er01
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l jobfs=200GB
#PBS -l walltime=02:00:00
#PBS -l storage=scratch/er01+gdata/er01
#PBS -l wd

cd /scratch/er01/fj9712
tar -czf 260219_platinum3.tar.gz platinum
cp -v 260219_platinum3.tar.gz /g/data/er01/parabricks_4.6.0/
# OR
#tar -czf 260219_U1a.tar.gz Parabricks-Genomics-nf
#cp -v 260219_U1a.tar.gz /g/data/er01/parabricks_4.6.0/
```