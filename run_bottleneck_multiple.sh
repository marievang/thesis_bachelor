#!/bin/bash

# =========================================================
# This bash script automates running a bottleneck simulation
# multiple times, each with a specific iteration index.
# =========================================================

n=20
strength=1000
name="bottleneck"
for i in `seq 1 $n`;
do
    ./run_bottleneck.sh $i $strength $name
done

# =========================================================
# Outputs:
# - Executes 20 bottleneck simulations
# - Each run is indexed (1 to 20)
# - Outputs are likely named according to the replicate index and base name
# =========================================================
