rm(list = ls())
source('functions.R')

load("RData/analyses.full.RData")

les <- c('e', 'Ue', 'er', 'Uer', 'n', 'en')

corpus.candidates <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)

for (le in les) {
  .cands <- analyses.full[[le]][which(
                                      analyses.full[[le]]$With_Ftype > 100 &
                                      analyses.full[[le]]$Without_Ftype > 100 &
                                      analyses.full[[le]]$With_Ppot != 0 &
                                      analyses.full[[le]]$Without_Ppot != 0 &
                                      analyses.full[[le]]$With_Ppot != 1 &
                                      analyses.full[[le]]$Without_Ppot != 1
      ), ]
  corpus.candidates[[le]] <- .cands
  plot(corpus.candidates[[le]]$With_Ppot~corpus.candidates[[le]]$Without_Ppot, log="xy", main = paste0(le, '\n', nrow(corpus.candidates[[le]])))
  print(corpus.candidates[[le]]$N1)
}


# TODO: (1) Get N1 frequency and use only reasonably frequent N1s.
# (2) Exclude mass nouns and collectives as N1.
# (3) Remaining N1s are candidates for corpus study.
