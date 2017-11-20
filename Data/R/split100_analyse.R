require(readr)
require(lme4)
require(effects)
require(MuMIn)
require(pbkrtest)
require(beanplot)
require(gamlss)
require(plyr)
library(lattice)
require(ordinal)

rm(list = ls())
set.seed(48267)

save.persistently <- F
data.dir          <- '../Split100/data/'
out.dir           <- 'Results/'
graphics.dir      <- 'Plots/'

load("RData/analyses.full.RData")
analyses.full <- rbind(analyses.full[["e"]],
      analyses.full[["en"]],
      analyses.full[["er"]],
      analyses.full[["n"]],
      analyses.full[["Ue"]],
      analyses.full[["Uer"]],
      analyses.full[["U"]]
      )

data.files.names <- list.files(data.dir)
data.files.names <- data.files.names[grep('csv$', data.files.names)]
data.files <- paste0(data.dir, data.files.names)

# Read single PsychoPy CSVs and build large data frame.
obs <- NULL
for (dafi in data.files) {

  cat(dafi, "\n")

  # Read and clean up.
  suppressWarnings(suppressMessages(tmp <- read_csv(dafi)))
  tmp <- tmp[-which(!(tmp$subExp %in% c("pl", "coll"))),]
  tmp <- tmp[, -c(15:46,49:54,56)]
  tmp$realRating <- ifelse(tmp$swapped, 100-tmp$rating.response, tmp$rating.response)

  if (is.null(obs)) {
    obs <- tmp
  } else {
    obs <- rbind(obs, tmp)
  }
}

# Fix column types.
obs$cond <- as.factor(obs$cond)
obs$participant <- as.factor(obs$participant)

# Fix factor levels for pretty-printing.
obs$cond <- mapvalues(obs$cond, from = c('coll', 'indiv', 'pl', 'sg'), to = c('Collective', 'Individual', 'Plural', 'Singular'))

# Map ratings to (0,1) for beta regression.
obs$realRatingProp <- obs$realRating/100

# Get five point rating.
obs$Ratings5p <- factor(cut(obs$realRating, seq(0,100,20), labels = 1:5, include.lowest = T), ordered = T)

# Add N1 statistics.
obs <- merge(obs, analyses.full, by.x = "n1", by.y = "N1", all.x = T)

# Create collective subset df.
obs.coll <- obs[which(obs$subExp == "coll"),]
obs.coll$cond <- droplevels(obs.coll$cond)

# Create plural subset df.
obs.pl <- obs[which(obs$subExp == "pl"),]
obs.pl$cond <- droplevels(obs.pl$cond)

save(list = c("obs", "obs.coll", "obs.pl"), file = "RData/observations.RData", compress = "bzip2")


### DESCRIPTIVE PLOTS ###

if (save.persistently) pdf(paste0(out.dir, "descriptive_by_condition.pdf"))
par(mfrow=c(1,2))
plot(obs.coll$realRating~obs.coll$cond,
     col = "gold",
     main = "Collective N2: distribution\nof responses by condition",
     xlab = "Condition", ylab = "Split-100 responses",
     frame = F)
plot(obs.pl$realRating~obs.pl$cond,
     col = "gold",
     main = "Plural N2: distribution\nof responses by condition",
     xlab = "Condition", ylab = "Split-100 responses",
     frame = F)
if (save.persistently) dev.off()

if (save.persistently) pdf(paste0(out.dir, "descriptive_by_participant.pdf"))
par(mfrow=c(2,1))
plot(obs.coll$realRating~obs.coll$participant,
     las = 2, col = "gold",
     main = "Collective N2: distribution of responses by participant",
     xlab = "Participant ID", ylab = "Split-100 responses",
     frame = F)
plot(obs.pl$realRating~obs.pl$participant,
     las = 2, col = "gold",
     main = "Plural N2: distribution of responses by participant",
     xlab = "Participant ID", ylab = "Split-100 responses",
     frame = F)
if (save.persistently) dev.off()

par(mfrow=c(1,1))
if (save.persistently) pdf(paste0(out.dir, "descriptive_distribution.pdf"))
plot(density(obs.pl$realRating),
     col = "darkgreen", lwd = 3, lty = 3, bty = "n",
     ylim = c(0, 0.02), xlim = c(0,100),
     main = "Distribution of split-100 ratings")
