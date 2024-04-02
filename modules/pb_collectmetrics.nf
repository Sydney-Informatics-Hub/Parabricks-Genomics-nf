process pb_collectmetrics {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/bams/${sample}", mode: 'symlink'
    module "parabricks"
    stageInMode "copy" //Parabricks requires the files to be non-symlinked

    input:
    tuple val(sample), path(bam), path(bai) 
    path(fasta)
    path(fa_index)

    output:
    path("*.bam_metrics.txt"), emit: bam_metrics
    path("*_collectBamMetrics_log.txt"), emit: metrics_logs
    
    script:
    def args = task.ext.args ?: ''
    """
    pbrun bammetrics \\
      --ref ${fasta} \\
      --bam ${bam} \\
      --out-metrics-file ${sample}.bam_metrics.txt \\
      --logfile ${sample}_collectBamMetrics_log.txt \\
      --num-threads ${task.cpus} \\
      $args
    """
}