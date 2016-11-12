is.tcga.biolinks.installed <- "TCGAbiolinks" %in% row.names(installed.packages())
if (!is.tcga.biolinks.installed) {
  source("https://bioconductor.org/biocLite.R")
  biocLite("TCGAbiolinks")
}

is.survival.installed <- "survival" %in% row.names(installed.packages())
if (! is.survival.installed) {
  install.packages("survival")
}

library("survival")
library("TCGAbiolinks")

# data.frame listing patients with TNBC
brca.patients <- TCGAquery_subtype(tumor = 'brca')

brca.patients <- data.frame(brca.patients, is.tnbc = brca.patients$ER.Status == "Negative" &
                              brca.patients$PR.Status == 'Negative' &
                              brca.patients$HER2.Final.Status == 'Negative')
# find triple-negative patients - yields a
# data.frame with details about each patient
# This will also filter out NA
tnbc.patients <- subset(brca.patients,  brca.patients$ER.Status == "Negative" &
                          brca.patients$PR.Status == 'Negative' &
                          brca.patients$HER2.Final.Status == 'Negative')

survival.obj <- with(brca.patients, 
                      Surv(time = brca.patients$Days.to.date.of.Death,
                           event = brca.patients$Vital.Status == 'DECEASED'))

survival.fit <- survfit(survival.obj ~ is.tnbc, data = brca.patients)
plot(survival.fit, col = c("red", "purple"), xlab = "Days", ylab = "Proportion Surviving")
legend('topright', c("Other", "TNBC"), col=c("red", "purple"), lty = 1)
title("Kaplan-Meier curves for\nTriple-Negative vs Other Breast Cancers")
