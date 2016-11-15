source("https://bioconductor.org/biocLite.R")
biocLite("globaltest")
biocLite("globaltest")
biocLite("vsn")

# 1999 expression set used in testing this method out
# 38 samples of ALL.AML
library(golubEsets)
data("Golub_Train")

# normalising microarray data
library(vsn)
exprs(Golub_Train) <- exprs(vsn2(Golub_Train))

library(globaltest)

# H0 : None of the genes are differentially expressed between ALL and AML
gt(ALL.AML, Golub_Train)
# p is 1.78e-11 - implies we can reject H0 meaning there are differentially expressed genes between the two

# H0 : None of the genes are differentially expressed between ALL and AML
# when accounting for covariate "Source"
gt(ALL.AML ~ Source, Golub_Train)

# P is 1.0 ergo, H0 can't be rejected meaning previous
# test was totally confounded by Source