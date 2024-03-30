process fastqc {
    tag "SAMPLE: ${sample}" 
    publishDir "${params.outdir}/fastqc/${sample}", mode: 'symlink'
    container	= 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'

    input: 
    tuple val(sample), val(fq_in_list)

    output:
    path("*fastqc.{zip,html}"), emit: fastqc_results

    script:
    def fq_in_list = fq_in_list.join(' ')
    """
    fastqc ${fq_in_list} -o .
    """
}