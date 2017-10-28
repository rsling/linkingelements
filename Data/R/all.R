# Run the whole study.
# Mainly for documentation purposed, not to be run by
# default.

# This takes a long time, and approx. run times are given
# based on my high-performance MacBook Pro.

# Please set working directory to the directory where this
# script is located first.

system.time(source('load.R'))                     #   5m 25s
system.time(source('productivity.R'))             #   1m 39s
system.time(source('plot_productivity.R'))        #      24s
system.time(source('frequency_all.R'))            #
system.time(source('corpus_candidates.R'))        #
system.time(source('plot_selections.R'))          # <    01s
