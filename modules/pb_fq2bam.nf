process pb_fq2bam {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/bams/${sample}", mode: 'symlink'
    module "parabricks"
    stageInMode "copy" //Parabricks requires the files to be non-symlinked

    input:
    tuple val(sample), val(fq_in_list), val(platform), val(library), val(center), val(flowcell), val(lane)
    path(fasta)
		path(fa_index)

    output:
    tuple val(sample), path("*.bam"), path("*.bai"), emit: bam
    tuple val(sample), path("*_qc_metrics"), path("*_pbrun_fq2bam_log.txt"), path("*_duplicate_metrics.txt"), emit: metrics_logs
    
    script:
    def args = task.ext.args ?: ''
    def fq_in_list = fq_in_list.join(' ')
        """
        pbrun fq2bam \\
          --ref ${fasta} \\
          ${fq_in_list} \\
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