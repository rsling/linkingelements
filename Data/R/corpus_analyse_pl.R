rm(list = ls())
set.seed(109)

source('functions.R')

in.file           <- '../Corpusstudy/Concordance.full.csv'
plot.dir          <- './Plots/'
out.dir           <- './Results/'
save.persistently <- T
alpha.nominal     <- 0.05
monte.carlo       <- F
num.reps          <- 10000
plot.corr.effect  <- F
my.colors         <- colorRampPalette(c("orange", "darkgreen"))(100)

### DO NOT MODIFY ANYTHING PAST THIS LINE ###

conc = read.csv2(in.file, header = T, sep = "\t", quote = "")

m           <- length(levels(conc$N1Lemma))
alpha.sidak <- 1-(1-alpha.nominal)^(1/m)
cl.sidak    <- (1-alpha.nominal)^(1/m)

tests.per.lemma <- data.frame(
  lemma          = rep(NA, m),
  link           = rep(NA, m),
  n              = rep(0, m),
  p.raw          = rep(1, m),
  phi            = rep(0, m),
  p.sidak        = rep(1, m),
  p.hoch         = rep(1, m)
)

for (i in 1:m) {
  .n1 <- levels(conc$N1Lemma)[i]
  .le <- le.name(as.character(conc[head(which(conc$N1Lemma == levels(conc$N1Lemma)[i]), n = 1), "N1Pl"]))

  # In ONE case ("Sonne"), we have a zero marginal and need to smooth.
  .the.table <- table(conc[which(conc$N1Lemma == .n1),]$LE, conc[which(conc$N1Lemma == .n1),]$N2Num)
  .the.test  <- chisq.test(.the.table, simulate.p.value = monte.carlo, B = num.reps)

  tests.per.lemma[i, "lemma"]          <- .n1
  tests.per.lemma[i, "link"]           <- .le
  tests.per.lemma[i, "p.raw"]          <- as.numeric(.the.test$p.value)
  tests.per.lemma[i, "phi"]            <- sqrt(as.numeric(.the.test$statistic)/sum(.the.table)) * sign(.the.test$residuals[1,1]) * -1
  tests.per.lemma[i, "p.sidak"]        <- adjust.p.sidak(as.numeric(.the.test$p.value), m)
  tests.per.lemma[i, "p.hoch"]         <- p.adjust(as.numeric(.the.test$p.value), method = "hoch", n = m)
}

p.plot        <- tests.per.lemma[order(tests.per.lemma$phi, decreasing = F),]
p.plot$link   <- as.factor(p.plot$link)

# Get order of LE by their tendency to appear w/ plural LE.
le.means         <- aggregate(x = tests.per.lemma$phi, by = list(tests.per.lemma$link), FUN = mean.harm)
le.group.order   <- order(le.means$x, decreasing = T)
le.group.ordered <- le.means$Group.1[le.group.order]
p.plot$link <- factor(p.plot$link, levels = le.group.ordered)

# Save for later use in paper.
save(list = c("num.reps", "p.plot", "le.means"), file = "RData/p.plot.RData", compress = "bzip2")

# Show how strong Sidak's correction kicks in!
if (plot.corr.effect) {
  if (save.persistently) pdf(paste0(plot.dir, "pl.sidak.pdf"))
  options(scipen=999)
  plot(p.plot[order(p.plot$p.raw), "p.sidak"]~p.plot[order(p.plot$p.raw), "p.raw"],
       ylim = c(-0.05, 1.05),
       log = "x",
       pch = 20,
       cex = 3,
       lty = 1,
       col = "darkgreen",
       xlab = "Uncorrected p-values (log scale)",
       ylab = "p-values with Sidak's correction",
       main = paste0("The effect of Sidak's correction for group-wise error\n(",
                     nrow(p.plot), " single tests in group)")
  )
  points(p.plot[order(p.plot$p.raw), "p.sidak.lax"]~p.plot[order(p.plot$p.raw), "p.raw.lax"],
         pch = 22,
         cex = 3,
         col = "darkorange"
  )
  options(scipen=0)
  if (save.persistently) dev.off()
}

if (save.persistently) pdf(paste0(plot.dir, "pl.phi.pdf"))

# The dots are in fact invisible (pch="") so we can draw freely later.
dotchart(p.plot$phi,
         xlim=c(-0.3, +0.3),
         # labels = paste0(p.plot$lemma, "(p=", round(p.plot$p.sidak, 3), ")"),
         labels = p.plot$lemma,
         pch = "",
         cex=0.75,
         cex.axis = 5,
         gcolor = "black",
         groups = p.plot$link,
         color = unlist(lapply(p.plot$p.sidak, function(x) map.my.ramp(x, my.colors))),
         main = "Signed effect strength for the use of N1 with\npluralic linking element if N2 is a plural noun",
         xlab=paste0("Cramer's phi (signed) derived from bootstrapped Chi-square (", num.reps, " repititions)")
         ,sub = paste0("[Note: p-values for colour-coding were corrected for GWE (m=", nrow(p.plot) ,") using Sidak's method.]")
)

abline(v = seq(-0.2, 0.6, 0.2), col = "lightgray", lty = 1, lwd=1)

# Now add first level to dotchart on top of verticl lines.
# Unfortunately not supported by built-in function.
this.y <- 1
for (l in rev(levels(p.plot$link))) {

  .t.subplot <- p.plot[which(p.plot$link == l),]
  for (n1 in 1:nrow(.t.subplot)) {
    points(.t.subplot[n1, "phi"], this.y,
           pch = 16,
           col = map.my.ramp(.t.subplot$p.sidak[n1], my.colors)
    )
    this.y <- this.y + 1
  }
  this.y <- this.y + 2
}

legend("bottomright", title = "p-values",
       legend = c("0", "0.05", "0.1", "0.5", "1"),
       col = c(my.colors[100], my.colors[65], my.colors[50], my.colors[16], my.colors[1]),
       pch=19, bg = "white",
       cex = 1.0
)
if (save.persistently) dev.off()
