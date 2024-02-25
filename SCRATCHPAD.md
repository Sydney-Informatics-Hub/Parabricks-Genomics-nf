# 08.12.23 

- Check updates doesn't work, temp workaround in place 
- Reference indexing with bwa works, but need to add when condition to run/not run depending on existing index
- Parabricks fq2bam throwing error `cudaSafeCall() failed at ParaBricks/src/samGenerator.cu/819: an illegal memory access was encountered`

# 12.02.24

- Replaced fasta with ref 
- Tested Parabricks fq2bam with ./bin/test-parabricks.sh, issue persists
- Added functionality to input checker, now runs samplesheetchecker.py