process pb_deepvariant {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/variants/${sample}", mode: 'symlink'
    label "parabricks"

    input:
    tuple val(sample), path(bam), path(bai) 
    path(fasta)
    path(fa_index)

    output:
    tuple val(sample), path("*.g.vcf.gz"), emit: gvcf
    tuple val(sample), path("*_deepvariant_log.txt"), emit: metrics_logs
    
    script:
    def args = task.ext.args ?: ''
    """
    pbrun deepvariant \\
      --ref ${fasta} \\
      --in-bam ${bam} \\
      --out-variants ${sample}.g.vcf.gz \\
      --gvcf \\
      --logfile ${sample}_deepvariant_log.txt \\
      $args
    """
}

