rm(list = ls())

script.path <- '~/Workingcopies/Linkingelements/Data/R'
data.path   <- paste0(script.path, '/../Database/')

lwd = 3
lty = 1:10
col = 1:10

setwd(script.path)

source('load.R')


# Get rid of blacklisted N1s.
clean.df.by.blacklist <- function(df, blacklist, column) {
  .blacked <- match(df[,column], blacklist[,column])
  .blacked <- .blacked[which(!is.na(.blacked))]
  if (length(.blacked) > 0) {
    df[-c(.blacked),]
  } else {
    df
  }
}

clean.dfs.by.blacklist <- function(lst, blacklst, column) {
  .res = list()
  for (dfn in names(lst)) {
    .r <- clean.df.by.blacklist(lst[[dfn]], blacklst[[dfn]], column)
    .res[[dfn]] <- .r
  }
  .res
}

nouns <- clean.dfs.by.blacklist(nouns, blacklists, "N1")
ftype <- clean.dfs.by.blacklist(ftype, blacklists, "N1")
ftoken <- clean.dfs.by.blacklist(ftoken, blacklists, "N1")
fhapax <- clean.dfs.by.blacklist(fhapax, blacklists, "N1")
compounds <- clean.dfs.by.blacklist(compounds, blacklists, "N1")

plot(ftoken[['no']]$F~ftype[['no']]$F, type="l", lwd = lwd, lty = lty[1], col = col[1],
     ylim = c(1, 3400000),
     main = "Type & token frequency of N1",
     xlab = "type frequency",
     ylab = "token frequency")
lines(ftoken[['s']]$F~ftype[['s']]$F, type="l", lwd = lwd, lty = lty[2], col = col[2])
lines(ftoken[['e']]$F~ftype[['e']]$F, type="l", lwd = lwd, lty = lty[3], col = col[3])
lines(ftoken[['en']]$F~ftype[['en']]$F, type="l", lwd = lwd, lty = lty[4], col = col[4])
lines(ftoken[['er']]$F~ftype[['er']]$F, type="l", lwd = lwd, lty = lty[5], col = col[5])
lines(ftoken[['n']]$F~ftype[['n']]$F, type="l", lwd = lwd, lty = lty[6], col = col[6])
lines(ftoken[['Ue']]$F~ftype[['Ue']]$F, type="l", lwd = lwd, lty = lty[7], col = col[7])
lines(ftoken[['Uer']]$F~ftype[['Uer']]$F, type="l", lwd = lwd, lty = lty[8], col = col[8])
legend('topleft', lwd = lwd, col = col, lty = lty,
        legend = c("0", "-s", "-e", "-en", "-er", "-n", "=e", "=er"))


plot(ftoken[['no']]$F~ftype[['no']]$F, type="l", lwd = lwd, lty = lty[1], col = col[1],
     ylim = c(1, 100), xlim = c(1,30),
     main = "Type & token frequency of N1 (Closeup)",
     xlab = "type frequency",
     ylab = "token frequency")
lines(ftoken[['s']]$F~ftype[['s']]$F, type="l", lwd = lwd, lty = lty[2], col = col[2])
lines(ftoken[['e']]$F~ftype[['e']]$F, type="l", lwd = lwd, lty = lty[3], col = col[3])
lines(ftoken[['en']]$F~ftype[['en']]$F, type="l", lwd = lwd, lty = lty[4], col = col[4])
lines(ftoken[['er']]$F~ftype[['er']]$F, type="l", lwd = lwd, lty = lty[5], col = col[5])
lines(ftoken[['n']]$F~ftype[['n']]$F, type="l", lwd = lwd, lty = lty[6], col = col[6])
lines(ftoken[['Ue']]$F~ftype[['Ue']]$F, type="l", lwd = lwd, lty = lty[7], col = col[7])
lines(ftoken[['Uer']]$F~ftype[['Uer']]$F, type="l", lwd = lwd, lty = lty[8], col = col[8])
legend('topleft', lwd = lwd, col = col, lty = lty,
        legend = c("0", "-s", "-e", "-en", "-er", "-n", "=e", "=er"))
