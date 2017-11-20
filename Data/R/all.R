# Run the whole study. Mainly for documentation purposed.
# Not intended to be run by default.

# This takes a long time. See timing info from my MacBook at EOF.
# Also included is date info for final run used in paper.

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
print(system.time(source('split100_analyse.R')))

print(Sys.time())

# Output from final run, which created data used in paper.

# [1] "2017-11-20 12:47:39 GMT"
# user  system elapsed
# 338.882   3.087 343.361
# user  system elapsed
# 172.448  28.110 201.459
# user  system elapsed
# 2.328   0.283   2.630
# user  system elapsed
# 175.131   4.776 180.482
# user  system elapsed
# 65.883   1.833  67.907
# user  system elapsed
# 0.115   0.064   0.197
# user  system elapsed
# 4.296   0.189   4.515
# user  system elapsed
# 2.394   0.407   2.819
# [1] "2017-11-20 13:01:19 GMT"
