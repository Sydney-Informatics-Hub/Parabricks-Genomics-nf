process pb_fq2bam {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/bams/${sample}", mode: 'symlink'
    label "parabricks"

    input:
    tuple val(sample), path(fq1), path(fq2), val(platform), val(library), val(center), val(flowcell), val(lane)
    path(fasta)
		path(fa_index)

    output:
    tuple val(sample), path("*.bam"), path("*.bai"), emit: bam
    path("*_qc_metrics"), emit: qc_metrics
    path("*_pbrun_fq2bam_log.txt"), emit: metrics_logs
    path("*_duplicate_metrics.txt"), emit: duplicate_metrics
    
    script:
    def args = task.ext.args ?: ''
        """
        pbrun fq2bam \\
          --ref ${fasta} \\
          --in-fq ${fq1} ${fq2} \\
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
          $args
    """
}
