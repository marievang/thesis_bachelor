#dir=$1
#find $dir -iname All_pops.txt | xargs grep TRUE  | grep -o "All_pops.txt:.*" | awk '{print $1}' | sort  | uniq -c  | sort -k1 -g | sed 's/All_pops.txt://'

#!/bin/bash

# =========================================================
# Counts how many times "TRUE" appears in files named
# "All_pops.txt" under a given directory, and outputs
# a sorted summary of the files containing it.
# =========================================================

# Input:
# $1 = dir : The directory to search recursively

dir=$1

find $dir -iname All_pops.txt \    # Find all files named "All_pops.txt"  under $dir
| xargs grep TRUE \                # Search for lines containing "TRUE" in all found files
| grep -o "All_pops.txt:.*" \      # Extract only the filename + matching line
| awk '{print $1}' \               # Get the filename
| sort \                           # Sort filenames
| uniq -c \                        # Count occurrences of each filename
| sort -k1 -g \                    # Sort by count numerically
| sed 's/All_pops.txt://'          # Remove the literal "All_pops.txt:" from output

# Output:
# - A sorted list of files (without the full path "All_pops.txt") 
#   and the number of times "TRUE" occurs in each
# =========================================================
