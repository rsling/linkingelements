rm(list = ls())
set.seed(720)
source('functions.R')
data.path   <- '../Database/'

nouns <- list(
  no  = read.csv2(paste0(data.path, 'n1/n1+.txt'),
                  header = FALSE, col.names = c("N1")),
  e   = read.csv2(paste0(data.path, 'n1/n1+e.txt'),
                  header = FALSE, col.names = c("N1")),
  en  = read.csv2(paste0(data.path, 'n1/n1+en.txt'),
                  header = FALSE, col.names = c("N1")),
  er  = read.csv2(paste0(data.path, 'n1/n1+er.txt'),
                  header = FALSE, col.names = c("N1")),
  n   = read.csv2(paste0(data.path, 'n1/n1+n.txt'),
                  header = FALSE, col.names = c("N1")),
  s   = read.csv2(paste0(data.path, 'n1/n1+s.txt'),
                 header = FALSE, col.names = c("N1")),
  Ue  = read.csv2(paste0(data.path, 'n1/n1+Ue.txt'),
                  header = FALSE, col.names = c("N1")),
  Uer = read.csv2(paste0(data.path, 'n1/n1+Uer.txt'),
                  header = FALSE, col.names = c("N1")),
  U   = read.csv2(paste0(data.path, 'n1/n1+U.txt'),
                  header = FALSE, col.names = c("N1"))
)


fhapax <- list(
  no  = read.csv2(paste0(data.path, 'fhapax/fhapax+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'fhapax/fhapax+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'fhapax/fhapax+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'fhapax/fhapax+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'fhapax/fhapax+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'fhapax/fhapax+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'fhapax/fhapax+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer  = read.csv2(paste0(data.path, 'fhapax/fhapax+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  U    = read.csv2(paste0(data.path, 'fhapax/fhapax+U.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftoken <- list(
  no  = read.csv2(paste0(data.path, 'ftoken/ftoken+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'ftoken/ftoken+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'ftoken/ftoken+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'ftoken/ftoken+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'ftoken/ftoken+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'ftoken/ftoken+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'ftoken/ftoken+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer = read.csv2(paste0(data.path, 'ftoken/ftoken+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  U   = read.csv2(paste0(data.path, 'ftoken/ftoken+U.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftype <- list(
  no  = read.csv2(paste0(data.path, 'ftype/ftype+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'ftype/ftype+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'ftype/ftype+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'ftype/ftype+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'ftype/ftype+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'ftype/ftype+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'ftype/ftype+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer = read.csv2(paste0(data.path, 'ftype/ftype+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  U   = read.csv2(paste0(data.path, 'ftype/ftype+U.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


compounds <- list(
  no  = read.csv2(paste0(data.path, 'compounds/compounds+.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  e   = read.csv2(paste0(data.path, 'compounds/compounds+e.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  en  = read.csv2(paste0(data.path, 'compounds/compounds+en.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  er  = read.csv2(paste0(data.path, 'compounds/compounds+er.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  n   = read.csv2(paste0(data.path, 'compounds/compounds+n.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  s   = read.csv2(paste0(data.path, 'compounds/compounds+s.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  Ue  = read.csv2(paste0(data.path, 'compounds/compounds+Ue.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  Uer = read.csv2(paste0(data.path, 'compounds/compounds+Uer.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  U   = read.csv2(paste0(data.path, 'compounds/compounds+U.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F"))
)


blacklists <- list(
  no  = data.frame(N1 = c("Nonwort")),
  e   = read.csv2(paste0(data.path, 'n1/real_blacklist+e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  en  = read.csv2(paste0(data.path, 'n1/real_blacklist+en.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  er  = read.csv2(paste0(data.path, 'n1/real_blacklist+er.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  n   = read.csv2(paste0(data.path, 'n1/real_blacklist+n.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  s   = data.frame(N1 = c("Nonwort")),
  Ue  = read.csv2(paste0(data.path, 'n1/real_blacklist+Ue.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Uer = read.csv2(paste0(data.path, 'n1/real_blacklist+Uer.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  U   = read.csv2(paste0(data.path, 'n1/real_blacklist+U.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1"))
)

# Clean the basic lists (pre-loaded data).
nouns <- clean.dfs.by.blacklist(nouns, blacklists, "N1")
ftype <- clean.dfs.by.blacklist(ftype, blacklists, "N1")
ftoken <- clean.dfs.by.blacklist(ftoken, blacklists, "N1")
fhapax <- clean.dfs.by.blacklist(fhapax, blacklists, "N1")
compounds <- clean.dfs.by.blacklist(compounds, blacklists, "N1")

# Load big noun frequency data base.
noun.frequencies <- read.csv2(paste0(data.path, 'compounds/decow16ax_nouns_counts.csv'),
                              sep = ' ', header = FALSE, col.names = c("N", "F"))

dir.create('./RData', showWarnings = F)
save(list = "nouns", file = "RData/nouns.RData", compress = "bzip2")
save(list = "fhapax", file = "RData/fhapax.RData", compress = "bzip2")
save(list = "ftoken", file = "RData/ftoken.RData", compress = "bzip2")
save(list = "ftype", file = "RData/ftype.RData", compress = "bzip2")
save(list = "compounds", file = "RData/compounds.RData", compress = "bzip2")
save(list = "blacklists", file = "RData/blacklists.RData", compress = "bzip2")
save(list = "noun.frequencies", file = "RData/noun.frequencies.RData", compress = "bzip2")
