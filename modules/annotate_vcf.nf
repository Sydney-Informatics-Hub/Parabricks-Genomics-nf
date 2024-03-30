process annotate_vcf {
    tag "COHORT: ${params.cohort_name}" 
    publishDir "${params.outdir}/annotations", mode: 'symlink'
    container 'quay.io/lifebitaiorg/vep-nf:v110.1' 

    input:
    val(cohort_name)
    path(cohort_vcf)
    path(cohort_vcf_tbi)
    val(vep_assembly)
    val(vep_species)
    path(vep_cache)

    output:
    path("${params.cohort_name}_annotated.gz"), emit: vep_annotations
    path("${params.cohort_name}_annotated.gz_warnings.txt"), emit: vep_warnings
    path("${params.cohort_name}_annotated.gz_summary.html"), emit: vep_report

    script:
    def args = task.ext.args ?: ''
    """
    vep -i ${params.cohort_name}.vcf.gz \
        -o ${params.cohort_name}_annotated.gz \
        $args \
        --assembly ${params.vep_assembly} \
        --species ${params.vep_species} \
        --cache \
        --dir_cache vep_cache \
        --compress_output bgzip \
        --fork ${task.cpus} 
    """
}