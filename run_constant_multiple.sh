#!/bin/bash

#===========================================================
#This script make a number of runs based on the input values for a constant population
#============================================================

#==================================================
#Input parameters:
#number of runs
# number of populations
#===================================================


n=20
for i in `seq 1 $n`;
do
    ./run_constant.sh $i
done
