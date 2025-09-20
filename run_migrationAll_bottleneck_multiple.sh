#!/bin/bash

# =========================================================
# This bash script automates running a specific migration + bottleneck
# simulation multiple times (n replicates), each with a specific
# iteration index. Each run is handled by a dedicated script.
# ========================================================

n=20
strength=100
name="migrationAll_bottleneckR1a"
for i in `seq 1 $n`;
do
    ./run_migrationAll_bottleneckR1a.sh $i $strength $name
done
