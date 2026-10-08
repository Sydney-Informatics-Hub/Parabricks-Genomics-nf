process concat_vcf {
    tag "COHORT: ${params.cohort_name}"
    publishDir "${params.outdir}/annotations", mode: 'symlink'
    container "quay.io/biocontainers/bcftools:1.17--h3cc50cf_1"

    input:
    path contigs
    path shards
    path shard_tbis

    output:
    path ("${params.cohort_name}_annotated.vcf.gz"), emit: vep_annotations
    path ("${params.cohort_name}_annotated.vcf.gz.tbi"), emit: vep_annotations_tbi

    script:
    // Concatenate in reference contig order rather than whatever order the shards
    // completed in, so the output stays coordinate-sorted without a re-sort.
    """
    awk 'NF {print \$1"_annotated.vcf.gz"}' ${contigs} > filelist.txt

    bcftools concat -f filelist.txt \
        -Oz -o ${params.cohort_name}_annotated.vcf.gz

    tabix -p vcf ${params.cohort_name}_annotated.vcf.gz
    """
}
