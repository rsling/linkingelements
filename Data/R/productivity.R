rm(list = ls())

data.path   <- '../Database/'

lwd <- 3
lty <- 1:10
col <- 1:10

my.colors = colorRampPalette(c("yellow", "darkred"))(100)

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


make.full.analysis <-  function(le, prods) {
    .n1s <- merge(prods[[le]], prods$no, by = 'N1')
    colnames(.n1s) <- c('N1',
                        paste('With', colnames(prods[[le]]), sep = '_')[-1],
                        paste('Without', colnames(prods[[le]]), sep = '_')[-1]
                        )
    .n1s
}

plot.productivities <- function(le, analyses, dots = F, max.plottable = 100, norm.xax = NULL, norm.yax = NULL) {

  .n1s <- analyses[[le]]

  # Reduce number of plottables if too many.
  if (max.plottable > 0 & nrow(.n1s) > max.plottable) {
    .subtitle <- paste0("\n(", nrow(.n1s) - max.plottable, " of ", nrow(.n1s), " not shown)")
    .n1s <- .n1s[sample(1:nrow(.n1s), max.plottable, replace = F),]
  } else {
    .subtitle <- ''
  }

  # For font size, get maximum token frequency and mapping freq -> font size.
  .fty.max.with     <- max(.n1s$With_Ftype)
  .fty.max.without  <- max(.n1s$Without_Ftype)
  .prod.with.max    <- max(.n1s$With_Ppot)
  .prod.with.min    <- min(.n1s$With_Ppot)
  .prod.without.max <- max(.n1s$Without_Ppot)
  .prod.without.min <- min(.n1s$Without_Ppot)

  if (!is.null(norm.xax)) {
    .xlim <- norm.xax
  } else {
    .xlim <- c(.prod.with.min*0.75, .prod.with.max*1.25)
  }
  if (!is.null(norm.yax)) {
    .ylim <- norm.yax
  } else {
    .ylim <- c(.prod.without.min*0.75, .prod.without.max*1.25)
  }

  .le.name <- ifelse(startsWith(le, 'U'), paste0('=', substr(le, 2, nchar(le))), paste0('-', le))

  plot(.n1s[,"With_Ppot"]~.n1s[,"Without_Ppot"], type="n",
       main = paste0("Productivity of N1 with ", .le.name, .subtitle),
       xlim = .xlim,
       ylim = .ylim,
       ylab = "without linking element",
       xlab = paste0("with ", .le.name, " linking element"),
       log = "xy"
       )
  for (n in 1:nrow(.n1s)) {
    if (dots) {
      points(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
             pch = 20,
             cex = map.log(.n1s[n,"With_Ftype"], .fty.max.with, 4),
             col = my.colors[round(map.log(.n1s[n,"Without_Ftype"], .fty.max.without, 100), 0)]
            )
     legend("topleft", legend = c(paste0("fty=1;1"), paste0("fty=", .fty.max.with, ";", .fty.max.without)),
            pch = 20,
            col = c(my.colors[round(map.log(2, .fty.max.without, 100), 0)],
                    my.colors[round(map.log(.fty.max.without, .fty.max.without, 100), 0)]),
            pt.cex = c(1, map.log(.fty.max.with, .fty.max.with, 4)),
            cex = 0.8
            )
    } else {
      text(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
           cex = map.log(.n1s[n,"With_Ftype"], .fty.max.with),
           labels = .n1s[n, "N1"],
           col = my.colors[round(map.log(.n1s[n,"Without_Ftype"], .fty.max.without, 100), 0)],
           srt = sample(-90:90, 1)
           )
    }
  }
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

# For debugging and after RStudio crashes.
# load("analyses.full.RData")

# Plot everything.
options(scipen=999)
plot.productivities('e', analyses.full)
plot.productivities('Ue', analyses.full)
plot.productivities('er', analyses.full)
plot.productivities('Uer', analyses.full)
plot.productivities('n', analyses.full)
plot.productivities('en', analyses.full)
options(scipen=0)

options(scipen=999)
pdf("productivity.pdf")
par(mfrow=c(2,3))
plot.productivities('e', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
plot.productivities('Ue', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
plot.productivities('er', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
plot.productivities('Uer', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
plot.productivities('n', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
plot.productivities('en', analyses.full, dots = T, max.plottable = -1, norm.xax = c(0.0001,1), norm.yax = c(0.000001,1))
par(mfrow=c(1,1))
dev.off()
options(scipen=0)
