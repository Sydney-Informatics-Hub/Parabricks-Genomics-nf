process pb_fq2bam {
    tag "SAMPLE: ${sample}"
    // TODO label 
    module "parabricks"

    /*
    Parabricks requires the files to be non-symlinked
    Do not change the stageInMode to soft linked! 
    */
    stageInMode "copy"

    input:
    tuple val(sample), path(fq1), path(fq2), val(platform), val(library), val(center), val(flowcell), val(lane) 
    path(fasta)
		path(fa_index)

    output:
    tuple val(sample), path("*.bam"), emit: bam
    tuple val(sample), path("*.bai"), emit: bai
    path "qc_metrics", emit: qc_metrics
		path "pbrun_fq2bam_log.txt", emit: fq2bam_log
    path "duplicate_metrics.txt", emit: duplicate_metrics

    script:
		def in_fq_command = "--in-fq $fq1 $fq2" 
    def args = task.ext.args ?: ''
		// TODO pass flowcell from fq1 header
		// TODO pass lane from fq1 header
    """
		pbrun fq2bam \\
			--ref ${fasta} \\
			--in-fq ${fq1} ${fq2} \\
			--read-group-sm ${sample} \\
			--read-group-lb ${library} \\
			--read-group-pl ${platform} \\
			--out-bam ${sample}_markdup.bam \\
			--out-duplicate-metrics duplicate_metrics.txt \\
			--out-qc-metrics-dir qc_metrics \\
			--bwa-options="-M" \\
			--fix-mate \\
			--optical-duplicate-pixel-distance 2500 \\
			--logfile pbrun_fq2bam_log.txt \\
			$args
    """
}