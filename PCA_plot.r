## Creating a PCA plot from the PLINK files created using the package tidyverse 

##Loading in Packages
library(tidyverse)
pca <- read_table2("./full_test_pca.eigenvec", col_names = FALSE)
eigenval <- scan("./full_test_pca.eigenval")
pca <- pca[,-1]
names(pca[1]) <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

## Add names
spp <- rep(NA, length(pca$X2))
spp[grep("PyeLake", pca$X2)] <- "pyelake"
spp[grep("PyeOutlet", pca$X2)] <- "pyeoutlet"
spp[grep("LCS", pca$X2)] <- "LCS"
spp[grep("Robert", pca$X2)] <- "roboutlet"
spp[grep("Anad", pca$X2)] <- "Anad"
spp[grep("Salmon", pca$X2)] <- "Salmon"
spp[grep("Nick", pca$X2)] <- "Nick"
spp[grep("Bonsall", pca$X2)] <- "Bonsall"
spp[grep("West", pca$X2)] <- "West"
spp[grep("LCA", pca$X2)] <- "LCA"
spp[grep("Matadero", pca$X2)] <- "Matadero"
spp[grep("BigSoos", pca$X2)] <- "BigSoos"
## Creating plot of percentage variance explained by each principle component 
pca <- as_tibble(data.frame(pca, spp))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage Variance Explained") + theme_light()
## This should add up to 100
cumsum(pve$pve)

## Creating PCA

b <- ggplot(pca, aes(PC1, PC2, col = spp)) + geom_point(size = 1)
b <- b + scale_colour_manual(values = c("red", "blue", "green", "yellow", "purple", "orange", "brown", "black", "pink", "gray", "chocolate2", "cyan1" ))
b <- b + coord_equal() + theme_light()
b + xlab(paste0("PC1(", signif(pve$pve[1],3),"%)"))+ ylab(paste0("PC2(",signif(pve$pve[2],3),"%"))
