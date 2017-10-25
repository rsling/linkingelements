rm(list = ls())
set.seed(429)
source('functions.R')

load("RData/analyses.full.RData")
load("RData/noun.frequencies.RData")
load("RData/compounds.RData")

les <- c('e', 'Ue', 'er', 'Uer', 'n', 'en', 'U')

frequencydata.full <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)


for (le in les) {
  frequencydata.full[[le]] <-
    merge(all.x = T,
      merge(all.x = T,
        merge(all.x = T,
          compounds[[le]], analyses.full[[le]][,c(1,2,6,7,8,9,13,14,15)], by = "N1"
          ),
        noun.frequencies, by.x = "N1", by.y = "N"
        ),
      noun.frequencies, by.x = "N2", by.y = "N"
    )
  colnames(frequencydata.full[[le]])[c(3,12,13)] <- c("Fcompound", "FN1", "FN2")
}

save(list = "frequencydata.full", file = "RData/frequencydata.full.RData", compress = "bzip2")

