rm(list = ls())
set.seed(238)
source('functions.R')
load("RData/analyses.full.RData")

lwd               <- 3
lty               <- 1:10
col               <- 1:10
save.persistently <- T
plot.dotcloud     <- T
plot.wordcloud    <- T
my.colors         <- colorRampPalette(c("yellow", "darkred"))(100)

options(scipen=9999)

if (plot.wordcloud) {
  if (save.persistently) {
    dir.create('./Plots', showWarnings = F)
    pdf("Plots/productivity_wordcloud.pdf")
    par(mfrow=c(3,3))
  }

  .args <- list(analyses      = analyses.full,
                dots          = F,
                max.plottable = 10,
                norm.xax      = c(10^-3, 1),
                norm.yax      = c(10^-3, 2),
                zero.floor    = NULL,
                the.colors    = my.colors)
  for (le in c('e', 'Ue', 'U', 'er', 'Uer', 'EMPTY_PLOT', 'n', 'en')) do.call(plot.productivities, c(list(le = le), .args))
  if (save.persistently) {
    par(mfrow=c(1,1))
    dev.off()
  }
}


if (plot.dotcloud) {
  if (save.persistently) {
    dir.create('./Plots', showWarnings = F)
    pdf("Plots/productivity_dots.pdf")
    par(mfrow=c(3,3))
  }
  .args <- list(analyses      = analyses.full,
                dots          = T,
                max.plottable = -1,
                norm.xax      = c(10^-3, 1),
                norm.yax      = c(10^-3, 2),
                zero.floor    = NULL,
                the.colors    = my.colors)
  for (le in c('e', 'Ue', 'U', 'er', 'Uer', 'EMPTY_PLOT', 'n', 'en')) do.call(plot.productivities, c(list(le = le), .args))
  if (save.persistently) {
    par(mfrow=c(1,1))
    dev.off()
  }
}

options(scipen=0)
