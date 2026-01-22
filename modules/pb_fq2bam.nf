process pb_fq2bam {
    tag "SAMPLE: ${sample}"
    publishDir "${params.outdir}/bams/${sample}", mode: 'symlink'
    label "parabricks"

    input:
    // The fqs are passed as a val() as they are passed as a nested list
    // This list is unpacked in def in_fq() below.
    tuple val(paired_fqs), val(sample), val(platform), val(library), val(center), val(flowcell), val(lane)
    path fasta
    path fa_index

    output:
    tuple val(sample), path("*.bam"), path("*.bai"), emit: bam
    path ("*_qc_metrics"), emit: qc_metrics
    path ("*_pbrun_fq2bam_log.txt"), emit: metrics_logs
    path ("*_duplicate_metrics.txt"), emit: duplicate_metrics

    script:
    def args = task.ext.args ?: ''
    def in_fq = paired_fqs
        .collect { paired_fq ->
            "--in-fq ${paired_fq[0]} ${paired_fq[1]}"
        }
        .join(' \\\n')
    """
        pbrun fq2bam \\
          --ref ${fasta} \\
          ${in_fq} \\
          --read-group-sm ${sample} \\
          --read-group-lb ${library} \\
          --read-group-pl ${platform} \\
          --out-bam ${sample}_markdup.bam \\
          --out-duplicate-metrics ${sample}_duplicate_metrics.txt \\
          --out-qc-metrics-dir ${sample}_qc_metrics \\
          --bwa-options="-M" \\
          --fix-mate \\
          --optical-duplicate-pixel-distance 2500 \\
          --logfile ${sample}_pbrun_fq2bam_log.txt \\
          ${args}
    """
}
