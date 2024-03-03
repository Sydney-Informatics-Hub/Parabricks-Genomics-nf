process bwa_index {
    tag "FASTA: ${ref.fileName}"
		publishDir "${params.outdir}/bwa_index", mode: 'symlink'
    container 'quay.io/biocontainers/bwa:0.7.17--he4a0461_11'

    input:
    path(ref)

    output:
    path('*') , emit: fa_index

    script:
    def args   = task.ext.args ?: ''
    """
    bwa index \\
    $args \\
    $ref
        
    """
}
