#!/bin/bash
# Run on a persistent session `bash tests/run_gadi_benchmark.sh`

module load nextflow singularity
nextflow run main.nf \
    --input dev/platinum3/plat3_samples.csv \
    --ref /g/data/if89/data_library/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna \
    --gadi_account er01 \
    --storage_account "gdata/if89+gdata/er01+scratch/er01" \
    --download_vep_cache \
    --vep_species "homo_sapiens" \
    --vep_assembly "GRCh38" \
    -profile gadi -resume 