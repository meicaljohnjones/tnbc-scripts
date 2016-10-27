# TODO remove check when Packrat supported in R 3.3.1
is.tcga.biolinks.installed <- "ArrayExpress" %in% row.names(installed.packages())
if (!is.tcga.biolinks.installed) {
  source("https://bioconductor.org/biocLite.R")
  biocLite('ArrayExpress')
}

library('ArrayExpress')
sets <- queryAE(keywords = 'triple-negative+breast+cancer', species= 'homo+sapiens')

set.ids <- as.character(sets$ID)[2]
set.data <- getAE(set.ids, type = "processed")

# set.data <- lapply(set.ids, getAE, type = full)


