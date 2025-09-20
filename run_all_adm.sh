#!/bin/bash

# =========================================================
# This bash script automates running the 'adm.sh' script
# over a range of time points (or simulation runs) with a
# specified step size. It can optionally set a random seed
# for reproducibility. Each run is logged in an "outfile".
# =========================================================

# =========================================================
# Input parameters:
# $1 = tmin   : Minimum value of the time parameter (start of loop)
# $2 = tmax   : Maximum value of the time parameter (end of loop)
# $3 = step   : Step size for iterating from tmin to tmax
# $4 = j      : number of ancestral populations 
# $5 = path   : Base path where 'adm.sh' directories are located
# $6 = seed   : Optional random seed for reproducibility
# =========================================================
tmin=$1
tmax=$2
step=$3
j=$4
path=$5
seed=$6

if [ ! -z $seed ]
then
    RANDOM=$seed
fi
echo "" > outfile
for i in `seq $tmin $step $tmax`; do
    filename="${path}/run${i}_${j}/"
    echo "RANDOM NUMBER IS: $RANDOM"
    cmd="./adm.sh $filename $i $j $RANDOM"
    echo $cmd >> outfile 2>&1
    eval $cmd
done 
