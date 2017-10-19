
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


# Function to calculate productivity measures. See Baayen (2009[HSK]).
productivity <- function(fhapax, ftoken, LE, N1, HX.TOTAL = 28366825) {  # HX.TOTAL is for DECOW16AX, cleansed.
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

make.full.analysis <-  function(le, prods) {
  .n1s <- merge(prods[[le]], prods$no, by = 'N1', all.x = T)
  colnames(.n1s) <- c('N1',
                      paste('With', colnames(prods[[le]]), sep = '_')[-1],
                      paste('Without', colnames(prods[[le]]), sep = '_')[-1]
  )
  # Especially hapax counts may be 0, leading to NAs after merge. Make 0.
  .n1s[is.na(.n1s)] <- 0
  .n1s
}


map.log <-  function(x, x.max, to.max = 2) {
  log(x)/log(x.max)*(to.max)
}



plot.productivities <- function(le, analyses, dots = F, max.plottable = 100, norm.xax = NULL, norm.yax = NULL, zero.floor = NULL) {
  .n1s <- analyses[[le]]

  # Remove/deal with elements with 0 productivity.
  if (is.null(zero.floor) | !is.numeric(zero.floor)) {
    .n1s <- .n1s[-c(which(.n1s$With_Ppot == 0 | .n1s$Without_Ppot == 0)), ]
  } else {
    .n1s[which(.n1s$With_Ppot == 0), 'With_Ppot'] <- zero.floor
    .n1s[which(.n1s$Without_Ppot == 0), 'Without_Ppot'] <- zero.floor
  }

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
       ylab = "P(N1) without linking element",
       xlab = paste0("P(N1) with ", .le.name, " linking element"),
       log = "xy"
  )
  for (n in 1:nrow(.n1s)) {
    if (dots) {
      points(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
             pch = 20,
             cex = map.log(.n1s[n,"With_Ftype"], .fty.max.with, 4),
             col = my.colors[round(map.log(.n1s[n,"Without_Ftype"], .fty.max.without, 100), 0)]
      )
      legend("topleft",
             legend = c(paste0("f = 1; 1"),
                        paste0("f = ", .fty.max.with, "; 1"),
                        paste0("f = 1; ", .fty.max.without),
                        paste0("f = ", .fty.max.with, "; ", .fty.max.without)
                        ),
             pch = 20,
             col = c(
                 my.colors[round(map.log(2, .fty.max.without, 100), 0)],
                 my.colors[round(map.log(2, .fty.max.without, 100), 0)],
                 my.colors[round(map.log(.fty.max.without, .fty.max.without, 100), 0)],
                 my.colors[round(map.log(.fty.max.without, .fty.max.without, 100), 0)]
               ),
             pt.cex = c(
                 0.2,
                 map.log(.fty.max.with, .fty.max.with, 4),
                 0.2,
                 map.log(.fty.max.with, .fty.max.with, 4)
               ),
             cex = 0.8,
             bty = "n"
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
