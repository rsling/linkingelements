rm(list = ls())
set.seed(183)
source('functions.R')

load("RData/n1.frequencies.RData")
load("RData/nouns.RData")

productivities <- list(
  no  = NULL, e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, s   = NULL, Ue  = NULL, Uer = NULL,
  U = NULL
  )

for (le in names(productivities)) {
  .locprod <- lapply(as.character(ftype[[le]]$N1), function(noun) {productivity(fhapax, ftoken, le, noun)})
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

dir.create('./RData', showWarnings = F)
save(list = "productivities", file = "RData/productivities.RData", compress = "bzip2")

# Make complete data frames.
analyses.full <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL,
  U   = NULL
)

for (le in c('e', 'Ue', 'er', 'Uer', 'n', 'en', 'U')) {
  analyses.full[[le]] <- make.full.analysis(le, productivities)
}

save(list = "analyses.full", file = "RData/analyses.full.RData", compress = "bzip2")


