#!/bin/bash

# =========================================================
# This bash script prepares directories and input files
# for running ADMIXTURE analyses with different numbers
# of ancestral populations (K values).
# For each K, it creates a directory, sets up necessary
# files, and generates "keep" commands for ADMIXTURE.
# =========================================================

# =========================================================
# Input parameters:
# $1 = input      : Input file (prefix of VCF/ind files)
# $2 = n1         : Minimum number of ancestral populations 
# $3 = n2         : Maximum number of ancestral populations 
# =========================================================
curdir=`pwd`

input=$1

cd $input

inputdir=`pwd`

echo $inputdir

n1=$2
n2=$3


for i in `seq $n1 $n2`; do
    mkdir pops$i
    cd pops$i
    cp $curdir/make_keep_cmds_admixture.pl ./
    ln -s $inputdir/$input.ind .
    ln -s $inputdir/*.vcf ./$input.vcf
    ./make_keep_cmds_admixture.pl -inp $input -interest ADMIX -fix pop1 -n $i
    cd $inputdir
done



