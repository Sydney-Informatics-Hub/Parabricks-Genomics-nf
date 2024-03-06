process bcftools_convert {
    tag "JOINT GENOTYPING: ${params.cohort_name}" 
    publishDir "${params.outdir}/variants", mode: 'symlink'
    container "quay.io/biocontainers/bcftools:1.17--h3cc50cf_1"

    input:
    path("${params.cohort_name}.bcf") 

    output:
    path("${params.cohort_name}.vcf.gz"), emit: cohort_vcf
    path("${params.cohort_name}.vcf.gz.tbi"), emit: cohort_vcf_tbi
    
    script:
    """
    # CONVERT BCF TO VCF.GZ
    bcftools view ${params.cohort_name}.bcf \
      -Oz -o ${params.cohort_name}.vcf.gz

    # INDEX VCF.GZ
    tabix ${params.cohort_name}.vcf.gz
    """
}