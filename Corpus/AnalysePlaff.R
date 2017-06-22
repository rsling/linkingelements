rm(list=ls())

save.persistent <- T
outdir          <- 'Output/'
n.explore       <- 50 

setwd("~/Projects/Fugen/Preparation")

#######################################################################

pl     <- read.csv2(file = '~/Projects/Fugen/Preparation/Elizabeth.csv', sep = '\t', header = T, quote = '')
tyf.n1 <- read.csv2(file = '~/Projects/Fugen/Preparation/Typefreq_QueriesN1.csv', sep = '\t', header = T, quote = '')
tyf.n2 <- read.csv2(file = '~/Projects/Fugen/Preparation/Typefreq_QueriesN2.csv', sep = '\t', header = T, quote = '')
tof.n1 <- read.csv2(file = '~/Projects/Fugen/Preparation/TokenfreqN1.csv', sep = '\t', header = T, quote = '')
tof.n2 <- read.csv2(file = '~/Projects/Fugen/Preparation/TokenfreqN2.csv', sep = '\t', header = T, quote = '')

get.f <- function(r, c, df) {
  N <- as.character(unlist(unname(r[c])))
  sel <- which(df[c] == N)
  if (length(sel) != 0) df[sel, ]
  else rep(NA, ncol(df))
}

get.ps <- function(r) {
  list('N1_P_LE' = as.numeric(r['N1_TOF_LE'])/as.numeric(r['N1_HAPAX_LE']),
       'N1_P_NLE' = as.numeric(r['N1_TOF_NLE'])/as.numeric(r['N1_HAPAX_NLE']),
       'N2_P_LE' = as.numeric(r['N2_TOF_LE'])/as.numeric(r['N2_HAPAX_LE']),
       'N2_P_NLE' = as.numeric(r['N2_TOF_NLE'])/as.numeric(r['N2_HAPAX_NLE'])
       )
}


# Pull type and token frequencies and hapax count.

# N1
freqs <- data.frame(matrix(unlist(apply(pl, 1, function(r) {get.f(r, 'N1', tyf.n1)})), nrow = nrow(pl), byrow = T))
pl <- cbind(pl, freqs[,2:5])
colnames(pl) <- c(head(colnames(pl), n=6), "N1_TYF_LE", "N1_HAPAX_LE", "N1_TYF_NLE", "N1_HAPAX_NLE")
freqs <- data.frame(matrix(unlist(apply(pl, 1, function(r) {get.f(r, 'N1', tof.n1)})), nrow = nrow(pl), byrow = T))
pl <- cbind(pl, freqs[,2:3])
colnames(pl) <- c(head(colnames(pl), n=-2), "N1_TOF_LE", "N1_TOF_NLE")

# N2
freqs <- data.frame(matrix(unlist(apply(pl, 1, function(r) {get.f(r, 'N2', tyf.n2)})), nrow = nrow(pl), byrow = T))
pl <- cbind(pl, freqs[,2:5])
pl <- pl[complete.cases(pl),]
colnames(pl) <- c(head(colnames(pl), n=-4), "N2_TYF_LE", "N2_HAPAX_LE", "N2_TYF_NLE", "N2_HAPAX_NLE")
freqs <- data.frame(matrix(unlist(apply(pl, 1, function(r) {get.f(r, 'N2', tof.n2)})), nrow = nrow(pl), byrow = T))
pl <- cbind(pl, freqs[,2:3])
colnames(pl) <- c(head(colnames(pl), n=-2), "N2_TOF_LE", "N2_TOF_NLE")

# Calculate productivity P.
ps <- data.frame(matrix(unlist(apply(pl, 1, get.ps)), nrow = nrow(pl), byrow = T))
pl <- cbind(pl, ps)
colnames(pl) <- c(head(colnames(pl), n=-4), "N1_P_LE", "N1_P_NLE", "N2_P_LE", "N2_P_NLE")

pl.uniq.n1 <- pl[!duplicated(pl[,'N1']), c("N1", "N1type",
                                           "N1_TYF_LE", "N1_HAPAX_LE", "N1_TYF_NLE",
                                           "N1_HAPAX_NLE", "N1_TOF_LE", "N1_TOF_NLE",
                                           "N1_P_LE", "N1_P_NLE")]
pl.uniq.n2 <- pl[!duplicated(pl[,'N2']),c("N2", "N2_TYF_LE", "N2_HAPAX_LE", "N2_TYF_NLE",
                                          "N2_HAPAX_NLE", "N2_TOF_LE", "N2_TOF_NLE",
                                          "N2_P_LE", "N2_P_NLE")]

# Get the difference between LE and NLE productivity.
pl.uniq.n1$N1_P_DIFF <- pl.uniq.n1$N1_P_LE - pl.uniq.n1$N1_P_NLE
pl.uniq.n2$N2_P_DIFF <- pl.uniq.n2$N2_P_LE - pl.uniq.n2$N2_P_NLE

if (save.persistent) sink(paste0(outdir, 'explore.txt'))
print(head(pl.uniq.n1[order(abs(pl.uniq.n1$N1_P_DIFF)),], n = n.explore))
print(head(pl.uniq.n2[order(abs(pl.uniq.n2$N2_P_DIFF)),], n = n.explore))
if (save.persistent) sink()

# Plot relations between productivity with LE and without.
my.colors = colorRampPalette(c("dark green", "dark orange"))(100)

if (save.persistent) pdf(paste0(outdir, 'prodrel_n1.pdf'))
prod.n1 <- plot(pl.uniq.n1$N1_P_LE~pl.uniq.n1$N1_P_NLE, pch=18,
     main="Productivity (as N1) with and without linking element\n(productivity index P=N/N[H])",
     xlab="P with no linking element",
     ylab="P with linking element",
     bty = "n", cex=0)
abline(0, 1, col="lightgray", lty = 2, lwd = 3)
for (i in 1:nrow(pl.uniq.n1)) {
  text(pl.uniq.n1[i, 'N1_P_NLE'], pl.uniq.n1[i, 'N1_P_LE'], labels=pl.uniq.n1[i, 'N1'],
       cex = 1.5,
       srt = runif(1, -90, 90),
       col = my.colors[runif(1, 0, 100)])
}
if (save.persistent) dev.off()

if (save.persistent) pdf(paste0(outdir, 'prodrel_n2.pdf'))
prod.n2 <- plot(pl.uniq.n2$N2_P_LE~pl.uniq.n2$N2_P_NLE, pch=18,
                main="Productivity (as N2) with and without linking element\n(productivity index P=N/N[H])",
                xlab="P with no linking element",
                ylab="P with linking element",
                bty = "n", cex=0)
abline(0, 1, col="lightgray", lty = 2, lwd = 3)
for (i in 1:nrow(pl.uniq.n1)) {
  text(pl.uniq.n2[i, 'N2_P_NLE'], pl.uniq.n2[i, 'N2_P_LE'], labels=pl.uniq.n2[i, 'N2'],
       cex = 1.5,
       srt = runif(1, -90, 90),
       col = my.colors[runif(1, 0, 100)])
}
if (save.persistent) dev.off()

