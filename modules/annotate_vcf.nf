process annotate_vcf {
    tag "ANNOTATING: ${params.cohort_name}" 
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
    path("*"), optional: true
    //path("${params.cohort_name}.vcf.gz"), emit: cohort_vcf
    //path("${params.cohort_name}.vcf.gz.tbi"), emit: cohort_vcf_tbi
    
    script:
    def args = task.ext.args ?: ''
    """
    vep -i ${params.cohort_name}.vcf.gz \
        -o ${params.cohort_name}_VEP.gz \
        $args \
        --assembly ${params.vep_assembly} \
        --species ${params.vep_species} \
        --cache ${params.vep_cachedir} \
        --fork ${task.cpus} 
    """
}