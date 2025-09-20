#!/bin/bash

# =========================================================
# Script purpose:
# This bash script runs a population genetics simulation
# and processes the results for admixture analysis.
# It executes a Python simulation program, converts the
# output to PLINK/EIGENSTRAT formats, and then runs
# R scripts for admixture plotting.
# =========================================================

# =========================================================
# Input parameters (positional):
# $1 = FILE       : Base name for input/output files
# $2 = time       : Simulation time parameter
# $3 = anc        : Number of ancestral populations
# $4 = seed       : Random seed (optional)
# $5 = executable : Python simulation program to run
# $6 = strength   : Selection or migration strength parameter
# $7 = length     : Length of the simulation genome (optional)
# =========================================================

FILE=$1
time=$2
anc=$3
seed=$4
executable=$5
strength=$6
length=$7

#Create output directories and make the file names

outputname="${FILE}_${2}_$3"
outputname2="eig${outputname}"

path=`pwd`

mkdir $outputname2
cd $outputname2
echo $FILE
echo $outputname2
echo $seed

#set simulation length to use as a default if the user does not provide any

if [ -z "$length" ]
then
    length=100000000
fi

if [ -z "$seed" ]
then
    echo $FILE
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo $anc
    echo $time
    python3.10 $path/$executable --ancestral $anc --time $time --output $outputname --strength $strength --length $length
else
    python3.10 $path/$executable --ancestral $anc --time $time --output $outputname --seed $seed --strength $strength --length $length
    echo $length
fi

#====================Set the admixture analysis========================

## this is k for admixture
n1=3
n2=3

echo $FILE
# Generate the input file in plink format
python3 ~/software/gdc/vcf2eigenstrat.py -v $outputname.vcf -o $outputname2 -i $outputname.ind

#cp $outputname2
cd $path
rcmd="Rscript $path/qpadm.R $outputname2"
echo $rcmd
echo `pwd`
eval $rcmd

# ##plink2 --vcf $outputname.vcf --make-bed --out $outputname --allow-extra-chr --max-alleles 2


# # ADMIXTURE does not accept chromosome names that are not human chromosomes. We will thus just exchange the first column by 0
# awk '{$1="0";print $0}' $outputname.bim > $outputname.bim.tmp
# mv $outputname.bim.tmp $outputname.bim

# ## parallel run of the admixture loop
# Rscript $path/adm_par.R $outputname $n1 $n2

# for i in `seq $n1 $n2`;do
#     grep CV log$i.out
# done >  $outputname.cv.error

# more $outputname.cv.error | awk -F: '{print $1"\t"$2}' | sed 's/(K=//' | sed 's/)//' | sort -k1g > $outputname.sorted.admTime$time.cv

# Rscript $path/plot.R $outputname $n1 $n2

# mv adm_plots.pdf adm_plots_admTime$time.pdf

# cd $path

