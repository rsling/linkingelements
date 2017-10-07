rm(list=ls())

setwd("~/Linguistics/Incubator/Fugen/Split")

set.seed(2364)

full <- read.csv('stimuli.csv', sep="\t", stringsAsFactors = F)

for (i in 100:999) {
  print(i)

  # First, randomize order (left/right) of answers.
  answer.order <- sample(c(T,F), nrow(full), replace = T)
  
  this.full <- cbind(full, swapped = answer.order)
  for (k in 1:nrow(this.full)) {
    if (this.full[k, 'swapped']) this.full[k, c('opt1', 'opt2')] <- this.full[k, c('opt2', 'opt1')]
  }
    
  # Randomize block assignments.
  which.is.1 <- sample(1:2, 1)
  #print(which.is.1)
  
  # Get blocks.
  block.1 <- this.full[which(this.full$block == which.is.1),]
  block.2 <- this.full[-which(this.full$block == which.is.1),]
  
  # Randomize. BLOCK1
  targets.1     <- block.1[which(block.1$subExp %in% c('pl', 'coll')), ]
  targets.1     <- targets.1[sample(1:nrow(targets.1), nrow(targets.1), replace = F),]
  nontargets.1  <- block.1[-which(block.1$subExp %in% c('pl', 'coll')), ]
  nontargets.1  <- nontargets.1[sample(1:nrow(nontargets.1), nrow(nontargets.1), replace = F),]
  breakpoints.1 <- sort(sample(1:(nrow(nontargets.1)-1), nrow(targets.1), replace = F))
  #print (breakpoints.1)
  final.1       <-  NULL
  for (j in 1:length(breakpoints.1)) {
    block.lower <- ifelse(j == 1, 1, breakpoints.1[j-1]+1)
    block.upper <- ifelse(j == length(breakpoints.1), nrow(nontargets.1), breakpoints.1[j])
    #print(c(block.lower, block.upper))
    if (is.null(final.1)) {
     final.1 <- rbind(nontargets.1[block.lower:block.upper,], targets.1[j,]) 
    } else {
      final.1 <- rbind(final.1, nontargets.1[block.lower:block.upper,], targets.1[j,]) 
    }
  }
  #cat("\n =>", nrow(final.1), "\n")

  # Randomize. BLOCK2
  targets.2     <- block.2[which(block.2$subExp %in% c('pl', 'coll')), ]
  targets.2     <- targets.2[sample(1:nrow(targets.2), nrow(targets.2), replace = F),]
  nontargets.2  <- block.2[-which(block.2$subExp %in% c('pl', 'coll')), ]
  nontargets.2  <- nontargets.2[sample(1:nrow(nontargets.2), nrow(nontargets.2), replace = F),]
  breakpoints.2 <- sort(sample(1:(nrow(nontargets.2)-1), nrow(targets.2), replace = F))
  #print (breakpoints.2)
  final.2       <-  NULL
  for (j in 1:length(breakpoints.2)) {
    block.lower <- ifelse(j == 1, 1, breakpoints.2[j-1]+1)
    block.upper <- ifelse(j == length(breakpoints.2), nrow(nontargets.2), breakpoints.2[j])
    #print(c(block.lower, block.upper))
    if (is.null(final.2)) {
      final.2 <- rbind(nontargets.2[block.lower:block.upper,], targets.2[j,]) 
    } else {
      final.2 <- rbind(final.2, nontargets.2[block.lower:block.upper,], targets.2[j,]) 
    }
  }
  #cat("\n =>", nrow(final.2), "\n")
  
  if (nrow(block.1) != nrow(final.1)) cat("ERROR Block 1:", nrow(block.1), nrow(final.1), "\n")
  if (nrow(block.2) != nrow(final.2)) cat("ERROR Block 2:", nrow(block.2), nrow(final.2), "\n")
  
  # Cat and check whether all indices are there.
  final <- rbind(final.1, final.2)
  if (FALSE %in% (1:58 == sort(final$idx))) {
    cat("ERROR: INCOHERENT INDEXING!\n")
    print(final$idx)
  }
  
  write.csv(final, file = paste0('stimuli/', i, '.csv'), row.names = F)
  
}
