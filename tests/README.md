# Running tests

Temporary instructions for manual testing to ensure any workflow changes work fine.

This will shortly be superseded by nf-test.

To run test script fill in the following and execute with: 

```bash
bash test/run_script.sh 
```
* full path to ref `test/test_chr21.fa`
* full path to input file `test/multipair_samples.csv`
* full path to vep_cachedir `test/VEPcache`

Will throw an error if downloading cache that already exists. 