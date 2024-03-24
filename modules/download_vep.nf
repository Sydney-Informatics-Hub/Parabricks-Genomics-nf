process download_vep {
    tag "DOWNLOADING_CACHE: ${params.vep_species}" 
    publishDir "${params.outdir}", mode: 'symlink'

    output:
    path("homo_sapiens_vep_111_GRCh38"), emit: vep_cache
    
    script:
    """
    # Download and extract GRCh38 cache 
    curl -O https://ftp.ensembl.org/pub/release-111/variation/indexed_vep_cache/homo_sapiens_vep_111_GRCh38.tar.gz && \
    mkdir -p homo_sapiens_vep_111_GRCh38 && \
    mv homo_sapiens_vep_111_GRCh38.tar.gz homo_sapiens_vep_111_GRCh38/ && \
    (
      cd homo_sapiens_vep_111_GRCh38 && \
      tar xzf homo_sapiens_vep_111_GRCh38.tar.gz
        )
    """
}