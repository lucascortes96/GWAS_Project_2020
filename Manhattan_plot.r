## Creating Manhattan plots from --assoc in PLINK 

# Read in your plink assoc file 
plink <- read.csv
("plink.assoc", sep="")

plink_fdr <- p.adjust(plink$P, method="fdr")

plink_final <- cbind(plink, plink_fdr )

manhattan(plink_final, P="plink_fdr", main = "Manhattan Plot",
ylim = c(0, 10), cex = 0.6,cex.axis = 0.9, col = c("blue4", "orange3"), s
uggestiveline = F, genomewideline = F,chrlabs = c(1:21, "P", "Q"))
