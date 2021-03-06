rm(list = ls())
set.seed(827)
source('functions.R')

out.dir <- 'Results/'

load("RData/analyses.full.RData")
load("RData/noun.frequencies.RData")

dir.create(out.dir, showWarnings = F)

# Items in corpus study:
corpus.items <- list(
  U   = data.frame(N1 = c("Mutter", "Vater", "Apfel", "Nagel", "Vogel")),
  Ue  = data.frame(N1 = c("Stadt", "Hand", "Zahn", "Ball")),
  Uer = data.frame(N1 = c("Buch", "Haus", "Bad", "Rad", "Schloss", "Wurm", "Loch")),
  e   = data.frame(N1 = c("Hund", "Gerät", "Weg", "Geschenk", "Produkt", "Brief",
                          "Element", "Geräusch", "Zitat")),
  er  = data.frame(N1 = c("Kind", "Bild", "Ei", "Lied", "Brett", "Schwert")),
  n   = data.frame(N1 = c("Sonne", "Kunde", "Auge", "Bauer", "Katze", "Gitarre",
                          "Kommune", "Birne", "Schwester")),
  en  = data.frame(N1 = c("Frau", "Person", "Ohr", "Bett", "Dämon",
                          "Bucht", "Projektor", "Hemd", "Nation", "Eigenschaft"))
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
  analyses.full[[le]]$N1alone_Fband <- frequency.band(analyses.full[[le]]$N1alone_Ftoken, decow16a.highest.f)

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
par(mfrow=c(1,1))


# Extract info for the candidates.

# Corpus study.
les.corpus <- c('e', 'Ue', 'U', 'er', 'Uer', 'n', 'en')
corpus.study <- NULL
for (le in les.corpus) {
  .this <- merge(corpus.items[[le]], corpus.candidates[[le]], by = "N1", all.x = T)
  .this$LE <- paste0("+", le.name(le))
  if (is.null(corpus.study)) corpus.study <- .this
  else corpus.study <- rbind(corpus.study, .this)
}
write.table(corpus.study, file = paste0(out.dir, "corpus_candidates.csv"), quote = F, sep = "\t", row.names = F)

# Split-100.
les.split100 <- c("Uer", "Ue", "e", "er", "en")
stimuli.data <- NULL
for (le in les.split100) {
  .this <- merge(stimuli[[le]], corpus.candidates[[le]], by = "N1", all.x = T)
  .this$LE <- paste0("+", le.name(le))
  if (is.null(stimuli.data)) stimuli.data <- .this
  else stimuli.data <- rbind(stimuli.data, .this)
}
write.table(stimuli.data, file = paste0(out.dir, "split100_stimuli.csv"), quote = F, sep = "\t", row.names = F)



save(list = "analyses.full", file = "RData/analyses.full.plus.RData", compress = "bzip2")
save(list = c("les", "les.corpus", "les.split100", "corpus.items", "stimuli", "corpus.candidates",
              "corpus.study", "stimuli.data", "n1asn1.typfreq.lim", "n1itself.tokfreq.lim", "decow16a.highest.f"),
     file = "RData/corpus.candidates.RData", compress = "bzip2")

