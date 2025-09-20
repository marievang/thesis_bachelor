#!/usr/bin/python

"""
Script to simulate ancestry and mutations with msprime
Input:
   - "-a" "--ancestral" : number of ancestral populations
   - "-t" "--time" : time of admixture
   - "-o" "--output :name of the output file
   - "-s" "--seed" : random seed for the run
"""

import msprime
from IPython.display import SVG, display
import argparse
import random 
from datetime import datetime
random.seed(datetime.now().timestamp())
# Initialize parser
parser = argparse.ArgumentParser()
# Adding optional argument
parser.add_argument("-a", "--ancestral", help = "Number of ancestral populations")
parser.add_argument("-t", "--time", help = "time point of admixture")
parser.add_argument("-o", "--output", help = "ouputfile")
parser.add_argument("-s", "--seed", help="random seed", type=int, default=-1)
# Read arguments from command line
args = parser.parse_args()

if args.seed != -1:
    random.seed(args.seed)

simseeds = random.sample(range(100000000), k = 2)
print(simseeds)

if args.ancestral:
    print("The number of ancestral populations is: % s" % args.ancestral)

anc = int(args.ancestral)
timeadm = int(args.time)

demography = msprime.Demography()
for i in range(anc):
    demography.add_population(name="pop"+str(i+1), initial_size=100)
    
demography.add_population(name="ADMIX", initial_size=10000)
demography.add_population(name="ANC", initial_size=1000)


## for how long the present day population was a 'panmictic' like population
demography.add_admixture(
    time=timeadm, derived="ADMIX", ancestral=["pop"+str(i+1) for i in range(anc)], proportions=[1/anc for i in range(anc)])

demography.add_population_split(time=2000, derived=["pop"+str(i+1) for i in range(anc)], ancestral="ANC")
#demography.add_symmetric_migration_rate_change(time=1000, populations=["pop1","pop2"], rate=0.1)
#demography.add_symmetric_migration_rate_change(time=1200, populations=["pop1","pop3"], rate=0.4)



demography.debug()

totalsamplesize = 0
samplesperancpop =2 
for i in range(anc):
    totalsamplesize += samplesperancpop

popdict = {"ADMIX":anc*5, "ANC":0}
for i in range(anc):
    key = "pop"+str(i+1)
    popdict[key] = samplesperancpop
demography.add_symmetric_migration_rate_change(time=1000, populations=["pop1","pop2"], rate=0.1)
demography.add_symmetric_migration_rate_change(time=1200, populations=["pop1","pop3"], rate=0.4)
    
ts = msprime.sim_ancestry(popdict,
                          recombination_rate=1e-8,###########
                          sequence_length=100_000_000,
                          ##population_size=1000,
                          random_seed=simseeds[0],
                          demography=demography,
                          ploidy=2)

print("Simulation ancestry OK")

# with open('test_image.svg', 'wb') as svg_file:
#     svg_file.write(ts.draw_svg().encode())

print("File svg output OK")


mts = msprime.sim_mutations(ts, rate=1e-8, random_seed=simseeds[1])

print(len(mts.sites()))

print("mutations OK")

with open(args.output+".vcf", "w") as vcf_file:
    mts.write_vcf(vcf_file)
