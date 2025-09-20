#!/bin/bash
# =====================================================
# Extract and sort ADMIXTURE cross-validation (CV) errors
#
# Usage:
#   ./parse_cv.sh <dirname>
#
# Arguments:
#   dirname   Directory containing log_*.out files
#
# Output:
#   - cv.list              : All CV error lines collected from logs
#   - cv_errors_sorted.txt : Log file + CV error sorted (ascending)
#   - stdout               : Log file + CV error sorted (descending)
#


dirname=$1

cd $dirname

find -iname 'log_*.out' > log.list; cat log.list | xargs -I {} grep CV  {} > cv.list #find the log files and extract cv errors 

paste log.list cv.list | awk '{print $1"\t"$5}' | sort -k2 -g > cv_errors_sorted.txt #Merge log file names with CV error values
# Extract the 5th field (the numeric CV error)
# Sort ascending (best K at the top)

paste  log.list cv.list | awk '{print $1"\t"$5}' | sort -k2 -gr
