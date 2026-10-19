process split_vcf {
    tag "SHARD: ${contig}"
    container "quay.io/biocontainers/bcftools:1.17--h3cc50cf_1"

    input:
    tuple val(contig), path(vcf), path(tbi)

    output:
    tuple val(contig), path("${contig}.vcf.gz"), path("${contig}.vcf.gz.tbi"), emit: shard

    script:
    """
    bcftools view -r ${contig} ${vcf} -Oz -o ${contig}.vcf.gz
    tabix -p vcf ${contig}.vcf.gz
    """
}
