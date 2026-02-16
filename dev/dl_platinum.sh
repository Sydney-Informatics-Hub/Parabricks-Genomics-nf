#!/bin/bash

#PBS -P er01
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l jobfs=200GB
#PBS -l walltime=10:00:00
#PBS -l storage=scratch/er01+gdata/er01
#PBS -l wd

# Gadi interactive (copyq) example:
# qsub -I -P er01 -q copyq -l walltime=02:00:00 -l ncpus=1 -l mem=8GB -l storage=scratch/er01+gdata/er01

# Platinum genomes from
# https://www.internationalgenome.org/data-portal/data-collection/illumina_platinum_ped
# https://www.ebi.ac.uk/ena/browser/view/ERP001960

cd /g/data/er01/parabricks_4.6.0/illumina_platinum_ped

# NA12878_30x
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194146/ERR194146_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194146/ERR194146_2.fastq.gz

# NA12892_30x
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194161/ERR194161_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194161/ERR194161_2.fastq.gz

# NA1287_30x
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194147/ERR194147_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194147/ERR194147_2.fastq.gz