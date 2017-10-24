rm(list = ls())
source('functions.R')

load("RData/analyses.full.RData")
load("RData/noun.frequencies.RData")

les <- c('e', 'Ue', 'er', 'Uer', 'n', 'en')
rescue.fband         <- 7           # N1 with prod. w/o LE = 0 but frequency band lower than this will be included.
n1asn1.typfreq.lim   <- 100         # Minimal type frequency of N1 as N1 in compounds.
n1itself.tokfreq.lim <- 15          # Maximal frequency band of N1 as independent word.
decow16a.highest.f   <- 258507195   # Freq. of "und" in DECOW16A = most frequent word. For frequency bands.

corpus.candidates <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)

for (le in les) {

  # First, get N1 frequency data as free word.
  analyses.full[[le]] <- merge(x = analyses.full[[le]], y = noun.frequencies, by.x = 'N1', by.y = 'N', all.x = T)
  colnames(analyses.full[[le]])[colnames(analyses.full[[le]]) == "F"] <- "N1alone_Ftoken"
  analyses.full[[le]]$N1alone_Fband <- round(frequency.band(analyses.full[[le]]$N1alone_Ftoken, decow16a.highest.f), 0)

  .cands <- analyses.full[[le]][which(
                                      analyses.full[[le]]$With_Ftype    >= n1asn1.typfreq.lim &
                                      analyses.full[[le]]$Without_Ftype >= n1asn1.typfreq.lim &
                                      analyses.full[[le]]$With_Ppot     != 0 &
                                      (analyses.full[[le]]$Without_Ppot != 0 | analyses.full[[le]]$N1alone_Fband < rescue.fband) &
                                      analyses.full[[le]]$With_Ppot     != 1 &
                                      analyses.full[[le]]$Without_Ppot  != 1 &
                                      analyses.full[[le]]$N1alone_Fband <= n1itself.tokfreq.lim
      ), ]
  corpus.candidates[[le]] <- .cands

  # For debugging.
  # plot(corpus.candidates[[le]]$With_Ppot~corpus.candidates[[le]]$Without_Ppot, log="xy", main = paste0(le, '\n', nrow(corpus.candidates[[le]])))
  print(as.character(corpus.candidates[[le]]$N1))
}

save(list = "analyses.full", file = "RData/analyses.full.plus.RData", compress = "bzip2")

# TODO: (1) Get N1 frequency and use only reasonably frequent N1s.
# (2) Exclude mass nouns and collectives as N1.
# (3) Remaining N1s are candidates for corpus study.
