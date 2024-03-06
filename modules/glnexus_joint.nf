process glnexus_joint_call {
    tag "JOINT GENOTYPING: ${params.cohort_name}" 
    publishDir "${params.outdir}/variants", mode: 'symlink'
    container "quay.io/biocontainers/glnexus:1.4.1--h5c1b0a6_3"

    input:
    path(gvcf_list) 

    output:
    path("*.bcf"), emit: cohort_bcf
    path("glnexus_list"), emit: glnexus_list

    script:
    def args = task.ext.args ?: ''
    """
    # Using pre-built deepvariant config
    # See: https://github.com/dnanexus-rnd/GLnexus/wiki/Getting-Started 
    
    # Prepare list of gvcfs for glnexus
    echo ${gvcf_list} | tr ' ' '\n' > glnexus_list
    
    glnexus_cli \
      --config DeepVariantWGS \
      --threads ${task.cpus} \
      --list glnexus_list \
      > ${params.cohort_name}.bcf \
      $args
    """
}