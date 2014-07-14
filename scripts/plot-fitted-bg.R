#!/usr/bin/Rscript --verbose

D <- read.csv(commandArgs(TRUE)[1])
D <- D[1:length(D$bin),]

X11()
plot(dpois(D$bin[1:30], lambda = as.numeric(commandArgs(TRUE)[2])) * as.numeric(commandArgs(TRUE)[3]), col='blue')
points(D$N_avg_amp[1:30], col='red')
readLines(con="stdin", 1)
