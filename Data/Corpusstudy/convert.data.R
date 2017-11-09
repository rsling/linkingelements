rm(list = ls())
set.seed(4628)

# Set working directory to script's location if necessary.

library(readODS)
library(readr)

min.n     <- 100  # Sample more observations if this threshold not reached.
out.dir   <- "Concordances/"
raw.dir   <- "Queries/Output/"
filenames <- list.files("Annotations", pattern = ".+.ods",
                        full.names = T)


"%ni%" <- Negate("%in%")

# Creates a mash to identify the match uniqely.
make.mash <- function(r) {
  the.tail <- tail(strsplit(r[4], split=" ")[[1]], 2)
  the.tail <- ifelse(substr(the.tail, nchar(the.tail), nchar(the.tail)) %in% c(")", ".", "!", "?", " "), "", the.tail)
  paste0(c(
    the.tail,
    r[5],
    head(strsplit(r[6], split=" ")[[1]], 2)
    ), collapse = " ")
}

concordances <- list()

for (filename in filenames) {
  cat("\n", filename, "\n")
  le.name <- gsub('^.+\\+(.+)\\.ods$', '\\1', filename)
  sheetnames <- ods_sheets(filename)
  for (sheetname in sheetnames) {
    cat(sheetname, '... ', sep = "")

    # Extract the name of the N1 and the linking element yes/no feature.
    le <- substr(sheetname, nchar(sheetname), nchar(sheetname))
    n1 <- substr(sheetname, 1, nchar(sheetname)-1)

    # Read tabel from ODS and add NA columns for meta data in the right place.
    suppressMessages(df <- read_ods(path = filename, sheet = sheetname, col_names = T))
    if (ncol(df) == 5) {
      df <- cbind(data.frame(
        DocURL = rep(NA, nrow(df)),
        DocID  = rep(NA, nrow(df)),
        SentID = rep(NA, nrow(df))
      ), df)

      # Recode the number and  noun type to nicer looking values.
      df$N2Num <- as.factor(ifelse(df$N2Num=="1", "Sg", ifelse(df$N2Num=="2", "Pl", NA)))
      df$N2Typ <- as.factor(ifelse(is.na(df$N2Typ) & !is.na(df$N2Num), 'Ind', ifelse(df$N2Typ == "c", "Coll", NA)))

      # Make annotations we can get here for free.
      # Needed later in analysis to catch item-specific effects.
      df$N1Lemma <- n1
      df$N1Pl <- le.name
      df$LE <- le

      # Add the mash for finding the URL etc. in the other table.
      df$Mash <- apply(df, 1, make.mash)

      # Now load the exhaustive query table.
      # Ignore lines 1-18, which are commnets added by ManaCOW.
      big.df <- read.delim(file = gzfile(paste0(raw.dir, n1, le, '.csv.gz')),
                           skip = 18, sep = "\t", header = T, quote = "")

      # Remove the final comments.
      big.df <- big.df[c(1:(nrow(big.df)-2)),]

      # Create mashes for big table, too.
      big.df$Mash <- apply(big.df, 1, make.mash)

      temp.df <- merge(x = df, y = big.df, by = "Mash", all.x = T)
      temp.df <- temp.df[!duplicated(temp.df[,"Match"]),]

      # Now align new and old df and join annotations.
      df <- df[order(df$Match),]
      temp.df <- temp.df[order(temp.df$Match),]

      # We check whether the Matches match. If so, write data, else abort.
      if (!all(temp.df$Match == df$Match)) {
        cat("\n! ALIGNING MISMATCH !")
      } else {

        # Copy missing data from temp table.
        df[,c("DocURL", "DocID", "SentID", "LC", "RC")] <- temp.df[,c("doc.url", "doc.id", "s.idx", "left.context", "right.context")]

        # Keep only complete cases and remove Mash column.
        df <- df[complete.cases(df),-c(12)]

        cat(nrow(df), " rows retrieved", sep = "")

        # Now sample more if not enough.
        if (nrow(df) < min.n) {
          true.missing.n <- (min.n - nrow(df))
          missing.n <- true.missing.n*3   # Sample three times as many as required. To be on the safe side.

          # First, reduce big data frame to entries with unique matches.
          big.df <- big.df[which(big.df$dup.match == "0"),]

          # Give the big data frame new column names (not a good idea before because the JOIN messes up
          # the column names if they are identical - suffixing .x and .y).
          colnames(big.df) <- c("DocURL", "DocID", "SentID", "LC", "Match", "RC", "Dup", "Mash")

          # Get rid of matches already analysed.
          big.df <- big.df[which(big.df$Match %ni% df$Match),]
          missing.n <- ifelse(missing.n > nrow(big.df), nrow(big.df), missing.n)
          temp.df <- big.df[sample(1:nrow(big.df), size = missing.n, replace = F), c("DocURL", "DocID", "SentID", "LC", "Match", "RC")]
          temp.df$N2Num <- NA
          temp.df$N2Typ <- NA
          temp.df$N1Lemma <- n1
          temp.df$N1Pl <- le.name
          temp.df$LE <- le

          df <- rbind(df, temp.df)

          cat('... Added ', nrow(temp.df), " new rows (", true.missing.n, " needed minimally)", sep = "")

        } else {
          cat(". Satisfied")
        }

        cat(".\n")

        # Gentlemen, to disk!
        write.table(df, file = paste0(out.dir, n1, le, '.csv'), quote = F, sep = "\t",
                    row.names = F, col.names = T)
      }
    } else {
      cat("\n! SKIPPED !")
    }
  }
}
