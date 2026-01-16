process extract_flowcell_lane {
    tag "INPUT: ${sample}"

    input:
    tuple val(sample), path(fq1), path(fq2), val(platform), val(library), val(center)

    output:
    tuple val(sample), path(fq1), path(fq2), val(platform), val(library), val(center), path("flowcell.txt"), path("lane.txt")

    script:
    """
    #!/usr/bin/bash

    fq_header=\$(gzip -dc "${fq1}" | sed -n '1p')
    echo "\$fq_header" | cut -d':' -f3 > flowcell.txt
    echo "\$fq_header" | cut -d':' -f4 > lane.txt
    """
}
