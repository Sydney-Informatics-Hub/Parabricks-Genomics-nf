process download_vep {
    tag "DOWNLOADING_CACHE: ${params.vep_species} ${params.vep_assembly}" 
    publishDir "${params.outdir}/VEP_cache", mode: 'symlink'
    container 'quay.io/lifebitaiorg/vep-nf:v110.1' 

    input: 
    val(vep_assembly)
    val(vep_species)
    path(vep_cachedir)

    output:
    // TODO tidy this. Bit buggy, have added optional to avoid error 
    path("${params.vep_species}/*"), emit: vep_cache, optional: true
    
    script:
    // TODO if performance is buggy, consider using Globus: https://github.com/Ensembl/ensembl-vep/issues/936 
    """
    INSTALL.pl --CACHEDIR /scratch/er01/gs5517/workflowDev/VEP/ INSTALL.pl \
      --AUTO cf \
      --SPECIES "${params.vep_species}" \
      --ASSEMBLY "${params.vep_assembly}" \
      --CACHEDIR ${params.vep_cachedir}
    """
}