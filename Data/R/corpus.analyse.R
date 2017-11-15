rm(list = ls())
set.seed(109)

source('functions.R')

# in.file           <- '../Corpusstudy/Concordance.csv'
in.file           <- '../Corpusstudy/Concordance.full.csv'
plot.dir          <- './Plots/'
save.persistently <- F
alpha.nominal     <- 0.05
monte.carlo       <- T
num.reps          <- 10000
my.colors         <- colorRampPalette(c("orange", "darkgreen"))(100)

### DO NOT MODIFY PAST THIS LINE ###

conc = read.csv2(in.file, header = T, sep = "\t", quote = "")

# We make two different "independent" variables: Coll vs. Rest and Coll+Konvc vs. Rest.
# as.factor(ifelse(as.character(conc$N2Typ) == "Konvc", "Coll", ifelse(as.character(conc$N2Typ) == "Q", "Ind", as.character(conc$N2Typ))))
conc$N2TypLax <- conc$N2Typ
levels(conc$N2TypLax) <- c("Coll", "Ind", "Coll", "Ind")
conc$N2TypStrict <- conc$N2Typ
levels(conc$N2TypStrict) <- c("Coll", "Ind", "Ind", "Ind")

m           <- length(levels(conc$N1Lemma))
alpha.sidak <- 1-(1-alpha.nominal)^(1/m)
cl.sidak    <- (1-alpha.nominal)^(1/m)

tests.per.lemma <- data.frame(
  lemma          = rep(NA, m),
  link           = rep(NA, m),
  p.raw.lax      = rep(1, m),
  p.raw.strict   = rep(1, m),
  phi.lax        = rep(0, m),
  phi.strict     = rep(0, m),
  p.sidak.lax    = rep(1, m),
  p.sidak.strict = rep(1, m)
)

for (i in 1:m) {
  .n1 <- levels(conc$N1Lemma)[i]
  .le <- le.name(as.character(conc[head(which(conc$N1Lemma == levels(conc$N1Lemma)[i]), n = 1), "N1Pl"]))

  .the.table.lax <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2TypLax)
  .the.table.lax <- .the.table.lax + 1
  .the.test.lax  <- chisq.test(.the.table.lax, simulate.p.value = monte.carlo, B = num.reps)

  .the.table.strict <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2TypStrict)
  .the.table.strict <- .the.table.strict + 1
  .the.test.strict  <- chisq.test(.the.table.strict, simulate.p.value = monte.carlo, B = num.reps)

  tests.per.lemma[i, "lemma"]          <- .n1
  tests.per.lemma[i, "link"]           <- .le
  tests.per.lemma[i, "p.raw.lax"]      <- as.numeric(.the.test.lax$p.value)
  tests.per.lemma[i, "p.raw.strict"]   <- as.numeric(.the.test.strict$p.value)
  tests.per.lemma[i, "phi.lax"]        <- sqrt(as.numeric(.the.test.lax$statistic)/sum(.the.table.lax)) * sign(.the.test.lax$residuals[1,1]) * -1
  tests.per.lemma[i, "phi.strict"]     <- sqrt(as.numeric(.the.test.strict$statistic)/sum(.the.table.strict)) * sign(.the.test.strict$residuals[1,1]) * -1
  tests.per.lemma[i, "p.sidak.lax"]    <- adjust.p.sidak(as.numeric(.the.test.lax$p.value), m)
  tests.per.lemma[i, "p.sidak.strict"] <- adjust.p.sidak(as.numeric(.the.test.strict$p.value), m)
}

t.plot        <- tests.per.lemma[order(tests.per.lemma$phi.strict, decreasing = F),]
t.plot$link   <- as.factor(t.plot$link)
save(list = c("num.reps", "t.plot"), file = "RData/t.plot.RData", compress = "bzip2")

