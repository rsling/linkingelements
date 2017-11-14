rm(list = ls())
set.seed(827)
source('functions.R')

save.persistently <- T

load("RData/corpus.candidates.RData")


# Plot corpus study candidates in context.
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
  .orig <- which(corpus.candidates[[le]]$N1 %in% corpus.items[[le]]$N1)
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
