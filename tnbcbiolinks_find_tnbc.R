# TCGALink manual, see
# https://bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/tcgaBiolinks.html

# TODO remove check when Packrat supported in R 3.3.1
is.tcga.biolinks.installed <- "TCGAbiolinks" %in% row.names(installed.packages())
if (!is.tcga.biolinks.installed) {
  source("https://bioconductor.org/biocLite.R")
  biocLite('TCGAbiolinks')
}

library('TCGAbiolinks')

# data.frame listing patients with TNBC
brca.patients <- TCGAquery_subtype(tumor = 'brca')

# find triple-negative patients - yields a
# data.frame with details about each patient
# TODO - check filter out <NA> values

tnbc.patients <- subset(brca.patients,  brca.patients$ER.Status == "Negative" &
                          brca.patients$PR.Status == 'Negative' &
                          brca.patients$HER2.Final.Status == 'Negative')

# we can retrieve the patient barcodes and use them to query
# GDC for the transcriptome profiles:
# (use as.character because type is factor)
barcodes <- as.character(tnbc.patients$patient)

# maybe
query <- GDCquery(project = "TCGA-BRCA", 
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - FPKM",
                  barcode = barcodes)

GDCdownload(query)