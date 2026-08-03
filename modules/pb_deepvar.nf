process pb_deepvariant {
    tag "SAMPLE: ${sample}"
    publishDir "${params.outdir}/variants/${sample}", mode: 'symlink'
    label "parabricks"

    input:
    tuple val(sample), path(bam), path(bai)
    path fasta
    path fa_index

    output:
    tuple val(sample), path("*.g.vcf.gz"), emit: gvcf
    tuple val(sample), path("*_deepvariant_log.txt"), emit: metrics_logs

    script:
    def args = task.ext.args ?: ''
    // See: https://docs.nvidia.com/clara/parabricks/tool-reference/tools/deepvariant#source-of-mismatches
    // --disable-small-model must accompany --use-wes-model to match Google DeepVariant's WES behaviour
    def exome_args = params.exome ? '--use-wes-model --disable-small-model' : ''
    """
    echo "=== Parabricks version check (expected: ${params.parabricks_version}) ==="
    pbrun version
    echo "========================================================================="

    pbrun deepvariant \\
      --ref ${fasta} \\
      --in-bam ${bam} \\
      --out-variants ${sample}.g.vcf.gz \\
      --gvcf \\
      --logfile ${sample}_deepvariant_log.txt \\
      ${exome_args} \\
      ${args}
    """
}
