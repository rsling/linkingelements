source('functions.R')
load("analyses.full.RData")

lwd <- 3
lty <- 1:10
col <- 1:10
options(scipen=999)
save.persistently <- F
my.colors = colorRampPalette(c("yellow", "darkred"))(100)


# if (save.persistently) {
#   pdf("productivity_wordcloud.pdf")
#   par(mfrow=c(2,3))
# }
# plot.productivities('e', analyses.full)
# plot.productivities('Ue', analyses.full)
# plot.productivities('er', analyses.full)
# plot.productivities('Uer', analyses.full)
# plot.productivities('n', analyses.full)
# plot.productivities('en', analyses.full)
# if (save.persistently) {
#   par(mfrow=c(1,1))
#   dev.off()
# }


if (save.persistently) {
  pdf("productivity_dots.pdf")
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

options(scipen=0)
