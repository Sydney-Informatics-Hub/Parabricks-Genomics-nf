process download_vep {
    tag "DOWNLOADING_CACHE: ${params.vep_species} - ${params.vep_assembly}"
    publishDir "${params.outdir}/VEP_cache", mode: 'symlink'
    container 'quay.io/biocontainers/ensembl-vep:116.2--pl5321h2a3209d_0'

    input:
    val vep_assembly
    val vep_species

    output:
    // TODO fix this, have added optional to avoid error but that's risky 
    path ("vep_cache"), emit: cache, optional: true

    script:
    // TODO if performance is buggy, consider using Globus: https://github.com/Ensembl/ensembl-vep/issues/936 
    """
    INSTALL.pl \
      --AUTO cf \
      --SPECIES "${params.vep_species}" \
      --ASSEMBLY "${params.vep_assembly}" \
      --CACHEDIR vep_cache
    """
}
