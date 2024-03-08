# 08.12.23 

- Check updates doesn't work, temp workaround in place 
- Reference indexing with bwa works, but need to add when condition to run/not run depending on existing index
- Parabricks fq2bam throwing error `cudaSafeCall() failed at ParaBricks/src/samGenerator.cu/819: an illegal memory access was encountered`

# 12.02.24

- Replaced fasta with ref 
- Tested Parabricks fq2bam with ./bin/test-parabricks.sh, issue persists
- Added functionality to input checker, now runs samplesheetchecker.py
- Added if/else loop in main.nf to detect existing bwa indexes for reference.fa
- Added tags for check_input and bwa_index processes

# 28.02.24

- Resolved Parabricks memory error, was misleading. Actually formatting of fasta. Keep that in mind.
- Got parabricks with 1 fq pair working 
- Finalised parabricks fq2bam process, runs for as many fq pairs per sample

# 04.03.24
- Working deepvariant command
- Adding extract pass with bcftools as per [previous execution](https://github.sydney.edu.au/informatics/PIPE-4135-CMT_neurogenomics/blob/master/300_preprocessing/T2T-scripts/pb_deepvariant.sh)

# 06.03.24
- Functioning glnexus joint genotyping on all variants, not just PASS - should this work on PASS sites only? Shouldn't matter. 
- Not extracting PASS variants as per [Deepvariant](https://github.com/google/deepvariant/issues/278) filtering

# 08.03.24
- Variant calling, joint genotyping complete 
- BCF to VCF conversion complete 
- TODO VEP annotations process. Downloading the cache via a container and nf process is proving tricky
- TODO VEP annotation process needs a pre-downloaded cache, ew  