rm(list = ls())
source('functions.R')
data.path   <- '../Database/'

nouns <- list(
  no  = read.csv2(paste0(data.path, 'erstglieder/erstglieder+.txt'),
                  header = FALSE, col.names = c("N1")),
  e   = read.csv2(paste0(data.path, 'erstglieder/erstglieder+e.txt'),
                  header = FALSE, col.names = c("N1")),
  en  = read.csv2(paste0(data.path, 'erstglieder/erstglieder+en.txt'),
                  header = FALSE, col.names = c("N1")),
  er  = read.csv2(paste0(data.path, 'erstglieder/erstglieder+er.txt'),
                  header = FALSE, col.names = c("N1")),
  n   = read.csv2(paste0(data.path, 'erstglieder/erstglieder+n.txt'),
                  header = FALSE, col.names = c("N1")),
  s   = read.csv2(paste0(data.path, 'erstglieder/erstglieder+s.txt'),
                 header = FALSE, col.names = c("N1")),
  Ue  = read.csv2(paste0(data.path, 'erstglieder/erstglieder+Ue.txt'),
                  header = FALSE, col.names = c("N1")),
  Uer = read.csv2(paste0(data.path, 'erstglieder/erstglieder+Uer.txt'),
                  header = FALSE, col.names = c("N1"))
)


fhapax <- list(
  no  = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer  = read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftoken <- list(
  no  = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer = read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftype <- list(
  no  = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  e   = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  en  = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+en.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  er  = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+er.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  n   = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+n.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  s   = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+s.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Ue  = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Ue.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uer = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Uer.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Uen = read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Uer.csv'),
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
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F"))
)


blacklists <- list(
  no  = data.frame(N1 = c("Nonwort")),
  e   = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  en  = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+en.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  er  = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+er.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  n   = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+n.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  s   = data.frame(N1 = c("Nonwort")),
  Ue  = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+Ue.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Uer = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+Uer.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Uen = read.csv2(paste0(data.path, 'erstglieder/real_blacklist+Uer.txt'),
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
