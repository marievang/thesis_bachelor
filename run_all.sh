#!/bin/bash

# =========================================================
# This bash script prepares directories and input files
# for ADMIXTURE analyses for a set range of K values (3-5).
# For each K, it creates a directory, sets up necessary
# files, and generates "keep" commands for ADMIXTURE.
#========================================================
curdir=`pwd`

for i in `seq 3 5`; do
    mkdir pavpops$i
    cd pavpops$i
    cp ../make_keep_cmds.pl ./
    ln -s ../testb/testmig.ind .
    ln -s ../testb/testmig.vcf .
    ./make_keep_cmds.pl -ind testmig.ind -interest ADMIX -fix pop1 -n $i
    cd $curdir
done

