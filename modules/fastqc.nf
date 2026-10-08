process fastqc {
    tag "SAMPLE: ${sample}"
    publishDir "${params.outdir}/fastqc/${sample}", mode: 'symlink'
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'

    input:
    tuple val(sample), path(fqs)

    output:
    path ("*fastqc.{zip,html}"), emit: fastqc_results

    script:
    // path(fqs) is [fq_a_1, fq_a_2, fq_b_1, fq_b_2, ...]; rename to the samplesheet
    // names for deidentification
    def renamed = fqs.withIndex().collect { fq, i -> [fq, "${sample}_${i.intdiv(2) + 1}_R${i % 2 + 1}.fastq.gz"] }
    def links = renamed.collect { fq, name -> "ln -s ${fq} ${name}" }.join('\n    ')
    """
    ${links}
    fastqc ${renamed.collect { it[1] }.join(' ')} -o .
    """
}
