#!/bin/bash
####
#====================================================================================
#Script for Simulating Data with msprime and Running Admixture analysis

# 
# Usage:
#   ./script.sh <FILE> <time> <ancestral> <seed>
#
# Arguments:
#   FILE       Name of the output folder to store results
#   time       Time parameter for msprime simulation
#   ancestral  Ancestral population parameter
#   seed       (Optional) Random seed for reproducibility
#
# Output:
#   - Simulated VCF files
#   - Plink-formatted files
#   - Admixture CV error estimates
#   - Admixture plots
# ==================================================================================

#=======================================
#Parse Input files
#======================================
FILE=$1                         #Name for output directory 
time=$2                         #Time parameter for the simulation
anc=$3                          #Number of ancestral populations
seed=$4
outputname="run${2}_$3"         #Name output for the specific run 

path=`pwd`
#=======================================
#Create the needed folders
#=======================================

mkdir $FILE
cd $FILE
echo $FILE
echo $seed

#========================================
#Run msprime
#========================================


if [ -z "$seed" ]
then
    echo $FILE
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo $anc
    echo $time
    python3.10 $path/msprime_run.py --ancestral $anc --time $time --output $outputname
else
    python3.10 $path/msprime_run.py --ancestral $anc --time $time --output $outputname --seed $seed
fi

## this is k for admixture
n1=2
n2=7

echo $FILE
# Generate the input file in plink format
plink2 --vcf $outputname.vcf --make-bed --out $outputname --allow-extra-chr --max-alleles 2


# ADMIXTURE does not accept chromosome names that are not human chromosomes. We will thus just exchange the first column by 0
awk '{$1="0";print $0}' $outputname.bim > $outputname.bim.tmp
mv $outputname.bim.tmp $outputname.bim

## parallel run of the admixture loop
Rscript $path/adm_par.R $outputname $n1 $n2

for i in `seq $n1 $n2`;do
    grep CV log$i.out
done >  $outputname.cv.error

more $outputname.cv.error | awk -F: '{print $1"\t"$2}' | sed 's/(K=//' | sed 's/)//' | sort -k1g > $outputname.sorted.admTime$time.cv

Rscript $path/plot.R $outputname $n1 $n2

mv adm_plots.pdf adm_plots_admTime$time.pdf

cd $path

