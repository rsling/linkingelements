rm(list = ls())
set.seed(827)
source('functions.R')

dir.create('./Results', showWarnings = F)

load("RData/analyses.full.RData")
load("RData/noun.frequencies.RData")

# Items in corpus study:
corpus.items <- list(
  U   = data.frame(N1 = c("Mutter", "Vater", "Apfel", "Nagel", "Vogel")),
  Ue  = data.frame(N1 = c("Stadt", "Hand", "Zahn", "Ball", "Vorgang")),
  Uer = data.frame(N1 = c("Buch", "Haus", "Bad", "Rad", "Schloss", "Wurm")),
  e   = data.frame(N1 = c("Hund", "Gerät", "Weg", "Geschenk", "Produkt", "Brief",
                          "Gebot", "Instrument", "Kerl", "Exponat", "Kompliment", "Umstieg")),
  er  = data.frame(N1 = c("Kind", "Bild", "Ei", "Lied", "Brett", "Schwert")),
  n   = data.frame(N1 = c("Sonne", "Kunde", "Auge", "Bauer", "Katze", "Gitarre",
                          "Ausrede", "Hüfte", "Wunde")),
  en  = data.frame(N1 = c("Frau", "Person", "Ohr", "Bett", "Dämon",
                          "Bucht", "Forderung", "Möglichkeit", "Portion", "Praktik", "Universität"))
)


# Stimuli:
stimuli <- list(
  Uer = data.frame(N1 = c("Haus", "Bad", "Grab", "Blatt")),
  Ue  = data.frame(N1 = c("Kraft")),
  e   = data.frame(N1 = c("Weg", "Punkt")),
  er  = data.frame(N1 = c("Brett", "Schwert")),
  en  = data.frame(N1 = c("Bett", "Last", "Hemd"))
)

les <- c('e', 'Ue', 'U', 'er', 'Uer', 'n', 'en')
n1asn1.typfreq.lim   <- 50          # Minimal type frequency of N1 as N1 in compounds.
n1itself.tokfreq.lim <- 15          # Maximal frequency band of N1 as independent word.
decow16a.highest.f   <- 258507195   # Freq. of "und" in DECOW16A = most frequent word. For frequency bands.

corpus.candidates <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)

par(mfrow=c(3,3))
for (le in les) {

  # First, get N1 frequency data as free word.
  analyses.full[[le]] <- merge(x = analyses.full[[le]], y = noun.frequencies, by.x = 'N1', by.y = 'N', all.x = T)
  colnames(analyses.full[[le]])[colnames(analyses.full[[le]]) == "F"] <- "N1alone_Ftoken"
  analyses.full[[le]]$N1alone_Fband <- round(frequency.band(analyses.full[[le]]$N1alone_Ftoken, decow16a.highest.f), 0)

  .cands <- analyses.full[[le]][which(
                                      analyses.full[[le]]$With_Ftype      >= n1asn1.typfreq.lim
                                      & analyses.full[[le]]$Without_Ftype >= n1asn1.typfreq.lim
                                      & analyses.full[[le]]$With_Ppot     != 0
                                      & analyses.full[[le]]$Without_Ppot  != 0
                                      & analyses.full[[le]]$With_Ppot     != 1
                                      & analyses.full[[le]]$Without_Ppot  != 1
                                      & analyses.full[[le]]$N1alone_Fband <= n1itself.tokfreq.lim
      ), ]
  corpus.candidates[[le]] <- .cands
}

save(list = "analyses.full", file = "RData/analyses.full.plus.RData", compress = "bzip2")
save(list = "corpus.candidates", file = "RData/corpus.candidates.RData", compress = "bzip2")


# Get info for already existing data.

# Corpus study.
les <- c('e', 'Ue', 'U', 'er', 'Uer', 'n', 'en')
corpus.study <- NULL
for (le in les) {
  .this <- merge(corpus.items[[le]], corpus.candidates[[le]], by = "N1", all.x = T)
  .this$LE <- paste0("+", le.name(le))
  # .this$LE <- le
  if (is.null(corpus.study)) corpus.study <- .this
  else corpus.study <- rbind(corpus.study, .this)
}
write.table(corpus.study, file = "Results/corpus.study.csv", quote = F, sep = "\t", row.names = F)

# Split-100.
les <- c("Uer", "Ue", "e", "er", "en")
stimuli.data <- NULL
for (le in les) {
  .this <- merge(stimuli[[le]], corpus.candidates[[le]], by = "N1", all.x = T)
  .this$LE <- paste0("+", le.name(le))
  # .this$LE <- le
  if (is.null(stimuli.data)) stimuli.data <- .this
  else stimuli.data <- rbind(stimuli.data, .this)
}
write.table(stimuli.data, file = "Results/stimuli.csv", quote = F, sep = "\t", row.names = F)

# Now sample some more N1s for second wave of corpus study.
# We manually selected from the list generated like so:
# new.sample <- list()
# for (le in c("e", "Ue", "U", "er", "Uer", "n", "en")) {
#   new.sample[[le]] <- as.character(analyses.full[[le]][which(
#     in.range(analyses.full[[le]]$With_Ppot, 0.1, 0.7)
#     & in.range(analyses.full[[le]]$Without_Ppot, 0.1, 0.7)
#     & in.range(analyses.full[[le]]$With_Ftype/analyses.full[[le]]$Without_Ftype, 0.25, 4)
#     & in.range(analyses.full[[le]]$N1alone_Fband, 5, 13)
#     ),"N1"])
# }
# lapply(new.sample, write, "Results/new.sample.txt", append=TRUE, ncolumns=1000)

# New ones:
# new.sample <- list(
#   Ue  = data.frame(N1 = c("Vorgang")),
#   e   = data.frame(N1 = c("Gebot", "Instrument", "Kerl", "Exponat", "Kompliment", "Umstieg")),
#   n   = data.frame(N1 = c("Ausrede", "Hüfte", "Wunde")),
#   en  = data.frame(N1 = c("Bucht", "Forderung", "Möglichkeit", "Portion", "Praktik", "Universität"))
# )
#
# NOTE: All items were added to corpus.items


# We add them to the old ones, creating new list.
# full.sample <- corpus.items
# for (le in c("Ue", "e", "n", "en")) {
#   full.sample[[le]] <- rbind(full.sample[[le]], new.sample[[le]])
# }
# lapply(full.sample, write, "Results/full.sample.txt", append=TRUE, ncolumns=1000)
