#!/bin/bash

#PBS -P er01
#PBS -l ncpus=32
#PBS -l ngpus=2
#PBS -l mem=250GB
#PBS -l jobfs=200GB
#PBS -l walltime=6:00:00
#PBS -q dgxa100
#PBS -W umask=022
#PBS -l wd
#PBS -lstorage=gdata/er01+scratch/er01+gdata/if89

fasta="/g/data/if89/data_lib/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna"
in_fq="/g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R1_001.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R2_001.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R1_002.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R2_002.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R1_003.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R2_003.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R1_004.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R2_004.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R1_005.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L001_R2_005.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R1_001.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R2_001.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R1_002.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R2_002.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R1_003.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R2_003.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R1_004.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R2_004.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R1_005.fastq.gz /g/data/er01/parabricks_4.6.0/U1a_ACAGTG_L002_R2_005.fastq.gz"
sample="RM8398_U1a"
library="1"
platform="illumina"

module load parabricks/4.6.0
pbrun fq2bam \\
  --ref ${fasta} \\
  ${in_fq} \\
  --read-group-sm ${sample} \\
  --read-group-lb ${library} \\
  --read-group-pl ${platform} \\
  --out-bam ${sample}_markdup.bam \\
  --out-duplicate-metrics ${sample}_duplicate_metrics.txt \\
  --out-qc-metrics-dir ${sample}_qc_metrics \\
  --bwa-options="-M" \\
  --fix-mate \\
  --optical-duplicate-pixel-distance 2500 \\
  --logfile ${sample}_pbrun_fq2bam_log.txt
