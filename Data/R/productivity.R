rm(list = ls())

script.path <- '~/Workingcopies/Linkingelements/Data/R'
data.path   <- paste0(script.path, '/../Database/')

lwd = 3
lty = 1:10
col = 1:10

setwd(script.path)

source('load.R')

plot(e1token.nole$Frequency~e1type.nole$Frequency, type="l", lwd = lwd, lty = lty[1], col = col[1],
     ylim = c(1, 3400000), log = "xy",
     main = "Type & token frequency of N1",
     xlab = "type frequency (log)",
     ylab = "token frequency (log)")
lines(e1token.s$Frequency~e1type.s$Frequency, type="l", lwd = lwd, lty = lty[2], col = col[2])
lines(e1token.e$Frequency~e1type.e$Frequency, type="l", lwd = lwd, lty = lty[3], col = col[3])
lines(e1token.en$Frequency~e1type.en$Frequency, type="l", lwd = lwd, lty = lty[4], col = col[4])
lines(e1token.er$Frequency~e1type.er$Frequency, type="l", lwd = lwd, lty = lty[5], col = col[5])
lines(e1token.n$Frequency~e1type.n$Frequency, type="l", lwd = lwd, lty = lty[6], col = col[6])
lines(e1token.Ue$Frequency~e1type.Ue$Frequency, type="l", lwd = lwd, lty = lty[7], col = col[7])
lines(e1token.Uer$Frequency~e1type.Uer$Frequency, type="l", lwd = lwd, lty = lty[8], col = col[8])
legend('topleft', lwd = lwd, col = col, lty = lty,
        legend = c("0", "-s", "-e", "-en", "-er", "-n", "=e", "=er"))

