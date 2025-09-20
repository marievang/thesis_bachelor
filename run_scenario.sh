#!/bin/bash

# =========================================================
# This bash script automates multiple replicates of a
# population genetics simulation scenario and runs
# the full ADMIXTURE pipeline for each replicate.
# =========================================================

# =========================================================
# Input parameters (positional):
# $1 = scenario   : Base name for the simulation scenario
# $2 = reps       : Number of simulations to run
# $3 = seed       : Optional random seed for reproducibility
# $4 = startgen   : Starting generation
# $5 = endgen     : Ending generation 
# $6 = step       : Step size for generations
# $7 = pops       : Number of populations 
# =========================================================

scenario=$1
reps=$2
seed=$3
startgen=$4
endgen=$5
step=$6
pops=$7

echo $@ > $scenario.LOG

if [ ! -z $seed ]
then
    RANDOM=$seed
fi

for i in $(seq $reps); do
    runpath=$scenario/run$i/
    echo $runpath
    mkdir -p $runpath
    ./run_all_adm.sh $startgen $endgen $step $pops $runpath $RANDOM
done
