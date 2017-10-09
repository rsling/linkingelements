e1s.nole <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+.txt'))
e1s.e <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+e.txt'))
e1s.en <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+en.txt'))
e1s.er <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+er.txt'))
e1s.n <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+n.txt'))
e1s.s <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+s.txt'))
e1s.Ue <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+Ue.txt'))
e1s.Uer <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+Uer.txt'))
# e1s.Un <- read.csv2(paste0(data.path, 'erstglieder/erstglieder+Un.txt'))  # No matches.

e1hapax.nole <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+.csv'),
                          sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.e <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+e.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.en <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+en.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.er <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+er.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.n <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+n.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.s <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+s.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.Ue <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+Ue.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1hapax.Uer <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+Uer.csv'),
                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
# e1hapax.Un <- read.csv2(paste0(data.path, 'fhapax/fhapax_erstglieder+Un.csv'),
#                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))  # No matches.

e1token.nole <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+.csv'),
                          sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.e <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+e.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.en <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+en.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.er <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+er.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.n <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+n.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.s <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+s.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.Ue <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+Ue.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1token.Uer <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+Uer.csv'),
                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
# e1token.Un <- read.csv2(paste0(data.path, 'ftoken/ftoken_erstglieder+Un.csv'),
#                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))  # No matches.

e1type.nole <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+.csv'),
                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.e <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+e.csv'),
                      sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.en <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+en.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.er <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+er.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.n <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+n.csv'),
                      sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.s <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+s.csv'),
                      sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.Ue <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Ue.csv'),
                       sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
e1type.Uer <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Uer.csv'),
                        sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))
# e1type.Un <- read.csv2(paste0(data.path, 'ftype/ftype_erstglieder+Un.csv'),
#                         sep = "\t", colClasses = c("character", "integer"), header = FALSE, col.names = c("Noun", "Frequency"))  # No matches.

e1compounds.nole <- read.csv2(paste0(data.path, 'compounds/compounds+.csv'),
                              sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.e <- read.csv2(paste0(data.path, 'compounds/compounds+e.csv'),
                           sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.en <- read.csv2(paste0(data.path, 'compounds/compounds+en.csv'),
                            sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.er <- read.csv2(paste0(data.path, 'compounds/compounds+er.csv'),
                            sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.n <- read.csv2(paste0(data.path, 'compounds/compounds+n.csv'),
                           sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.s <- read.csv2(paste0(data.path, 'compounds/compounds+s.csv'),
                           sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.Ue <- read.csv2(paste0(data.path, 'compounds/compounds+Ue.csv'),
                            sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
e1compounds.Uer <- read.csv2(paste0(data.path, 'compounds/compounds+Uer.csv'),
                             sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))
# e1compounds.Un <- read.csv2(paste0(data.path, 'compounds/compounds+Un.csv'),
#                         sep = "\t", colClasses = c("character", "character", "integer"), header = FALSE, col.names = c("Noun1", "Noun2", "Frequency"))  # No matches.
