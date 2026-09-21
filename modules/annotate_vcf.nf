process annotate_vcf {
    tag "ANNOTATE: ${shard}"
    // Shards go to a subdirectory; when not scattering this process produces the
    // final output, so it publishes alongside it instead.
    publishDir { params.vep_scatter ? "${params.outdir}/annotations/shards"
                                    : "${params.outdir}/annotations" }, mode: 'symlink'
    container 'quay.io/biocontainers/ensembl-vep:116.2--pl5321h2a3209d_0'

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
    // Add further VEP options with `params.vep_extra_args`
    def args = task.ext.args ?: (params.vep_extra_args ?: '')
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
        --protein --uniprot \
        --check_existing \
        --af_gnomade --af_gnomadg --max_af \
        ${args}

    tabix -p vcf ${shard}_annotated.vcf.gz
    """
}
