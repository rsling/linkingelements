rm(list = ls())
set.seed(720)
source('functions.R')
data.path   <- '../Database/'

nouns <- list(
  no  = read.csv2(paste0(data.path, 'n1/n1+NP.txt'),
                  header = FALSE, col.names = c("N1")),
  nul = read.csv2(paste0(data.path, 'n1/n1+.txt'),
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
                  header = FALSE, col.names = c("N1")),
  ns  = read.csv2(paste0(data.path, 'n1/n1+ns.txt'),
                  header = FALSE, col.names = c("N1")),
  ens = read.csv2(paste0(data.path, 'n1/n1+ens.txt'),
                  header = FALSE, col.names = c("N1")),
  Xe  = read.csv2(paste0(data.path, 'n1/n1-e.txt'),
                  header = FALSE, col.names = c("N1"))
)


fhapax <- list(
  no  = read.csv2(paste0(data.path, 'fhapax/fhapax+NP.csv'),
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
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ns   = read.csv2(paste0(data.path, 'fhapax/fhapax+ns.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ens  = read.csv2(paste0(data.path, 'fhapax/fhapax+ens.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Xe   = read.csv2(paste0(data.path, 'fhapax/fhapax-e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftoken <- list(
  no  = read.csv2(paste0(data.path, 'ftoken/ftoken+NP.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  nul = read.csv2(paste0(data.path, 'ftoken/ftoken+.csv'),
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
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ns  = read.csv2(paste0(data.path, 'ftoken/ftoken+ns.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ens = read.csv2(paste0(data.path, 'ftoken/ftoken+ens.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Xe  = read.csv2(paste0(data.path, 'ftoken/ftoken-e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


ftype <- list(
  no  = read.csv2(paste0(data.path, 'ftype/ftype+NP.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  nul = read.csv2(paste0(data.path, 'ftype/ftype+.csv'),
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
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ns  = read.csv2(paste0(data.path, 'ftype/ftype+ns.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  ens = read.csv2(paste0(data.path, 'ftype/ftype+ens.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F")),
  Xe  = read.csv2(paste0(data.path, 'ftype/ftype-e.csv'),
                  sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("N1", "F"))
)


compounds <- list(
  no  = read.csv2(paste0(data.path, 'compounds/compounds+NP.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  nul = read.csv2(paste0(data.path, 'compounds/compounds+.csv'),
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
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  ns  = read.csv2(paste0(data.path, 'compounds/compounds+ns.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  ens = read.csv2(paste0(data.path, 'compounds/compounds+ens.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F")),
  Xe  = read.csv2(paste0(data.path, 'compounds/compounds-e.csv'),
                  sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("N1", "N2", "F"))
)


blacklists <- list(
  no  = data.frame(N1 = c("Nonwort")),
  nul = read.csv2(paste0(data.path, 'n1/real_blacklist+.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  e   = read.csv2(paste0(data.path, 'n1/real_blacklist+e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
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
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  ns  = read.csv2(paste0(data.path, 'n1/real_blacklist+ns.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  ens = read.csv2(paste0(data.path, 'n1/real_blacklist+ens.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Xe  = read.csv2(paste0(data.path, 'n1/real_blacklist-e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1"))
)

blacklists.lax <- list(
  no  = data.frame(N1 = c("Nonwort")),
  nul = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  e   = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  e   = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  en  = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+en.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  er  = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+er.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  n   = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+n.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  s   = data.frame(N1 = c("Nonwort")),
  Ue  = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+Ue.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Uer = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+Uer.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  U   = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+U.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  ns  = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+ns.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  ens = read.csv2(paste0(data.path, 'n1/real_lax_blacklist+ens.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1")),
  Xe  = read.csv2(paste0(data.path, 'n1/real_lax_blacklist-e.txt'),
                  sep = "\t", colClasses = c("character"), header = FALSE, col.names = c("N1"))
)


# Clean the basic lists (pre-loaded data).
nouns.lax <- clean.dfs.by.blacklist(nouns, blacklists.lax, "N1")
nouns <- clean.dfs.by.blacklist(nouns, blacklists, "N1")

ftype.lax <- clean.dfs.by.blacklist(ftype, blacklists.lax, "N1")
ftype <- clean.dfs.by.blacklist(ftype, blacklists, "N1")

ftoken.lax <- clean.dfs.by.blacklist(ftoken, blacklists.lax, "N1")
ftoken <- clean.dfs.by.blacklist(ftoken, blacklists, "N1")

fhapax.lax <- clean.dfs.by.blacklist(fhapax, blacklists.lax, "N1")
fhapax <- clean.dfs.by.blacklist(fhapax, blacklists, "N1")

compounds <- clean.dfs.by.blacklist(compounds, blacklists, "N1")

# Load big noun frequency data base.
noun.frequencies <- read.csv2(paste0(data.path, 'compounds/decow16ax_nouns_counts.csv'),
                              sep = ' ', header = FALSE, col.names = c("N", "F"))

dir.create('./RData', showWarnings = F)
save(list = c("nouns", "nouns.lax"), file = "RData/nouns.RData", compress = "bzip2")
save(list = c("fhapax", "fhapax.lax", "ftoken", "ftoken.lax", "ftype", "ftype.lax"), file = "RData/n1.frequencies.RData", compress = "bzip2")
save(list = "compounds", file = "RData/compounds.RData", compress = "bzip2")
save(list = c("blacklists", "blacklists.lax"), file = "RData/blacklists.RData", compress = "bzip2")
save(list = "noun.frequencies", file = "RData/noun.frequencies.RData", compress = "bzip2")
