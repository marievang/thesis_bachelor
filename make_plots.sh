#!/bin/bash
# =====================================================
# Plot Generator for Admixture Runs
#
# Arguments:
#   folder   Directory containing multiple run*_* subfolders
#
# Requirements:
#   - R installed
#   - plot.R script available in the working directory
#
# Output:
#   - adm_plots.pdf files generated in each run*_* subfolder

folder=$1
current=`pwd`
cd $folder
find -iname run*_* | grep -E -o '^\.[^\.]*$' > tmp.list
cur2=`pwd`

for d in `cat tmp.list`;
do
    echo $d
    fname=$(echo $d | grep -E -o "run[^\/]*$")
    echo $fname
    cd $d
    Rscript $current/plot.R $fname 2 7
    cd $cur2
done
cd $current
