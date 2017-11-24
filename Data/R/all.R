# Run the whole study. Mainly for documentation purposed.
# Not intended to be run by default.

# This takes a long time.

print(Sys.time())

# This works only when sourced. (I think.)
setwd(dirname(parent.frame(2)$ofile))
par(mar= c(5.1, 4.1, 4.1, 2.1))

print(system.time(source('load.R')))
print(system.time(source('productivity.R')))
print(system.time(source('plot_productivity.R')))
print(system.time(source('frequency_all.R')))
print(system.time(source('candidates.R')))
print(system.time(source('plot_selections.R')))

# Run these to replicate the analysis of the corpus study and
# the split-100 experiment:

print(system.time(source('corpus_analyse.R')))
print(system.time(source('corpus_analyse_pl.R')))
print(system.time(source('split100_analyse.R')))

print(Sys.time())
