rm(list = ls())
source('functions.R')

load("RData/analyses.full.RData")
load("RData/noun.frequencies.RData")
load("RData/compounds.RData")

les <- c('e', 'Ue', 'er', 'Uer', 'n', 'en')

frequencydata.full <- list(
  e   = NULL, en  = NULL, er  = NULL,
  n   = NULL, Ue  = NULL, Uer = NULL
)


for (le in les) {
  frequencydata.full[[le]] <-
    merge(all.x = T,
      merge(all.x = T,
        merge(all.x = T,
          compounds[[le]], analyses.full[[le]][,c(1,2,6,7,8,9,13,14,15)], by = "N1"
          ),
        noun.frequencies, by.x = "N1", by.y = "N"
        ),
      noun.frequencies, by.x = "N2", by.y = "N"
    )
  colnames(frequencydata.full[[le]])[c(3,12,13)] <- c("Fcompound", "FN1", "FN2")
}

save(list = "frequencydata.full", file = "RData/frequencydata.full.RData", compress = "bzip2")

# plot(0, type="n", xlim=c(0.00001,1), ylim=c(0.00001,1), log="xy")
# for (i in 1:length(les)) {
#   .le <- les[i]
#   .tytor <- data.frame(With = analyses.full[[.le]]$With_Ftype/analyses.full[[.le]]$With_Ftoken,
#                        Without = analyses.full[[.le]]$Without_Ftype/analyses.full[[.le]]$With_Ftoken
#                        )
#   points(.tytor[order(.tytor$With),1]~.tytor[order(.tytor$With),2],
#        lty = 17+i,
#        col = i)
# }
