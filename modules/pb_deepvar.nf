// --disable-small-model was only introduced in Parabricks 4.7.0; older versions reject it as unrecognised
def versionAtLeast(String version, String minVersion) {
    def v = version.tokenize('.').collect { it.toInteger() }
    def m = minVersion.tokenize('.').collect { it.toInteger() }
    def maxLen = Math.max(v.size(), m.size())
    def vPadded = v + ([0] * (maxLen - v.size()))
    def mPadded = m + ([0] * (maxLen - m.size()))
    def diff = [vPadded, mPadded].transpose().find { it[0] != it[1] }
    return diff ? diff[0] > diff[1] : true
}

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
    // --disable-small-model should accompany --use-wes-model to match Google DeepVariant's WES behaviour,
    // but is only supported from Parabricks 4.7.0 onwards
    def exome_args = params.exome ?
        (versionAtLeast(params.parabricks_version, '4.7.0') ? '--use-wes-model --disable-small-model' : '--use-wes-model') :
        ''
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
