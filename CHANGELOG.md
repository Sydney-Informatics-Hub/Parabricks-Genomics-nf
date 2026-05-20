# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
