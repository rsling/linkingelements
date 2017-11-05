rm(list = ls())
set.seed(827)
source('functions.R')

save.persistently <- T

load("RData/analyses.full.plus.RData")
load("RData/corpus.candidates.RData")

# Items in original corpus study:
original <- list(
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


# Plot old corpus study candidates in context.

if (save.persistently) {
  dir.create('./Plots', showWarnings = F)
  pdf("Plots/corpus.candidates.pdf")
}
par(mfrow=c(3,3))
for (le in les) {
  .le.name <- le.name(le)
  plot(corpus.candidates[[le]]$Without_Ppot ~ corpus.candidates[[le]]$With_Ppot,
       log="xy",
       pch = 20,
       cex = 1,
       col = "darkorange",
       xlim = c(0.001, 1),
       ylim = c(0.001, 1),
       main = paste0("Cand. for corpus study: ", .le.name),
       xlab = paste0("Productivity with ", .le.name),
       ylab = paste0("Productivity without ", .le.name)
  )
  .orig <- which(corpus.candidates[[le]]$N1 %in% original[[le]]$N1)
  points(corpus.candidates[[le]][.orig,]$Without_Ppot ~ corpus.candidates[[le]][.orig,]$With_Ppot,
         pch = 17,
         cex = 1.5,
         col = "darkgreen"
  )
  # Make blank space in plot.
  if (le == "Uer") plot.new()
}
if (save.persistently) {
  dev.off()
}
par(mfrow=c(1,1))


if (save.persistently) {
  dir.create('./Plots', showWarnings = F)
  pdf("Plots/stimuli.pdf")
}
par(mfrow=c(3,3))
for (le in les) {
  .le.name <- le.name(le)
  plot(corpus.candidates[[le]]$Without_Ppot ~ corpus.candidates[[le]]$With_Ppot,
       log="xy",
       pch = 20,
       cex = 1,
       col = "orange",
       xlim = c(0.001, 1),
       ylim = c(0.001, 1),
       main = paste0("Stimuli for split-100: ", .le.name),
       xlab = paste0("Productivity with ", .le.name),
       ylab = paste0("Productivity without ", .le.name)
  )
  .orig <- which(corpus.candidates[[le]]$N1 %in% stimuli[[le]]$N1)
  points(corpus.candidates[[le]][.orig,]$Without_Ppot ~ corpus.candidates[[le]][.orig,]$With_Ppot,
         pch = 15,
         cex = 1.5,
         col = "blue"
  )
  # Make blank space in plot.
  if (le == "Uer") plot.new()
}
if (save.persistently) {
  dev.off()
}
par(mfrow=c(1,1))
