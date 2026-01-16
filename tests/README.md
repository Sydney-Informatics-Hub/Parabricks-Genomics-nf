# Running tests

Temporary instructions for manual testing to ensure any workflow changes work fine.

This will shortly be superseded by nf-test.

To run test script fill in the following and execute with: 

```bash
bash test/run_script.sh 
```
* path to ref `test_data/test_chr21.fa`
* path to input file `test_data/samplesheets/multipair_samples.csv`
* path to vep_cachedir `test_data/VEPcache`

Will throw an error if downloading cache that already exists. 

## Running nf-test

Connect to an interactive or persistent session on Gadi e.g.:

- `qsub -I -P er01 -lwalltime=01:00:00,mem=8GB` or
- `persistent-sessions start pb_nftest` then `ssh` into the printed IP.

Once in the session, run all available tests:

```bash
# cd Parabricks-Genomics-nf
module load nextflow/25.04.6
nf-test test
```