lines(density(obs.coll$realRating),
      col = "darkorange", lwd = 3, lty = 1)
legend("topright", legend = c("Collective N2", "Plural N2"),
       lwd = 3, col = c("darkorange", "darkgreen"), lty = c(1, 2))
if (save.persistently) dev.off()



### BETA GAMMs ###

# Collective GAMM.
# model.coll <- gamlss(realRatingProp ~ cond + scale(With_Ppot) * scale(Without_Ppot) + random(as.factor(n1)) + random(participant), data = obs.coll, family=BEINF)
model.coll <- gamlss(realRatingProp ~ cond + random(participant), data = obs.coll, family=BEINF)
model.coll.0 <- gamlss(realRatingProp ~ random(participant), data = obs.coll, family=BEINF)

if (save.persistently) sink(paste0(out.dir, "results.txt"), append = T)
cat("\n\n\n COLLECTIVE MODEL \n\n")
print(summary(model.coll))
print(summary(model.coll.0))
if (save.persistently) sink()

if (save.persistently) pdf(paste0(out.dir, "coll_model_diag.pdf"))
plot(model.coll)
if (save.persistently) dev.off()


# Plural GAMM.
model.pl <- gamlss(realRatingProp ~ cond + random(participant), data = obs.pl, family=BEINF)
model.pl.0 <- gamlss(realRatingProp ~ random(participant), data = obs.pl, family=BEINF)

if (save.persistently) sink(paste0(out.dir, "results.txt"), append = T)
cat("\n\n\n PLURAL MODEL \n\n")
print(summary(model.pl))
print(summary(model.pl.0))
if (save.persistently) sink()

if (save.persistently) pdf(paste0(out.dir, "pl_model_diag.pdf"))
plot(model.pl)
if (save.persistently) dev.off()

### ORDINAL MODEL ###

# Coll

model.coll.clmm  <- clmm(Ratings5p ~ cond + (1 | participant), data = obs.coll, link="logit",
                        Hess = TRUE, method="ucminf", threshold = "equidistant")
model.coll.clmm.0 <- clmm(Ratings5p ~ 1 + (1 | participant), data = obs.coll, link="logit",
                        Hess = TRUE, method="ucminf", threshold = "equidistant")

if (save.persistently) sink(paste0(out.dir, "results.txt"), append = T)
  cat("\n\n### ORDINAL MODEL: COLL ###\n")
  print(summary(model.coll.clmm))
  cat("\n\n Comparing model w/ and w/o main factor.\n")
  print(anova(model.coll.clmm, model.coll.clmm.0))
if (save.persistently) dev.off()

if (save.persistently) pdf(paste0(out.dir, "5point.coll.pdf"))
  plot(obs.coll$Ratings5p ~ obs.coll$cond,
       main = "Distribution of linearly discretised Responses\nfor collective/non-collective conditions",
       ylab = "Rating",
       xlab = "Condition"
       )
if (save.persistently) dev.off()

# Pl

model.pl.clmm  <- clmm(Ratings5p ~ cond + (1 | participant), data = obs.pl, link="logit",
                         Hess = TRUE, method="ucminf", threshold = "equidistant")
model.pl.clmm.0 <- clmm(Ratings5p ~ 1 + (1 | participant), data = obs.pl, link="logit",
                          Hess = TRUE, method="ucminf", threshold = "equidistant")

if (save.persistently) sink(paste0(out.dir, "results.txt"), append = T)
  cat("\n\n### ORDINAL MODEL ###\n")
  print(summary(model.pl.clmm))
  cat("\n\n Comparing model w/ and w/o main factor.\n")
  print(anova(model.pl.clmm, model.pl.clmm.0))
if (save.persistently) dev.off()

if (save.persistently) pdf(paste0(out.dir, "5point.pl.pdf"))
  plot(obs.pl$Ratings5p ~ obs.pl$cond,
       main = "Distribution of linearly discretised Responses\nfor plural/singular conditions",
       ylab = "Rating",
       xlab = "Condition"
       )
if (save.persistently) dev.off()
