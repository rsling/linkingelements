rm(list = ls())
set.seed(4628)

# Set working directory to script's location if necessary.

library(readODS)
library(readr)

out.dir   <- "Concordances/"
filenames <- list.files("Annotations", pattern = ".+.ods",
                        full.names = T)

concordances <- list()



for (filename in filenames) {
  print(filename)
  le.name <- gsub('^.+\\+(.+)\\.ods$', '\\1', filename)
  sheetnames <- ods_sheets(filename)
  for (sheetname in sheetnames) {
    print(sheetname)
    le <- substr(sheetname, nchar(sheetname), nchar(sheetname))
    n1 <- substr(sheetname, 1, nchar(sheetname)-1)
    suppressMessages(df <- read_ods(path = filename, sheet = sheetname, col_names = T))
    if (ncol(df) == 5) {
      df$N2Num <- as.factor(ifelse(df$N2Num=="1", "Sg", ifelse(df$N2Num=="2", "Pl", NA)))
      df$N2Typ <- as.factor(ifelse(is.na(df$N2Typ) & !is.na(df$N2Num), 'Ind', ifelse(df$N2Typ == "c", "Coll", NA)))
      df$N1Lemma <- n1
      df$N1Pl <- le.name
      df$LE <- le
      write.table(df, file = paste0(out.dir, n1, le, '.csv'), quote = F, sep = "\t",
                  row.names = F, col.names = T)
    } else {
      print("! SKIPPED !")
    }
  }
}


