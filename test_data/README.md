# Test data

## Fasta reference (`test_chr21.fa`)

Extracted 10,000 non-N lines on chr21 from hg38_chromosomesOnly.fa 

```
samtools faidx /g/data/iz89/reference/hg38/hg38_chromosomesOnly.fa chr21 > test_data/chr21.fa
echo "> chr21" > test_chr21.fa
grep -v '^>' test_data/chr21.fa | grep -v 'N' | head 10000 > test_chr21.fa
mv test_chr21.fa test_data/
rm test_data/chr21.fa
```

## Fasta indexes (`/fa_idx`)

Retrieved from the workdir for `bwa_index`. Roughly:

```bash
bwa index test_data/test_chr21.fa 
mv test_chr21.fa.* test_data
```

## Samplesheets (`/samplesheets`)

* Use `testsamples.csv` for 1 pair/sampleID
* Use `multipair_samples.csv` for >1 pair/sampleID 

## PE fastqs (`/fqs`)

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