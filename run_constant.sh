#!/bin/bash

# =========================================================
# This bash script runs a full simulation and ADMIXTURE analysis
# for a single replicate under a constant population scenario
# (no bottleneck, strength=0). It first runs the qpadm pipeline,
# then prepares files for ADMIXTURE, and finally runs the
# admixture analysis for that replicate.
# =========================================================

# =========================================================
# Input parameters
# $1 = repl      : Run index
# =========================================================

strength=0       #Bottleneck strength
admtime=100      # Time of the admixture event
anc=3            # Number of ancestral populations
name=constant    # Name of the run 
seed=$RANDOM
repl=$1

curdir=`pwd`

## run qpadm
./qpadm.sh ${name}_repl_${repl}_${strength} $admtime $anc $seed ./msprimebottl_setStrenght.py $strength 100000000
dirname=eig${name}_repl_${repl}_${strength}_${admtime}_$anc
cd $curdir
echo $seed > $dirname/simulation_seed.txt
# run admixture
./run_admixture_all.sh $dirname

