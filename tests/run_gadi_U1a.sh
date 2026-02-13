module load nextflow singularity
nextflow run main.nf \
    --input dev/RM8398_U1a/giab_small.csv \
    --ref /g/data/if89/data_library/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna \
    --gadi_account er01 \
    --storage_account "gdata/if89+gdata/er01+scratch/er01" \
    -profile gadi -resume 