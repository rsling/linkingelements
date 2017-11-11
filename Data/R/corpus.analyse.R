rm(list = ls())
set.seed(109)

library(multtest)

source('functions.R')

in.file           <- '../Corpusstudy/Concordance.csv'
plot.dir          <- './Plots/'
save.persistently <- T
alpha.nominal     <- 0.05
monte.carlo       <- T
num.reps          <- 10000
my.colors         <- colorRampPalette(c("orange", "darkgreen"))(100)

### DO NOT MODIFY PAST THIS LINE ###

conc = read.csv2(in.file, header = T, sep = "\t")

m           <- length(levels(conc$N1Lemma))
alpha.sidak <- 1-(1-alpha.nominal)^(1/m)
cl.sidak    <- (1-alpha.nominal)^(1/m)

tests.per.lemma <- data.frame(
  lemma      = rep(NA, m),
  link       = rep(NA, m),
  p.raw      = rep(1, m),
  phi        = rep(0, m),
  p.sidak    =  rep(1, m)
)

for (i in 1:m) {
  .n1 <- levels(conc$N1Lemma)[i]
  .le <- le.name(as.character(conc[head(which(conc$N1Lemma == levels(conc$N1Lemma)[i]), n = 1), "N1Pl"]))
  .the.table <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2Typ)
  .the.table <- .the.table + 1
  .the.test <- chisq.test(.the.table, simulate.p.value = monte.carlo, B = num.reps)

  tests.per.lemma[i, "lemma"]      <- .n1
  tests.per.lemma[i, "link"]       <- .le
  tests.per.lemma[i, "p.raw"]      <- as.numeric(.the.test$p.value)
  tests.per.lemma[i, "phi"]        <- sqrt(as.numeric(.the.test$statistic)/sum(.the.table)) * sign(.the.test$residuals[1,1]) * -1
  tests.per.lemma[i, "p.sidak"]    <- adjust.p.sidak(as.numeric(.the.test$p.value), m)
}



t.plot        <- tests.per.lemma[order(tests.per.lemma$phi, decreasing = F),]
t.plot$link   <- as.factor(t.plot$link)
t.plot$colors <- unlist(lapply(t.plot$p.sidak, function(x) map.my.ramp(x, my.colors)))

save(list = "t.plot", file = "RData/t.plot.RData", compress = "bzip2")

if (save.persistently) pdf(paste0(plot.dir, "phi.pdf"))
  dotchart(t.plot$phi,
           xlim=c(-0.1, +0.5),
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
  legend("topright", title = "p-values",
         legend = c("0", "0.05", "0.1", "0.5", "1"),
         col = c(my.colors[100], my.colors[65], my.colors[50], my.colors[16], my.colors[1]),
         pch=19, bg = "white")
if (save.persistently) dev.off()




# Just convince yourself that there is nothing going on
# except the plurality-inducing thing with N2.
#
# library(lme4)
#
# load("RData/analyses.full.RData")
# analyses.full <- rbind(analyses.full[["e"]],
#       analyses.full[["en"]],
#       analyses.full[["er"]],
#       analyses.full[["n"]],
#       analyses.full[["Ue"]],
#       analyses.full[["Uer"]],
#       analyses.full[["U"]]
#       )
# conc.enriched <- merge(conc, analyses.full, by.x = "N1Lemma", by.y = "N1")
#
# le.glmm <- glmer(LE~N2Num*N2Typ+N1Pl+scale(With_Ppot)*scale(Without_Ppot)+scale(log(With_Ftype))*scale(log(Without_Ftype))+(1+N2Typ|N1Lemma), family = binomial(link = logit), data = conc.enriched)
# summary(le.glmm)
#
# # Great example of getting -1 covariance! VCOV matrix not estimated correctly.
# le.glmm.vivfs <- glmer(LE~N2Typ+(1+N2Typ|N1Lemma), family = binomial(link = logit), data = conc.enriched)
# summary(le.glmm.vivs)
