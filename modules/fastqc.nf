process fastqc {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/fastqc/${sample}", mode: 'symlink'
    container	= 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'

    input: 
    tuple val(sample), path(fq1), path(fq2)

    output:
    path("*fastqc.{zip,html}"), emit: fastqc_results

    script:
    """
    fastqc $fq1 $fq2 -o .
    """
}