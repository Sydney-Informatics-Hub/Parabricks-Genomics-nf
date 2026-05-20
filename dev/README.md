# Dev Assets

This directory contains resources for development, benchmarking, and infrastructure configuration. These are not required for production runs.

## Development workflow

### Opening a PR

Work on feature branches and open PRs to `dev`:

```bash
git checkout -b my-feature
# ... make changes ...
git push origin my-feature
# Open PR → dev on GitHub, request review, merge
```

### Release to production

Clean versioning matters here - WorkflowHub submission is automated via `.github/workflows/workflowhub.yml` and triggers on GitHub Release publish. An unclean release (wrong tag, missing release notes) will produce a bad WorkflowHub entry.

```bash
# 1. PR dev → main (GitHub UI), then pull locally
git checkout main
git pull origin main

# 2. Tag and push
git tag v2.0.2
git push origin v2.0.2

# 3. Publish GitHub Release
# GitHub UI → Releases → Draft a new release
# Select tag v2.0.2, add release notes, click Publish
# → WorkflowHub submission triggers automatically
```

## `gadi.config`

[`config/gadi.config`](../config/gadi.config) is the single source of truth for all NCI Gadi-specific settings. It is included via the `gadi` profile in `nextflow.config`.

For per-process resource changes (CPUs, memory, walltime, queue), edit [`config/modules.config`](../config/modules.config) instead. Changes to executor behaviour or storage paths belong in `gadi.config`.

> **Note:** `gadi.config` will be replaced with a more modular configuration structure in a future release.

## Reporting with the `nf-gadi` plugin

The [`nf-gadi` plugin](https://github.com/AustralianBioCommons/nf-gadi) generates an HPC-specific usage report per process — Queue, Service Units (SUs), and Efficiency — beyond what Nextflow's built-in trace provides.

### Why it's opt-in

The plugin is not declared in `nextflow.config` and must be passed at runtime with `-plugins nf-gadi@1.2.0`. It requires access to PBS job logs and is not needed for every run — use it when benchmarking resource allocations or validating SU estimates.

### Configuration

The plugin block in `config/gadi.config` writes a timestamped CSV to the working directory:

```groovy
gadi {
    format = 'csv'
    output = "plugin_${params.timestamp}.csv"
}
```

### How to run

```bash
nextflow run main.nf \
    -params-file tests/params/gadi_simple.json \
    -profile gadi \
    -resume \
    -plugins nf-gadi@1.2.0
```

Or use the convenience script:

```bash
bash tests/run_gadi_simple_plugin.sh
```

### Output

The plugin produces a CSV with one row per process task:

```
Name,Process,Queue,Service Units,CPUs,CPU time,Used Walltime,Requested Walltime,Used Memory,Requested Memory,Used JobFS,Requested JobFS,Efficiency,Exit Code
extract_flowcell_lane (INPUT: earlycasualcaiman),extract_flowcell_lane,null,null,null,null,null,null,null,null,null,null,null,null
bwa_index (FASTA: test_chr21.fa),bwa_index,normal,0.00,2,00:00:00,00:00:02,10:00:00,57.93MB,8.0GB,0B,100.0MB,0.00,0
fastqc (SAMPLE: earlycasualcaiman),fastqc,normal,0.01,1,00:00:05,00:00:09,10:00:00,466.98MB,4.0GB,0B,100.0MB,0.56,0
pb_fq2bam (SAMPLE: earlycasualcaiman),pb_fq2bam,dgxa100,5.60,64,00:05:26,00:01:10,04:00:00,129.5GB,380.0GB,0B,100.0MB,0.07,0
pb_collectmetrics (SAMPLE: earlycasualcaiman),pb_collectmetrics,dgxa100,0.24,16,00:00:04,00:00:12,01:00:00,106.18MB,190.0GB,0B,100.0MB,0.02,0
pb_deepvariant (SAMPLE: earlycasualcaiman),pb_deepvariant,dgxa100,1.04,64,00:01:28,00:00:13,04:00:00,6.36GB,380.0GB,0B,100.0MB,0.11,0
glnexus_joint_call (JOINT GENOTYPING: cohort),glnexus_joint_call,normal,0.08,48,00:00:01,00:00:03,10:00:00,256.6MB,190.0GB,0B,100.0MB,0.01,0
bcftools_convert (COHORT: cohort),bcftools_convert,normal,0.00,1,00:00:00,00:00:02,10:00:00,94.15MB,4.0GB,0B,100.0MB,0.00,0
```

**Column notes:**
- **Service Units**: SU cost for the job (CPU-hours × queue charge rate). Gadi SU rates vary by queue.
- **Efficiency**: used CPU time ÷ (requested walltime × CPUs). Low values on GPU processes (`pb_fq2bam`, `pb_deepvariant`) are expected: Parabricks is GPU-bound, not CPU-bound.
- **null** values for `extract_flowcell_lane` are expected — it runs locally, outside PBS.

## Benchmarking

### Download data

RM83898_U1a: tiny NA12878 subset, ~9 GB FASTQ reads.

platinum3: n=3 platinum genomes at ~30x.

`dl_giab_small.sh` and `dl_platinum.sh` contain commands to download paired-end FASTQ reads. These are stored in `/g/data/er01/parabricks_4.6.0`.

Reference genome: `/g/data/if89/data_library/Homo_Ref/GRCh38.p14/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna`

### Running the tests

CSV samplesheets are in each dataset subfolder. Update the path in the script and run:

```bash
# cd into repo root
bash tests/run_gadi_benchmark.sh
```

### Getting the log outputs

Use SIH's [`HPC_usage_reports`](https://github.com/Sydney-Informatics-Hub/HPC_usage_reports/tree/match_nf_logs) to pull PBS logs for each process:

```bash
# Get work dirs and task names
nextflow log thirsty_shockley -f 'name,status,native_id,workdir' > nf_log.txt

# Get usage stats from PBS logs
HPC_usage_reports/Scripts/gadi_nfcore_report.sh

# Combine
HPC_usage_reports/Scripts/match_nf_logs.py -n nf_log.tsv -l gadi_nf-core-joblogs.tsv
```

### Save and store

```bash
#!/bin/bash

#PBS -P er01
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l jobfs=200GB
#PBS -l walltime=02:00:00
#PBS -l storage=scratch/er01+gdata/er01
#PBS -l wd

cd /scratch/er01/fj9712
tar -czf 260219_platinum3.tar.gz platinum
cp -v 260219_platinum3.tar.gz /g/data/er01/parabricks_4.6.0/
# OR
#tar -czf 260219_U1a.tar.gz Parabricks-Genomics-nf
#cp -v 260219_U1a.tar.gz /g/data/er01/parabricks_4.6.0/
```
