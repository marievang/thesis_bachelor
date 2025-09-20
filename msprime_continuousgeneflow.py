#!/home/maria_evangelinou/venv/bin/python3.11

"""
Msprime script that simulates ancestry and mutations in the presence of a continuous gene flow (migration) event
Usage:
    python msprime_continuousgeneflow.py \
        -a <num_ancestral_pops> \
        -t <admixture_time> \
        -o <output_prefix> \
        [-s <random_seed>] \
        [-l <chromosome_length>] \
        [--Nadmixture <admixed_population_size>] \
        [--Nothers <other_population_size>] \
        [--strength <bottleneck_strength>]

Outputs:
    <output_prefix>.ind         - Individual/population assignment file
    <output_prefix>.vcf         - Simulated variants in VCF format
    proportions.txt             - Admixture proportions used
    command_line.txt            - Command-line arguments used
"""

import sys
import msprime
from IPython.display import SVG, display
import argparse
import random
from datetime import datetime
random.seed(datetime.now().timestamp())
import numpy as np
migration_rate = 0.05
# Initialize parser                                                                                                                                                                                               \
                                                                                                                                                                                                                   
parser = argparse.ArgumentParser()
# Adding optional argument                                                                                                                                                                                        \
                                                                                                                                                                                                                   
parser.add_argument("-a", "--ancestral", help = "Number of ancestral populations")
parser.add_argument("-t", "--time", help = "time point of admixture")
parser.add_argument("-o", "--output", help = "ouputfile")
parser.add_argument("-s", "--seed", help="random seed", type=int, default=-1)
parser.add_argument("-l", "--length", help="length of the chromosome", type=int, default=100000000)
parser.add_argument("-Nadm", "--Nadmixture", help="The size of the admixed population", type=int, default=10000)
parser.add_argument("-Noth", "--Nothers", help="The size of the other populations", type=int, default=1000)
parser.add_argument("-bs", "--strength", help="The strength of the bottleneck", type=float, default=0)

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

demography.add_population(name="ADMIX", initial_size=args.Nadmixture)#####2.0                                                                                                                       
#demography.add_population(name="ANC", initial_size=1000)
demography.add_population(name="R1", initial_size=args.Nothers)
demography.add_population(name="R1a", initial_size=args.Nothers)
demography.add_population(name="R3a", initial_size=args.Nothers)
demography.add_population(name="R2", initial_size=args.Nothers)
demography.add_population(name="R3", initial_size=args.Nothers)
demography.add_population(name="O", initial_size=args.Nothers)

## for how long the present day population was a 'panmictic' like population                                                                                                                                      
proportions=[random.randint(1,100) for i in range(anc)]
proportions = [proportions[i]/sum(proportions) for i in range(anc)]

geneflowtime=1
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop1", dest="pop2")
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop1", dest="pop3")
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop2", dest="pop1")
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop2", dest="pop3")
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop3", dest="pop1")
demography.add_migration_rate_change(time=geneflowtime, rate=0.01, source="pop3", dest="pop2")

#migration_matrix=np.array([[0,0.01,0.02],[0.03,0,0.04],[0.05,0.03,0]])
demography.add_admixture(time=timeadm, derived="ADMIX", ancestral=["pop"+str(i+1) for i in range(anc)], proportions=proportions)

#demography.add_migration_rate_change(time=150, populations=["pop1","pop2","pop3"],rate=0.01)
demography.add_population_split(time=200, derived=["pop1"], ancestral="R1")
demography.add_population_split(time=300, derived=["pop2"], ancestral="R2")
demography.add_population_split(time=400, derived=["pop3"], ancestral="R3")
demography.add_population_split(time=500, derived=["R1"], ancestral="R1a")

demography.add_population_split(time=750, derived=["R1a"], ancestral="R2")
demography.add_population_split(time=1200, derived=["R3a"], ancestral="R3")
demography.add_population_split(time=1500, derived=["R2"], ancestral="R3")
#demography.add_population_split(time=4000, derived=["pop"+str(i+1) for i in range(anc)], ancestral="ANC")                                                                                                        \
                                                                                                                                                                                                                   
demography.add_population_split(time=2000, derived=["R3"], ancestral="O")


totalsamplesize = 0
samplesperancpop =2  ## how many from each pop1, pop2, pop3                                                                                                                                                        
for i in range(anc):
    totalsamplesize += samplesperancpop

popdict = {"ADMIX":anc*5}
for i in range(anc):
    key = "pop"+str(i+1)
    popdict[key] = samplesperancpop

popdict["R1"] = 2
popdict["R2"] = 2
popdict["R3"] = 2
popdict["O"] = 2
popdict["R1a"] = 2
popdict["R3a"] = 2
# Define demographic events
# Run the simulation                                                                                                                                                                                               
ts = msprime.sim_ancestry(popdict,
                          recombination_rate=1e-8,###########                                                                                                                                                     \
                                                                                                                                                                                                                   
                          sequence_length=args.length,
                          ##population_size=1000,                                                                                                                                                                 \
                                                                                                                                                                                                                   
                          random_seed=simseeds[0],
                          demography=demography,
                          ploidy=2)

db = demography.debug()
db.print_history()

print("Simulation ancestry OK")

# with open('test_image.svg', 'wb') as svg_file:                                                                                                                                                                  \
                                                                                                                                                                                                                   
#     svg_file.write(ts.draw_svg().encode())                                                                                                                                                                      \
                                                                                                                                                                                                                   

print("File svg output OK")
mts = msprime.sim_mutations(ts, rate=1e-8, random_seed=simseeds[1])

print(len(mts.sites()))

print("mutations OK")


indoutput = args.output+".ind"
with open(indoutput, "w") as indfile:
    for i in ts.populations():
        popid = i.id
        for j in ts.samples(population=popid):
            if j % 2 == 0:
                ln = "tsk_"+str(int(j/2))+"\tU\t"+i.metadata["name"]+"\n"
                print(ln)
                indfile.write(ln)


with open(args.output+".vcf", "w") as vcf_file:
    mts.write_vcf(vcf_file)


print("The proportions are: ", proportions)

with open("proportions.txt", "w") as f:
    f.write('\t'.join([str(pr) for pr in proportions]))

with open("command_line.txt", "w") as f:
    f.write('\t'.join(sys.argv))
