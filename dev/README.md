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

## Getting the log outputs

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

## Reporting with the `nf-gadi` plugin  

The [`nf-gadi` plugin](https://github.com/AustralianBioCommons/nf-gadi) provides a usage report for the pipeline. The output is similar to a trace file with useful information about
HPC usage, such as the `Queue`, `Service Units`, and `Efficiency`. 

An example output using the `nf-gadi` plugin:

```
Name,Process,Queue,Service Units,CPUs,CPU time,Used Walltime,Requested Walltime,Used Memory,Requested Memory,Used JobFS,Requested JobFS,Efficiency,Exit Code
extract_flowcell_lane (INPUT: earlycasualcaiman),extract_flowcell_lane,null,null,null,null,null,null,null,null,null,null,null,null
extract_flowcell_lane (INPUT: earlycasualcaiman),extract_flowcell_lane,null,null,null,null,null,null,null,null,null,null,null,null
bwa_index (FASTA: test_chr21.fa),bwa_index,normal,0.00,2,00:00:00,00:00:02,10:00:00,57.93MB,8.0GB,0B,100.0MB,0.00,0
fastqc (SAMPLE: earlycasualcaiman),fastqc,normal,0.01,1,00:00:05,00:00:09,10:00:00,466.98MB,4.0GB,0B,100.0MB,0.56,0
pb_fq2bam (SAMPLE: earlycasualcaiman),pb_fq2bam,dgxa100,5.60,64,00:05:26,00:01:10,04:00:00,129.5GB,380.0GB,0B,100.0MB,0.07,0
pb_collectmetrics (SAMPLE: earlycasualcaiman),pb_collectmetrics,dgxa100,0.24,16,00:00:04,00:00:12,01:00:00,106.18MB,190.0GB,0B,100.0MB,0.02,0
pb_deepvariant (SAMPLE: earlycasualcaiman),pb_deepvariant,dgxa100,1.04,64,00:01:28,00:00:13,04:00:00,6.36GB,380.0GB,0B,100.0MB,0.11,0
glnexus_joint_call (JOINT GENOTYPING: cohort),glnexus_joint_call,normal,0.08,48,00:00:01,00:00:03,10:00:00,256.6MB,190.0GB,0B,100.0MB,0.01,0
bcftools_convert (COHORT: cohort),bcftools_convert,normal,0.00,1,00:00:00,00:00:02,10:00:00,94.15MB,4.0GB,0B,100.0MB,0.00,0
```

To run:

```bash
bash run_gadi_simple_plugin.sh
```

The `-plugins nf-gadi@1.2.0` option is appended to the command.