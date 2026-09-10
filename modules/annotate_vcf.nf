process annotate_vcf {
    tag "COHORT: ${params.cohort_name}"
    publishDir "${params.outdir}/annotations", mode: 'symlink'
    container 'quay.io/lifebitaiorg/vep-nf:v110.1'

    input:
    val cohort_name
    path cohort_vcf
    path cohort_vcf_tbi
    val vep_assembly
    val vep_species
    path vep_cache

    output:
    path ("${params.cohort_name}_annotated.vcf.gz"), emit: vep_annotations
    path ("${params.cohort_name}_annotated.vcf.gz_warnings.txt"), emit: vep_warnings, optional: true
    path ("${params.cohort_name}_annotated.gz_summary.html"), emit: vep_report

    script:
    def args = task.ext.args ?: ''
    """
    vep \
        --input_file "${params.cohort_name}" \
        --output_file "${params.cohort_name}_annotated.vcf.gz" \
        --vcf --compress_output bgzip \
        --offline --cache --dir_cache vep_cache \
        --species homo_sapiens --assembly GRCh38 \
        --fork ${task.cpus} \
        --symbol --canonical --mane --biotype --tsl --appris \
        --ccds --protein --uniprot --xref_refseq \
        --transcript_version --gene_version \
        --domains --numbers --gene_phenotype --regulatory --nearest=gene \
        --sift b --polyphen b \
        --check_existing --var_synonyms --pubmed --variant_class \
        --af_gnomade --af)gnomadg --max_af \
        --hgvs --hgvsg --spdi --shift_hgvs=1 \
        ${args}
    """
}
