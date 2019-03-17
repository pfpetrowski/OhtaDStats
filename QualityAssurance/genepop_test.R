library(ohtadstats)

l1 <- c(1,1,2,0,2,0,0,2,2,2,2,0,0,0,0,0,2,2)
l2 <- c(0,0,1,2,0,1,1,1,2,0,1,0,0,2,1,2,0,2)
l3 <- c(1,1,0,1,1,0,0,1,2,1,2,1,2,2,2,1,2,2)
popnames <- rep(c('AA','BB','CC'), each = 6)

genepop_sample <- matrix(data = c(l1,l2,l3), ncol = 3, dimnames = list(popnames, c('Loc1', 'Loc2', 'Loc3')))
genepop_sample

results <- dwrapper(genepop_sample, tot_maf = 0, pop_maf = 0)

results$dp2is_mat
