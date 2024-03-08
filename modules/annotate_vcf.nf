process annotate_vep {
    tag "CACHE: ${params.vep_cache}" 
    publishDir "${params.outdir}/variants", mode: 'symlink'
    container "docker.io/ensemblorg/ensembl-vep:release_107.0"

    input:
    path(cohort_vcf) 
    path(cohort_vcf_tbi)
    path(vep_cache) //TODO automate download of cache

    //output:
    //path("${params.cohort_name}.vcf.gz"), emit: cohort_vcf
    //path("${params.cohort_name}.vcf.gz.tbi"), emit: cohort_vcf_tbi
    
    script:
    def args = task.ext.args ?: ''
    """
    vep \\
        -i ${params.cohort_name}.vcf.gz \\
        -o ${params.cohort_name}_vep.txt.gz \\
        --assembly ${params.vep_genome} \\
        --species ${params.vep_species} \\
        --cache \\
        --dir_cache ${params.vep_cache} \\
        --fork ${task.cpus} \\
        --offline \\
        $args \\
    """
}