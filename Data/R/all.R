# Run the whole study. Mainly for documentation purposed.
# Not intended to be run by default.

# This takes a long time, and approx. run times are given
# as comments based on my high-performance MacBook Pro.

# Please set working directory to the directory where this
# script is located first.

system.time(source('load.R'))                     #    5m 25s
system.time(source('productivity.R'))             #    1m 39s
system.time(source('plot_productivity.R'))        #       24s
system.time(source('frequency_all.R'))            #    2m 48s
system.time(source('corpus_candidates.R'))        #    1m  3s
system.time(source('plot_selections.R'))          # <      1s

# TOTAL RUNTIME                                     > 10m
