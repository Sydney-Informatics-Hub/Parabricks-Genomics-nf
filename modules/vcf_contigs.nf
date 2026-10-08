process vcf_contigs {
    tag "COHORT: ${params.cohort_name}"
    container "quay.io/biocontainers/bcftools:1.17--h3cc50cf_1"

    input:
    path vcf
    path tbi

    output:
    path ("contigs.txt"), emit: contigs

    script:
    """
    tabix --list-chroms ${vcf} > contigs.txt
    """
}
