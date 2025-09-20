#!/bin/bash

#================================================================
#This script runs multiple migration run based on a
#SPecific migration script, each run with a specific iteration index.
#=================================================================

n=20
strength=0
name="migration"
mini=$1
maxi=$2
for i in `seq 1 $n`;
do
    ./run_migration.sh $i $strength $name $mini $maxi
done
