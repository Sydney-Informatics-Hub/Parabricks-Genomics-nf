#!/bin/bash

#PBS -P er01
#PBS -l ncpus=64
#PBS -l ngpus=4
#PBS -l mem=500GB
#PBS -l jobfs=200GB
#PBS -l walltime=6:00:00
#PBS -q dgxa100
#PBS -W umask=022
#PBS -l wd
#PBS -lstorage=gdata/er01+scratch/er01

fasta="/g/data/if89/data_lib/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna"
in-bam="" # TODO Once fq2bam_U1a.sh is incoporated
sample="RM8398_U1a"
platform="illumina"

module load parabricks/4.6.0
pbrun deepvariant \\
  --ref ${fasta} \\
  --in-bam ${bam} \\
  --out-variants ${sample}.g.vcf.gz \\
  --gvcf \\
  --logfile ${sample}_deepvariant_log.txt \\