if (save.persistently) pdf(paste0(plot.dir, "phi.pdf"))
  dotchart(t.plot$phi.strict,
           xlim=c(-0.2, +0.6),
           labels = paste0(t.plot$lemma, "(p=", round(t.plot$p.sidak.strict, 3), ")"),
           pch = 16,
           cex=0.75,
           cex.axis = 5,
           gcolor = "black",
           groups = t.plot$link,
           color = unlist(lapply(t.plot$p.sidak.strict, function(x) map.my.ramp(x, my.colors))),
           main = "Signed effect strength for the use of N1 with\npluralic linking element if N2 favours plural semantics on N1",
           xlab=paste0("Cramer's phi (signed) derived from bootstrapped Chi-square (B=", num.reps, ")"),
           sub = "[Note: p-values for colour-coding were corrected for GWE using Sidak's method.]"
           )
  abline(v = 0.2, col = "lightgray", lty = 3, lwd=2)
  legend("topright", title = "p-values",
         legend = c("0", "0.05", "0.1", "0.5", "1"),
         col = c(my.colors[100], my.colors[65], my.colors[50], my.colors[16], my.colors[1]),
         pch=19, bg = "white",
         cex = 1.0
         )


  # Now add second level to dotchart. Unfortunately not supported by built-in function.
  this.y <- 1
  for (l in rev(levels(t.plot$link))) {

    .t.subplot <- t.plot[which(t.plot$link == l),]
    # .t.subplot <- .t.subplot[dim(.t.subplot)[1]:1,]
    for (n1 in 1:nrow(.t.subplot)) {
      points(.t.subplot[n1, "phi.lax"], this.y,
             pch = 1,
             col = map.my.ramp(.t.subplot$p.sidak.lax[n1], my.colors)
      )
      this.y <- this.y + 1
    }
    this.y <- this.y + 2
  }
  legend("topleft",
        legend = c("strict", "lax"),
        title = "Annotation",
        bg = "white",
        pch = c(16,1),
        cex = 1.0
        )

if (save.persistently) dev.off()


# Just convince yourself that there is nothing going on
# except the plurality-inducing thing with N2.
library(lme4)

load("RData/analyses.full.RData")
analyses.full <- rbind(analyses.full[["e"]],
      analyses.full[["en"]],
      analyses.full[["er"]],
      analyses.full[["n"]],
      analyses.full[["Ue"]],
      analyses.full[["Uer"]],
      analyses.full[["U"]]
      )
conc.enriched <- merge(conc, analyses.full, by.x = "N1Lemma", by.y = "N1")

# Comparing a model with all kind of regressors with one that only includes N2Typ and Lemma.
le.glmm <- glmer(LE~N2Num+N2TypLax+N1Pl+scale(With_Ppot)*scale(Without_Ppot)+scale(log(With_Ftype))*scale(log(Without_Ftype))+(1|N1Lemma),
                 family = binomial(link = logit),
                 data = conc.enriched,
                 nAGQ=0,
                 control=glmerControl(optimizer="nloptwrap2", optCtrl=list(maxfun=2e5))
                 )

le.glmm.0 <- glmer(LE~N2TypLax+(1|N1Lemma),
                   family = binomial(link = logit),
                   data = conc.enriched,
                   nAGQ=0,
                   control=glmerControl(optimizer="nloptwrap2", optCtrl=list(maxfun=2e5))
                   )

cat("\n\nComparing model with additional factors\n")
print(anova(le.glmm, le.glmm.0))

# Showing that for VIVS the amount of data is insufficient.
le.glmm.vivs <- glmer(LE~N2TypLax+(1+N2TypLax|N1Lemma),
                      family = binomial(link = logit),
                      data = conc.enriched,
                      nAGQ=0,
                      control=glmerControl(optimizer="nloptwrap2", optCtrl=list(maxfun=2e5))
                      )

cat("\n\nVariance-covariance in VIVS model\n")
print(VarCorr(le.glmm.vivs))


# Check consistency for some N2s:
# conc[grep('hospiz', conc$Match), c("Match", "N2Typ")]


