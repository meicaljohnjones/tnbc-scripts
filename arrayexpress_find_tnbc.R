# TODO remove check when Packrat supported in R 3.3.1
is.tcga.biolinks.installed <- "ArrayExpress" %in% row.names(installed.packages())
if (!is.tcga.biolinks.installed) {
  source("https://bioconductor.org/biocLite.R")
  biocLite('ArrayExpress')
}

library('ArrayExpress')
sets <- queryAE(keywords = 'triple-negative+breast+cancer', species= 'homo+sapiens')

set.ids <- as.character(sets$ID)


# for one - need to do for N
# also - not tnbc data so need to think of way to get this
set.data <- ArrayExpress(set.ids[2])
fac.column <- grep("FactorValue",colnames(pData(set.data)), value=T)
facs <- pData(set.data)[,fac.column]

fac <- factor(facs)
design <- model.matrix(~0+fac)
colnames(design) <- c('cancer.assoc.fibroblast', 'granulin.stimulated.fibroblast', 'normal.mammary.tissue')
fit <- lmFit(set.data, design)

cont.matrix <- makeContrasts(cancerFvsNormalT=cancer.assoc.fibroblast-normal.mammary.tissue,granulinFvsNormalT=granulin.stimulated.fibroblast-normal.mammary.tissue, levels=design)
fit2  <- contrasts.fit(fit, cont.matrix)
fit2 <- eBayes(fit2)

res.cancer.vs.normaltissue <- topTable(fit2, coef = 'cancerFvsNormalT', adjust="BH")

results  <- classifyTestsF(fit2, p.value=0.0001)
vennDiagram(results, include="up")
