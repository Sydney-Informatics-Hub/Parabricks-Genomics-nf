# Dev Assets

This folder contains scripts and assets for benchmarking and optimisation. These are not required for production runs or ongoing testing.

## Contents

- `dl_giab_small.sh`: Downloads NA12878 20~30x FASTQs from the GIAB `Sample_U1a` directory from NIST. Single flow cell (project) and library (Sample_U1a).
- `SampleSheet.csv`: Samplesheet for the `Sample_U1a` run.
- `/g/data/er01/parabricks_4.6.0/U1a_*fastq.gz`: FASTQs downloaded from the GIAB Sample_U1a dataset.

## Usage

From a Gadi `copyq` interactive session:

```bash
qsub -I -P er01 -q copyq -l walltime=01:00:00 -l ncpus=1 -l mem=8GB -l storage=scratch/er01
```

Then run:

```bash
bash dl_giab_small.sh
```