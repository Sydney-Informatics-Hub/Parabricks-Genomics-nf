# Test data for Parabricks 

## Run test to ensure any workflow changes work fine 

TODO make this a github action?

To run test script fill in the following and execute with: 

```bash
bash test/run_script.sh 
```
* full path to ref `test/test_chr21.fa`
* full path to input file `test/multipair_samples.csv`
* full path to vep_cachedir `test/VEPcache`

Will throw an error if downloading cache that already exists. 

## Fasta reference 

Extracted 10,000 non-N lines on chr21 from hg38_chromosomesOnly.fa 

```
samtools faidx /g/data/iz89/reference/hg38/hg38_chromosomesOnly.fa chr21 > test/chr21.fa
echo "> chr21" > test_chr21.fa
grep -v '^>' test/chr21.fa | grep -v 'N' | head 10000 > test_chr21.fa
mv test_chr21.fa test/
rm test/chr21.fa
```

## Samplesheets 

* Use `testsamples.csv` for 1 pair/sampleID
* Use `multipair_samples.csv` for >1 pair/sampleID 

## PE fastqs

Taken from nf-core/raredisease test data and subset to 1,000 reads 
Found @ https://github.com/nf-core/test-datasets/blob/raredisease/testdata/samplesheet_trio.csv
```
fqs=(
    "1_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_1.fastq.gz"
    "1_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_2.fastq.gz"
    "1_171015_HHT5NDSXX_hugelymodelbat_XXXXXX_1.fastq.gz"
    "1_171015_HHT5NDSXX_hugelymodelbat_XXXXXX_2.fastq.gz"
    "1_171015_HHT5NDSXX_slowlycivilbuck_XXXXXX_1.fastq.gz"
    "1_171015_HHT5NDSXX_slowlycivilbuck_XXXXXX_2.fastq.gz"
)

for fq in "${fqs[@]}"; do
    zcat "$fq" | head -n 4000 | gzip > "${fq/.fastq.gz/_1k.fastq.gz}"
done
```

Duplicated `earlycausualcaiman` fq pairs to test multiple pairs per sample and saved to `multipair_samples.csv`: 

```
cp 1_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_1_1k.fastq.gz 2_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_1_1k.fastq.gz
cp 1_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_2_1k.fastq.gz 2_171015_HHT5NDSXX_earlycasualcaiman_XXXXXX_2_1k.fastq.gz
```