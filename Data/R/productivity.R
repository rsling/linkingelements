rm(list = ls())

script.path <- '~/Workingcopies/Linkingelements/Data/R'
data.path   <- paste0(script.path, '/../Database/')

lwd <- 3
lty <- 1:10
col <- 1:10

setwd(script.path)

source('load.R')

# Helper functions.
get.list.elem <- function(l, n){
  sapply(l, `[`, n)
}


# Function to get rid of blacklisted N1s in single df.
clean.df.by.blacklist <- function(df, blacklist, column) {
  .blacked <- which(df[,column] %in% blacklist[,column])
  .blacked <- .blacked[which(!is.na(.blacked))]
  if (length(.blacked) > 0) {
    df[-c(.blacked),]
  } else {
    df
  }
}


# Function to clean several dfs in a list by blacklist.
clean.dfs.by.blacklist <- function(lst, blacklst, column) {
  .res = list()
  for (dfn in names(lst)) {
    .r <- clean.df.by.blacklist(lst[[dfn]], blacklst[[dfn]], column)
    .res[[dfn]] <- .r
  }
  .res
}


# Clean the basic lists (pre-loaded data).
nouns <- clean.dfs.by.blacklist(nouns, blacklists, "N1")
ftype <- clean.dfs.by.blacklist(ftype, blacklists, "N1")
ftoken <- clean.dfs.by.blacklist(ftoken, blacklists, "N1")
fhapax <- clean.dfs.by.blacklist(fhapax, blacklists, "N1")
compounds <- clean.dfs.by.blacklist(compounds, blacklists, "N1")


# Function to calculate productivity measures. See Baayen (2009[HSK]).
productivity <- function(fhapax, ftoken, LE, N1, HX.TOTAL = 95*10^6) {
  .fto <- ftoken[[LE]][which(ftoken[[LE]]['N1'] == N1),'F']
  .fhx <- fhapax[[LE]][which(fhapax[[LE]]['N1'] == N1),'F']
  .fhx.total <- sum(as.numeric(fhapax[[LE]][, 'F']))
  .fhx.supertotal <- sum(unname(unlist(lapply(fhapax, function(df) sum(as.numeric(df[, 'F']))))))
  .p.potential <- as.numeric(.fhx)/as.numeric(.fto)
  .p.expanding <- as.numeric(.fhx)/as.numeric(.fhx.total)
  .p.expanding.super <- as.numeric(.fhx)/as.numeric(.fhx.supertotal)
  .p.expanding.corpus <- as.numeric(.fhx)/as.numeric(HX.TOTAL)
  list(N1                       = N1,
       prod.potential           = .p.potential,
       prod.expanding.le        = .p.expanding,
       prod.expanding.compounds = .p.expanding.super,
       prod.expanding.corpus    = .p.expanding.corpus
       )
}


productivities <- list(
  no  = NULL, e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, s   = NULL, Ue  = NULL, Uer = NULL
  )

for (le in names(productivities)) {
  .locprod <- lapply(as.character(fhapax[[le]]$N1), function(noun) {productivity(fhapax, ftoken, le, noun)})
  .locprod <- data.frame(
    N1           = as.character(get.list.elem(.locprod, 1)),
    Ppot         = as.numeric(get.list.elem(.locprod, 2)),
    PexpLE       = as.numeric(get.list.elem(.locprod, 3)),
    PexpCompound = as.numeric(get.list.elem(.locprod, 4)),
    PexpCorpus   = as.numeric(get.list.elem(.locprod, 5))
  )
  .locprod <- merge(.locprod, ftype[[le]], by = "N1", all.x = T)
  .locprod <- merge(.locprod, ftoken[[le]], by = "N1", all.x = T)
  .locprod <- merge(.locprod, fhapax[[le]], by = "N1", all.x = T)
  colnames(.locprod)[6:8] <- c('Ftype', 'Ftoken', 'Fhapax')
  .locprod <- .locprod[order(.locprod$Ppot, decreasing = T),]
  productivities[[le]] <- .locprod
}


# prod.er <- lapply(as.character(fhapax$er$N1), function(noun) {productivity(fhapax, ftoken, 'er', noun)})
# prod.er <- data.frame(
#   N1           = as.character(get.list.elem(prod.er, 1)),
#   Ppot         = as.numeric(get.list.elem(prod.er, 2)),
#   PexpLE       = as.numeric(get.list.elem(prod.er, 3)),
#   PexpCompound = as.numeric(get.list.elem(prod.er, 4)),
#   PexpCorpus   = as.numeric(get.list.elem(prod.er, 5))
# )
# prod.er <- merge(prod.er, ftype$er, by = "N1", all.x = T)
# prod.er <- merge(prod.er, ftoken$er, by = "N1", all.x = T)
# prod.er <- merge(prod.er, fhapax$er, by = "N1", all.x = T)
# colnames(prod.er)[6:8] <- c('Ftype', 'Ftoken', 'Fhapax')
# prod.er <- prod.er[order(prod.er$Ppot, decreasing = T),]





#
# plot(ftoken[['no']]$F~ftype[['no']]$F, type="p", lwd = lwd, lty = lty[1], col = col[1],
#      ylim = c(1, 3400000),
#      main = "Type & token frequency of N1",
#      xlab = "type frequency",
#      ylab = "token frequency")
# points(ftoken[['s']]$F~ftype[['s']]$F, type="p", lwd = lwd, lty = lty[2], col = col[2])
# points(ftoken[['e']]$F~ftype[['e']]$F, type="p", lwd = lwd, lty = lty[3], col = col[3])
# points(ftoken[['en']]$F~ftype[['en']]$F, type="p", lwd = lwd, lty = lty[4], col = col[4])
# points(ftoken[['er']]$F~ftype[['er']]$F, type="p", lwd = lwd, lty = lty[5], col = col[5])
# points(ftoken[['n']]$F~ftype[['n']]$F, type="p", lwd = lwd, lty = lty[6], col = col[6])
# points(ftoken[['Ue']]$F~ftype[['Ue']]$F, type="p", lwd = lwd, lty = lty[7], col = col[7])
# points(ftoken[['Uer']]$F~ftype[['Uer']]$F, type="p", lwd = lwd, lty = lty[8], col = col[8])
# legend('topleft', lwd = lwd, col = col, lty = lty,
#         legend = c("0", "-s", "-e", "-en", "-er", "-n", "=e", "=er"))

