#!/bin/bash

# =========================================================
# This bash script automates a single replicate of a simulation
# with continuous gene flow, runs the qpadm pipeline for that
# replicate, and then runs ADMIXTURE analysis.
# =========================================================

# =========================================================
# Input parameters
# $1 = repl      : Run index
# $2 = strength  : Strength of continuous gene flow
# $3 = name      : Base name for simulation outputs
# $4 = n1        : Minimum number of ancestral populations (K) for ADMIXTURE
# $5 = n2        : Maximum number of ancestral populations (K) for ADMIXTURE
# =========================================================

repl=$1
admtime=100
anc=3
name=$3
seed=$RANDOM
curdir=`pwd`
strength=$2
n1=$4
n2=$5

## run qpadm
./qpadm.sh ${name}_repl_${repl}_${strength} $admtime $anc $seed ./msprime_continuousgeneflow.py $strength 100000000
dirname=eig${name}_repl_${repl}_${strength}_${admtime}_$anc
echo $dirname

cd $curdir

echo $seed > $dirname/simulation_seed.txt
# run admixture
./run_admixture_all.sh $dirname $n1 $n2
