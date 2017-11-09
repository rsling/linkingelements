require(readr)
require(lme4)
require(effects)
require(MuMIn)
require(pbkrtest)
require(beanplot)
require(gamlss)
require(plyr)
library(lattice)


### CLEANUP ###

rm(list = ls())
cat("\014")
# graphics.off()
set.seed(48267)


### OPTIONS ###

setwd("~/Workingcopies/Linkingelements/Split/Rlinkexp")
paper.title     <- "Inflection within compounds: on the plural-marking function of linking elements in German"
paper.authors   <- "Roland Schäfer & Elizabeth Pankratz"
save.persistent <- T
data.dir        <- '../data/'
out.dir         <- 'output/'


### INIT ###

if (save.persistent) sink(paste0(out.dir, "results.txt"), append = F)
cat('\n\nSTATISTICS OUTPUT FOR\n"', paper.title, '"\n', paper.authors,'\n\n', sep="")
if (save.persistent) sink()


### LOAD ###

data.files.names <- list.files(data.dir)
data.files.names <- data.files.names[grep('csv$', data.files.names)]
data.files <- paste(data.dir, data.files.names, sep="")

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

# Create collective subset df.
obs.coll <- obs[which(obs$subExp == "coll"),]
obs.coll$cond <- droplevels(obs.coll$cond)

# Create plural subset df.
obs.pl <- obs[which(obs$subExp == "pl"),]
obs.pl$cond <- droplevels(obs.pl$cond)



### DESCRIPTIVE PLOTS ###

if (save.persistent) pdf(paste0(out.dir, "descriptive_by_condition.pdf"))
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
if (save.persistent) dev.off()

if (save.persistent) pdf(paste0(out.dir, "descriptive_by_participant.pdf"))
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
if (save.persistent) dev.off()

par(mfrow=c(1,1))

if (save.persistent) pdf(paste0(out.dir, "descriptive_distribution.pdf"))
plot(density(obs.pl$realRating),
     col = "darkgreen", lwd = 3, lty = 3, bty = "n",
     ylim = c(0, 0.02), xlim = c(0,100),
     main = "Distribution of split-100 ratings")
lines(density(obs.coll$realRating),
      col = "darkorange", lwd = 3, lty = 1)
legend("topright", legend = c("Collective N2", "Plural N2"),
       lwd = 3, col = c("darkorange", "darkgreen"), lty = c(1, 2))
if (save.persistent) dev.off()



### BETA GAMMs ###

# Collective GAMM.
model.coll <- gamlss(realRatingProp ~ cond + prodQuotN1 + random(participant), data = obs.coll, family=BEINF)

if (save.persistent) sink(paste0(out.dir, "results.txt"), append = T)
cat("********************\n")
cat("* COLLECTIVE MODEL *\n")
cat("********************\n\n")
print(summary(model.coll))
if (save.persistent) sink()

if (save.persistent) pdf(paste0(out.dir, "coll_model_diag.pdf"))
plot(model.coll)
if (save.persistent) dev.off()


# Plural GAMM.
model.pl <- gamlss(realRatingProp ~ cond + prodQuotN1 + random(participant), data = obs.pl, family=BEINF)

if (save.persistent) sink(paste0(out.dir, "results.txt"), append = T)
cat("\n\n\n****************\n")
cat("* PLURAL MODEL *\n")
cat("****************\n\n")
print(summary(model.pl))
if (save.persistent) sink()

if (save.persistent) pdf(paste0(out.dir, "pl_model_diag.pdf"))
plot(model.pl)
if (save.persistent) dev.off()


