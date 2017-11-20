rm(list = ls())
set.seed(109)

source('functions.R')

in.file           <- '../Corpusstudy/Concordance.full.csv'
plot.dir          <- './Plots/'
out.dir           <- './Results/'
save.persistently <- T
alpha.nominal     <- 0.05
monte.carlo       <- T
num.reps          <- 10000
plot.corr.effect  <- T
my.colors         <- colorRampPalette(c("orange", "darkgreen"))(100)

### DO NOT MODIFY ANYTHING PAST THIS LINE ###

conc = read.csv2(in.file, header = T, sep = "\t", quote = "")

# We make two different "independent" variables: Coll vs. Rest and Coll+Konvc vs. Rest.
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
  n              = rep(0, m),
  p.raw.lax      = rep(1, m),
  smooth.lax     = rep(F, m),
  p.raw.strict   = rep(1, m),
  smooth.strict  = rep(F, m),
  phi.lax        = rep(0, m),
  phi.strict     = rep(0, m),
  p.sidak.lax    = rep(1, m),
  p.sidak.strict = rep(1, m),
  p.hoch.lax     = rep(1, m),
  p.hoch.strict  = rep(1, m)
)

for (i in 1:m) {
  .n1 <- levels(conc$N1Lemma)[i]
  .le <- le.name(as.character(conc[head(which(conc$N1Lemma == levels(conc$N1Lemma)[i]), n = 1), "N1Pl"]))

  # In ONE case ("Sonne"), we have a zero marginal and need to smooth.
  .the.table.lax <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2TypLax)
  if (0 %in% c(margin.table(.the.table.lax, c(1)), margin.table(.the.table.lax, c(2)))) {
    .the.table.lax <- .the.table.lax + 1
    tests.per.lemma[i, "smooth.lax"] <- T
  }
  .the.test.lax  <- chisq.test(.the.table.lax, simulate.p.value = monte.carlo, B = num.reps)

  .the.table.strict <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2TypStrict)
  if (0 %in% c(margin.table(.the.table.strict, c(1)), margin.table(.the.table.strict, c(2)))) {
    .the.table.strict <- .the.table.strict + 1
    tests.per.lemma[i, "smooth.strict"] <- T
  }
  .the.test.strict  <- chisq.test(.the.table.strict, simulate.p.value = monte.carlo, B = num.reps)

  tests.per.lemma[i, "lemma"]          <- .n1
  tests.per.lemma[i, "link"]           <- .le
  tests.per.lemma[i, "n"]              <- ifelse(tests.per.lemma[i, "smooth.lax"], sum(.the.table.strict)-4, sum(.the.table.strict))
  tests.per.lemma[i, "p.raw.lax"]      <- as.numeric(.the.test.lax$p.value)
  tests.per.lemma[i, "p.raw.strict"]   <- as.numeric(.the.test.strict$p.value)
  tests.per.lemma[i, "phi.lax"]        <- sqrt(as.numeric(.the.test.lax$statistic)/sum(.the.table.lax)) * sign(.the.test.lax$residuals[1,1]) * -1
  tests.per.lemma[i, "phi.strict"]     <- sqrt(as.numeric(.the.test.strict$statistic)/sum(.the.table.strict)) * sign(.the.test.strict$residuals[1,1]) * -1
  tests.per.lemma[i, "p.sidak.lax"]    <- adjust.p.sidak(as.numeric(.the.test.lax$p.value), m)
  tests.per.lemma[i, "p.sidak.strict"] <- adjust.p.sidak(as.numeric(.the.test.strict$p.value), m)
  tests.per.lemma[i, "p.hoch.lax"]     <- p.adjust(as.numeric(.the.test.lax$p.value), method = "hoch", n = m)
  tests.per.lemma[i, "p.hoch.strict"]  <- p.adjust(as.numeric(.the.test.strict$p.value), method = "hoch", n = m)
}

t.plot        <- tests.per.lemma[order(tests.per.lemma$phi.strict, decreasing = F),]
t.plot$link   <- as.factor(t.plot$link)

