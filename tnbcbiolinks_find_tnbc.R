
# N.B work in progress - not yet run
# legacy data from TCGAquery For manual, see
# https://bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/tcgaBiolinks.html

biocLite('TCGAbiolinks')
library('TCGAbiolinks')

# data.frame listing patients with TNBC
brca.patients <- TCGAquery_subtype(tumor = 'brca')

# find triple-negative patients - yields a
# data.frame with details about each patient
# TODO - check filter out <NA> values
tnbc.condition <- result$ER.Status == 'Negative' &
	       	  result$PR.Status == 'Negative' &
		  result$HER.2.Final.Status == 'Negative')
tnbc.patients <- subset(brca.patients, tnbc.condition)

# we can retrieve the patient barcodes and use them to query
# GDC for the transcriptome profiles:
# (use as.character because type is factor)
barcodes <- as.character(tnbc.patients$patient)

# maybe
query <- GDCquery(project = "TCGA-BRCA", 
                  data.category = "Gene expression",
                  data.type = "Gene Expression Quantification",
                  experimental.strategy = "RNA-Seq",
                  platform = "Illumina HiSeq",
                  file.type = "results",
                  barcode = barcodes, 
                  legacy = TRUE)

GDCdownload(query)