process bcftools_stats {
    tag "COHORT: ${params.cohort_name}" 
    publishDir "${params.outdir}/variants", mode: 'symlink'
    container "quay.io/biocontainers/bcftools:1.17--h3cc50cf_1"

    input:
    path("${params.cohort_name}.vcf.gz")
    path("${params.cohort_name}.vcf.gz.tbi") 

    output:
    path("${params.cohort_name}.vcf.gz.stats"), emit: vcf_stats
    
    script:
    """
    # COLLECT COHORT VCF STATS 
    bcftools stats ${params.cohort_name}.vcf.gz \
      --samples "-" \
      > ${params.cohort_name}.vcf.gz.stats
    """

}