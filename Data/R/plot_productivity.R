rm(list = ls())
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
    par(mfrow=c(2,3))
  }
  plot.productivities('e', analyses.full, max.plottable = 50)
  plot.productivities('Ue', analyses.full, max.plottable = 50)
  plot.productivities('er', analyses.full, max.plottable = 50)
  plot.productivities('Uer', analyses.full, max.plottable = 50)
  plot.productivities('n', analyses.full, max.plottable = 50)
  plot.productivities('en', analyses.full, max.plottable = 50)
  if (save.persistently) {
    par(mfrow=c(1,1))
    dev.off()
  }
}


if (plot.dotcloud) {
  if (save.persistently) {
    dir.create('./Plots', showWarnings = F)
    pdf("Plots/productivity_dots.pdf")
    par(mfrow=c(2,3))
  }
  plot.productivities('e', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  plot.productivities('Ue', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  plot.productivities('er', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  plot.productivities('Uer', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  plot.productivities('n', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  plot.productivities('en', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
  if (save.persistently) {
    par(mfrow=c(1,1))
    dev.off()
  }
}

options(scipen=0)
