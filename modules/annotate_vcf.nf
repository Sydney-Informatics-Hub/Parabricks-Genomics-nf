process annotate_vcf {
    tag "ANNOTATE: ${shard}"
    publishDir "${params.outdir}/annotations", mode: 'symlink'
    container "${params.vep_container}"

    input:
    tuple val(shard), path(vcf), path(tbi)
    val vep_species
    val vep_assembly
    path vep_cache
    tuple path(fasta), path(fasta_fai)

    output:
    tuple val(shard), path("${shard}_annotated.vcf.gz"), path("${shard}_annotated.vcf.gz.tbi"), emit: vep_annotations
    path ("${shard}_annotated.vcf.gz_warnings.txt"), emit: vep_warnings, optional: true
    path ("${shard}_annotated.vcf.gz_summary.html"), emit: vep_report

    script:
    // Add further VEP options with `withName: annotate_vcf { ext.args = '...' }`
    def args = task.ext.args ?: ''
    """
    vep \
        --input_file ${vcf} \
        --output_file ${shard}_annotated.vcf.gz \
        --vcf --compress_output bgzip \
        --offline --cache --dir_cache ${vep_cache} \
        --fasta ${fasta} \
        --species ${vep_species} --assembly ${vep_assembly} \
        --fork ${task.cpus} \
        --symbol --biotype --canonical --mane \
        --hgvs \
        --check_existing \
        --af_gnomade --af_gnomadg --max_af \
        ${args}

    tabix -p vcf ${shard}_annotated.vcf.gz
    """
}
