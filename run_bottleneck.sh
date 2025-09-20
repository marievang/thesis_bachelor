#!/bin/bash

# =========================================================
# This bash script runs a full simulation and ADMIXTURE analysis
# for a single replicate of a bottleneck scenario with specified strength.
# It first runs the qpadm pipeline, then prepares files for ADMIXTURE,
# and finally runs the admixture analysis for that replicate.
# =========================================================

# =========================================================
# Input parameters:
# $1 = repl      : Replicate index
# $2 = strength  : Bottleneck strength parameter
# $3 = name      : Base name for simulation outputs
# =========================================================


strength=$2
admtime=100
anc=3
name=$3
seed=$RANDOM
repl=$1

curdir=`pwd`

## run qpadm
#This part executes the msprime simulation with the specified parameters for the bottleneck and produces
# a directory with the result of the whole analysis

./qpadm.sh ${name}_repl_${repl}_${strength} $admtime $anc $seed ./msprimebottl_setStrenght.py $strength 100000000
dirname=eig${name}_repl_${repl}_${strength}_${admtime}_$anc
cd $curdir
echo $seed > $dirname/simulation_seed.txt
# run admixture
./run_admixture_all.sh $dirname

