process multiqc {
    tag "GENERATING REPORT: ${params.cohort_name}"
    publishDir "${params.outdir}/multiqc", mode: 'symlink'
    container 'quay.io/biocontainers/multiqc:1.21--pyhdfd78af_0'

    input:
    path multiqc_in
    path params.multiqc_config

    output:
    path "*.html"
    path "*_data"
    path "*_plots"

    script:
    def args = task.ext.args ?: ''
    """
    multiqc . \
        --filename ${params.cohort_name}_multiqc \
        -c ${params.multiqc_config} \
        ${args}
    """
}
