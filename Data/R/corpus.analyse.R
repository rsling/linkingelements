rm(list = ls())
set.seed(109)

library(multtest)

source('functions.R')
in.file           <- '../Corpusstudy/Concordance.csv'
plot.dir          <- './Plots/'
save.persistently <- T
alpha.nominal     <-   0.05
num.reps          <- 2000
my.colors         <- colorRampPalette(c("darkgreen", "orange"))(100)

### DO NOT MODIFY PAST THIS LINE ###

conc = read.csv2(in.file, header = T, sep = "\t")

m           <- length(levels(conc$N1Lemma))
alpha.sidak <- 1-(1-alpha.nominal)^(1/m)
cl.sidak    <- (1-alpha.nominal)^(1/m)

tests.per.lemma <- data.frame(
  lemma    = rep(NA, m),
  link     = rep(NA, m),
  p.raw    = rep(1, m),
  phi      = rep(0, m),

  p.sidak  =  rep(1, m)
)

adjust.p.sidak <- function(p, m) { 1-(1-p)^m }

for (i in 1:m) {
  .n1 <- levels(conc$N1Lemma)[i]
  .le <- as.character(conc[head(which(conc$N1Lemma == levels(conc$N1Lemma)[i]), n = 1), "N1Pl"])
  .the.table <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2Typ)
  .the.table <- .the.table + 1
  .the.test <- chisq.test(.the.table, simulate.p.value = T, B = num.reps)

  tests.per.lemma[i, "lemma"]    <- .n1
  tests.per.lemma[i, "link"]     <- .le
  tests.per.lemma[i, "p.raw"]    <- as.numeric(.the.test$p.value)
  tests.per.lemma[i, "phi"]      <- sqrt(as.numeric(.the.test$statistic)/sum(.the.table)) * sign(.the.test$residuals[1,1]) * -1
  tests.per.lemma[i, "p.sidak"]  <- adjust.p.sidak(as.numeric(.the.test$p.value), m)
}



t.plot        <- tests.per.lemma[order(tests.per.lemma$phi, decreasing = F),]
t.plot$link   <- as.factor(t.plot$link)
t.plot$colors <- my.colors[round(t.plot$p.sidak*100, 0)]

if (save.persistently) pdf(paste0(plot.dir, "phi.pdf"))
  dotchart(t.plot$phi,
           xlim=c(-0.1, +0.5),
           #labels = t.plot$lemma,
           labels = paste0(t.plot$lemma, "(p=", round(t.plot$p.sidak, 3), ")"),
           pch = 19,
           cex=0.75,
           cex.axis = 5,
           gcolor = "black",
           groups = t.plot$link,
           color = t.plot$colors,
           main = "Signed effect strength for the use of N1 with\npluralic linking element if N2 favours plural semantics on N1",
           xlab=paste0("Cramer's phi (signed) derived from bootstrapped Chi-square (B=", num.reps, ")"),
           sub = "[Note: p-values for colour-coding were corrected for GWE using Sidak's method.]"
           )
  abline(v = 0.2, col = "lightgray", lty = 3, lwd=2)
  legend("topright", legend = c("p=0", "p=0.5", "p=1"), col = c(my.colors[1], my.colors[50], my.colors[100]), pch=19, bg = "white")
if (save.persistently) dev.off()