# Get order of LE by their tendency to appear w/ plural LE.
le.means         <- aggregate(x = tests.per.lemma$phi.strict, by = list(tests.per.lemma$link), FUN = mean.harm)
le.group.order   <- order(le.means$x, decreasing = T)
le.group.ordered <- le.means$Group.1[le.group.order]
t.plot$link <- factor(t.plot$link, levels = le.group.ordered)

# Save for later use in paper.
save(list = c("num.reps", "t.plot", "le.means"), file = "RData/t.plot.RData", compress = "bzip2")

# Show how strong Sidak's correction kicks in!
if (plot.corr.effect) {
  if (save.persistently) pdf(paste0(plot.dir, "sidak.pdf"))
    options(scipen=999)
    plot(t.plot[order(t.plot$p.raw.strict), "p.sidak.strict"]~t.plot[order(t.plot$p.raw.strict), "p.raw.strict"],
        ylim = c(-0.05, 1.05),
         log = "x",
         pch = 20,
         cex = 3,
         lty = 1,
         col = "darkgreen",
         xlab = "Uncorrected p-values (log scale)",
         ylab = "p-values with Sidak's correction",
         main = paste0("The effect of Sidak's correction for group-wise error\n(",
                       nrow(t.plot), " single tests in group)")
         )
    points(t.plot[order(t.plot$p.raw.strict), "p.sidak.lax"]~t.plot[order(t.plot$p.raw.strict), "p.raw.lax"],
           pch = 22,
           cex = 3,
           col = "darkorange"
    )
    options(scipen=0)
  if (save.persistently) dev.off()
}



if (save.persistently) pdf(paste0(plot.dir, "phi.pdf"))

  # The dots are in fact invisible (pch="") so we can draw freely later.
  dotchart(t.plot$phi.strict,
           xlim=c(-0.2, +0.6),
           # labels = paste0(t.plot$lemma, "(p=", round(t.plot$p.sidak.strict, 3), ")"),
           labels = t.plot$lemma,
           pch = "",
           cex=0.75,
           cex.axis = 5,
           gcolor = "black",
           groups = t.plot$link,
           color = unlist(lapply(t.plot$p.sidak.strict, function(x) map.my.ramp(x, my.colors))),
           main = "Signed effect strength for the use of N1 with\npluralic linking element if N2 favours plural semantics on N1",
           xlab=paste0("Cramer's phi (signed) derived from bootstrapped Chi-square (", num.reps, " repititions)")
           ,sub = paste0("[Note: p-values for colour-coding were corrected for GWE (m=", nrow(t.plot) ,") using Sidak's method.]")
           )

  abline(v = seq(-0.2, 0.6, 0.2), col = "lightgray", lty = 1, lwd=1)

  # Now add first level to dotchart on top of verticl lines.
  # Unfortunately not supported by built-in function.
  this.y <- 1
  for (l in rev(levels(t.plot$link))) {

    .t.subplot <- t.plot[which(t.plot$link == l),]
    for (n1 in 1:nrow(.t.subplot)) {
      points(.t.subplot[n1, "phi.strict"], this.y,
             pch = 16,
             col = map.my.ramp(.t.subplot$p.sidak.strict[n1], my.colors)
      )
      this.y <- this.y + 1
    }
    this.y <- this.y + 2
  }

  # Now add second level to dotchart.
  # Unfortunately not supported by built-in function.
  this.y <- 1
  for (l in rev(levels(t.plot$link))) {

    .t.subplot <- t.plot[which(t.plot$link == l),]
    for (n1 in 1:nrow(.t.subplot)) {
      points(.t.subplot[n1, "phi.lax"], this.y,
             pch = 1,
             cex = 1.7,
             col = map.my.ramp(.t.subplot$p.sidak.lax[n1], my.colors)
      )
      this.y <- this.y + 1
    }
    this.y <- this.y + 2
  }
  legend("right", title = "p-values",
         legend = c("0", "0.05", "0.1", "0.5", "1"),
         col = c(my.colors[100], my.colors[65], my.colors[50], my.colors[16], my.colors[1]),
         pch=19, bg = "white",
         cex = 1.0
         )
  legend("bottomright",
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

if (save.persistently) sink(paste0(out.dir, "corpus_results.txt"))
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
print(lme4::VarCorr(le.glmm.vivs))
if (save.persistently) sink()

