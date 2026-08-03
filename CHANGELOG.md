# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Optional `--bwa_index` parameter to point at a prebuilt BWA index directory and skip the `bwa_index` step (`nextflow.config`, `main.nf`, `nextflow_schema.json`, README). Useful when the reference lives in a read-only directory that cannot hold a colocated index.
- Optional `--vep_cache` parameter to point at a prebuilt VEP cache directory (containing `<species>/<version>_<assembly>`) and skip the `download_vep` step (`nextflow.config`, `main.nf`, `nextflow_schema.json`, README). When set, annotation runs against the local cache; otherwise the `--download_vep_cache` download path is used. Avoids re-downloading the ~21 GB cache each run.
- Optional `--exome` parameter for whole-exome (WES) cohorts (`nextflow.config`, `modules/glnexus_joint.nf`, `modules/pb_deepvar.nf`, `main.nf`, `nextflow_schema.json`, README). When set: GLnexus joint-genotyping uses the `DeepVariantWES` preset instead of `DeepVariantWGS`, and `pbrun deepvariant` runs with `--use-wes-model --disable-small-model` to match Google DeepVariant's WES behaviour (see [NVIDIA's source-of-mismatches notes](https://docs.nvidia.com/clara/parabricks/tool-reference/tools/deepvariant#source-of-mismatches)).

### Fixed
- `extract_flowcell_lane` no longer decompresses the entire FASTQ to read the header. `sed -n '1p'` read stdin to EOF, forcing `gzip -dc` through the whole ~30 GB file (~46–50 min per sample); changed to `sed -n '1{p;q}'` so decompression stops after the first line (sub-second).

## [3.0.0] - 2026-06-05

### Added
- `--parabricks_version` parameter to select the Parabricks release and target GPU queue: `4.6.0` (dgxa100 / A100, default) or `4.3.2` (gpuvolta / V100). Invalid values are rejected at startup (`main.nf`, `nextflow_schema.json`).
- Selected version is printed in the run header and help text, and echoed as a runtime check inside `pb_fq2bam`, `pb_deepvariant`, and `pb_collectmetrics`.
- MultiQC report now records the Parabricks version used at runtime (`modules/multiqc.nf`).

### Changed
- GPU queue, CPU, and memory allocations are now derived from `--parabricks_version` instead of being hardcoded: gpuvolta uses `task.gpus * 12` CPUs and 95 GB (collectmetrics), dgxa100 uses `task.gpus * 16` CPUs and 190 GB (`config/modules.config`).
- Parabricks module load is selected by version (`parabricks/4.3.2` vs `parabricks/4.6.0`) in `config/gadi.config`.
- README updated with a per-version queue/GPU/resource table and usage examples.

## [2.0.2] - 2026-05-20

### Added
- nf-gadi plugin integration for HPC usage reporting (`config/gadi.config`, `tests/run_gadi_simple_plugin.sh`)
- GitHub Action for automated WorkflowHub submission on release (`.github/workflows/workflowhub.yml`)
- RO-Crate metadata (`ro-crate-metadata.json`)
- Timestamped output filenames for nf-gadi plugin reports

## [2.0.1] - 2026-02-27

### Fixed
- Documentation typos

### Changed
- Updated metadata and version references in README

## [2.0.0] - 2026-02-24

### Added
- Parabricks 4.6.0 support targeting the dgxa100 GPU queue
- `nextflow_schema.json` for Seqera Platform parameter validation
- nf-test infrastructure (`nf-test.config`, `tests/params/` JSON parameter files)
- `extract_flowcell_lane` process for parsing flowcell and lane information from FASTQ headers

### Changed
- `--storage_account` now accepts mount path strings (e.g. `scratch/er01+gdata/er01`) instead of project codes — **breaking change**
- Gadi-specific parameters (`gadi_account`, `whoami`, `singularityCacheDir`, `timestamp`) moved into `config/gadi.config`
- Parabricks processes now use a `parabricks` label for targeted resource configuration

### Fixed
- Pipeline failing with multiple paired reads per sample
- FastQC receiving incorrect reads when multiple samples present
- Reference FASTA not passed correctly as a channel to downstream processes
- BWA index running out of memory (increased to 8 GB)
- Bad Parabricks config causing process failure

## [1.1.0] - 2024-05-20

### Changed
- Updated GLnexus container to resolve jemalloc compatibility issue
- Reformatted `gadi.config`

## [1.0.0] - 2024-05-13

- Initial release

[Unreleased]: https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf/compare/v2.0.1...HEAD
[2.0.1]: https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Sydney-Informatics-Hub/Parabricks-Genomics-nf/releases/tag/v1.0.0
