rm(list = ls())

script.path <- '~/Workingcopies/Linkingelements/Data/R'
data.path   <- paste0(script.path, '/../Database/')

lwd <- 3
lty <- 1:10
col <- 1:10

my.colors = colorRampPalette(c("yellow", "black"))(100)

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


map.log <-  function(x, x.max, to.max = 2) {
  log(x)/log(x.max)*(to.max)
}


# Get N1s used with and without LE.

analyses.full <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)

max.plottable <- 200

#for (le in c('e', 'Ue', 'er', 'Uer', 'n', 'en')) {
for (le in c('Ue')) {
  .n1s <- merge(productivities[[le]], productivities$no, by = 'N1')
  colnames(.n1s) <- c('N1',
                      paste('With', colnames(productivities$er), sep = '_')[-1],
                      paste('Without', colnames(productivities$er), sep = '_')[-1]
                      )

  # Add to persistent list.
  analyses.full[[le]] <- .n1s

  # Reduce number of plottables if too many.
  if (nrow(.n1s) > max.plottable) {
    .n1s <- .n1s[sample(1:nrow(.n1s), max.plottable, replace = F),]
    .reduced <- T
  } else .reduced <- F

  # For font size, get maximum token frequency and mapping freq -> font size.
  .fto.max          <- max(.n1s$With_Ftoken)
  .fty.max          <- max(.n1s$With_Ftype)
  .prod.with.max    <- max(.n1s$With_Ppot)
  .prod.with.min    <- min(.n1s$With_Ppot)
  .prod.without.max <- max(.n1s$Without_Ppot)
  .prod.without.min <- min(.n1s$Without_Ppot)

  #par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
  plot(.n1s[,"With_Ppot"]~.n1s[,"Without_Ppot"], type="n",
       main = paste0("Productivity (pot.) of N1 with -", le, " and -0"),
       xlim = c(.prod.with.min*0.9, .prod.with.max*1.1),
       ylim = c(.prod.without.min*0.9, .prod.without.max*1.1),
       ylab = "P[pot](N1+0) (log axis)",
       xlab = paste0("P[pot](N1+", le, ") (log axis)"),
       log = "xy"
       )
  for (n in 1:nrow(.n1s)) {
    text(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
         cex = map.log(.n1s[n,"With_Ftoken"], .fto.max),
         labels = .n1s[n, "N1"],
         col = my.colors[round(map.log(.n1s[n,"With_Ftype"], .fty.max, 100), 0)],
         srt = sample(-90:90, 1)
         )
  }
}
