#==================================================
## This script generates admixture plots from Q matrices
# produced by population structure analyses.
# It loops over a range of ancestral population numbers
# and saves all plots into a single PDF file.
# =========================================================


library(popkin)

args = commandArgs(trailingOnly=TRUE)

## the input file
# args[1] = file : Base name of the input Q matrix files
# args[2] = n1   : Minimum number of ancestral populations
# args[3] = n2   : Maximum number of ancestral populations

file = args[1]
# the minimum number of anccestral pops
n1 = args[2]
# the maximum number of ancestral pops
n2 = args[3]


pdf("adm_plots.pdf")
for(i in n1:n2){
    a = read.table(paste(file, ".", i, ".Q", sep=""))
    plot_admix(a)
}
dev.off()

#Output is a pdf file that contains admixture plots. 