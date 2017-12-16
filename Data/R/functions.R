
# Format numbers for use in running text.
nice.float <- function(x, d = 3) formatC(x, format="f", big.mark=",", digits = d)
nice.int <- function(n) formatC(n, format="d", big.mark=",")

# Helper functions.
get.list.elem <- function(l, n){
  sapply(l, `[`, n)
}


# Effect sizes for chi square tests.
cramer.v <- function(chisq) {
  unname(sqrt(chisq$statistic/(sum(chisq$observed)*min(dim(chisq$observed)-1))))
}

cohen.w <- function(chisq) {
  cramer.v(chisq) * sqrt(min(dim(chisq$observed)-1))
}


# Sidak correction for p values.
adjust.p.sidak <- function(p, m) { 1-(1-p)^m }


# Harmonic mean.
mean.harm <- function(v) {
  1/mean(1/v)
}


# Maps 0..1 to colors from a given ramp with 100 colors logarithmically.
map.my.ramp <- function(p.between.0.and.1, my.color.ramp.with.100.colors) {
  if (p.between.0.and.1 == 0)
    my.color.ramp.with.100.colors[1]
  else {
    .col.idx <- round(log(p.between.0.and.1, base = 10)*-50, 0)+1
    if (.col.idx > 100) .col.idx <- 100
    my.color.ramp.with.100.colors[.col.idx]
  }
}

# Calculate frequency band from raw f and f_max.
frequency.band <- function(f, f.max = 258507195) {
  floor(log(f.max/f, base = 2)+0.5)
}


# Check whether a value lies in a range.
in.range <- function(x, low, high, inc.low = T, inc.high =T) {
  .op.low  <- ifelse(inc.low,  function(x,y) { x >= y }, function(x,y) { x > y })
  .op.high <- ifelse(inc.high, function(x,y) { x <= y }, function(x,y) { x < y })
  .op.low(x, low) & .op.high(x, high)
}


get.ppot <- function(N1, db, LE) {
  db[[LE]][which(db[[LE]]$N1 == N1), c("With_Ppot", "Without_Ppot")]
}

# Function to get rid of blacklisted N1s in single df.
clean.df.by.blacklist <- function(df, blacklist, column) {
  .cns <- colnames(df)
  .blacked <- which(df[,column] %in% blacklist[,column])
  .blacked <- .blacked[which(!is.na(.blacked))]
  if (length(.blacked) > 0) {
    .r <- as.data.frame(df[-c(.blacked),])
  } else {
    .r <- as.data.frame(df)
  }
  colnames(.r) <- .cns
  .r
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




map.log <-  function(x, x.max, to.max = 1.5) {
  log(x)/log(x.max)*(to.max)
}



le.name <- function(le) {
  ifelse(startsWith(le, 'U'), paste0('=', substr(le, 2, nchar(le))),
         ifelse(startsWith(le, 'X'), paste0('*', substr(le, 2, nchar(le))),
                ifelse(le == "nul", "0",
                       paste0('-', le)
                       )
                )
         )
}


plot.productivities <- function(le, analyses, dots = F, max.plottable = 100,
                                norm.xax = NULL, norm.yax = NULL, zero.floor = NULL,
                                the.colors,
                                main.chunk = "Productivity of N1 with ",
                                ylab.chunk = "P(N1) without linking element",
                                xlab.chunk = "P(N1) with linking element") {
  if (le == "EMPTY_PLOT") {
    plot.new()
    return()
  }
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

  .le.name <- le.name(le)

  plot(.n1s[,"With_Ppot"]~.n1s[,"Without_Ppot"], type="n",
       main = paste0(main.chunk, .le.name, .subtitle),
       xlim = .xlim,
       ylim = .ylim,
       ylab = ylab.chunk,
       xlab = xlab.chunk,
       log = "xy"
  )
  for (n in 1:nrow(.n1s)) {
    if (dots) {
      points(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
             pch = 20,
             cex = map.log(.n1s[n,"With_Ftype"], .fty.max.with, 4),
             col = the.colors[round(map.log(.n1s[n,"Without_Ftype"], .fty.max.without, 100), 0)]
      )
      legend("topleft",
             legend = c(paste0("F=1;1"),
                        paste0("F=", .fty.max.with, ";1"),
                        paste0("F=1;", .fty.max.without),
                        paste0("F=", .fty.max.with, ";", .fty.max.without)
                        ),
             pch = 20,
             col = c(
                 the.colors[round(map.log(2, .fty.max.without, 100), 0)],
                 the.colors[round(map.log(2, .fty.max.without, 100), 0)],
                 the.colors[round(map.log(.fty.max.without, .fty.max.without, 100), 0)],
                 the.colors[round(map.log(.fty.max.without, .fty.max.without, 100), 0)]
               ),
             pt.cex = c(
                 0.2,
                 map.log(.fty.max.with, .fty.max.with, 4),
                 0.2,
                 map.log(.fty.max.with, .fty.max.with, 4)
               ),
             cex = 0.8,
             #bty = "n"
             bg = "white"
      )
    } else {
      text(.n1s[n,"With_Ppot"], .n1s[n,"Without_Ppot"],
           cex = map.log(.n1s[n,"With_Ftype"], .fty.max.with),
           labels = .n1s[n, "N1"],
           col = the.colors[round(map.log(.n1s[n,"Without_Ftype"], .fty.max.without, 100), 0)],
           srt = sample(-90:90, 1)
      )
    }
  }
}

# A faster BOBYQA optimizer.
library(nloptr)
defaultControl <- list(algorithm="NLOPT_LN_BOBYQA",xtol_rel=1e-6,maxeval=1e5)
nloptwrap2 <- function(fn,par,lower,upper,control=list(),...) {
  for (n in names(defaultControl))
    if (is.null(control[[n]])) control[[n]] <- defaultControl[[n]]
    res <- nloptr(x0=par,eval_f=fn,lb=lower,ub=upper,opts=control,...)
    with(res,list(par=solution,
                  fval=objective,
                  feval=iterations,
                  conv=if (status>0) 0 else status,
                  message=message))
}
