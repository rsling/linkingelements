rm(list = ls())
data.path   <- '../Database/'
source('functions.R')
source('load.R')


# Clean the basic lists (pre-loaded data).
nouns <- clean.dfs.by.blacklist(nouns, blacklists, "N1")
ftype <- clean.dfs.by.blacklist(ftype, blacklists, "N1")
ftoken <- clean.dfs.by.blacklist(ftoken, blacklists, "N1")
fhapax <- clean.dfs.by.blacklist(fhapax, blacklists, "N1")
compounds <- clean.dfs.by.blacklist(compounds, blacklists, "N1")


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


# Make complete data frames.

analyses.full <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)

for (le in c('e', 'Ue', 'er', 'Uer', 'n', 'en')) {
  analyses.full[[le]] <- make.full.analysis(le, productivities)
}

save(list = "analyses.full", file = "analyses.full.RData")


