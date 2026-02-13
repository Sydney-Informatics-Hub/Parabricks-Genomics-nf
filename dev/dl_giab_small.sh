#!/usr/bin/env bash
set -euo pipefail

# Gadi interactive (copyq) example:
# qsub -I -P er01 -q copyq -l walltime=02:00:00 -l ncpus=1 -l mem=8GB -l storage=scratch/er01

GIAB_BASE="https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/140207_D00360_0013_AH8G92ADXX/Project_RM8398/Sample_U1a/"

# The directory listing page doesn't always recurse cleanly with wget,
# so parse the listing and download each FASTQ explicitly.
curl -fsSL "${GIAB_BASE}/" \
  | grep -oE 'href="[^"]+\.fastq\.gz"' \
  | sed -E 's/^href="(.*)"/\1/' \
  | sort -u \
  | while read -r fq; do
      wget -c "${GIAB_BASE}/${fq}"
    done

wget $GIAB_BASE/SampleSheet.csv