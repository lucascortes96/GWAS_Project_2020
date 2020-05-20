# Creating files used to create PCA plot from PLINK 


# perform linkage pruning - i.e. identify prune sites. Use output files from variant calling 
plink --vcf full_cohort.vcf --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out full_cohort

## Making PCA via PLINK
--vcf full_cohort.vcf --double-id --allow-extra-chr --set-missing-var-ids @:#
--extract full_test.prune.in --make-bed --mind --threads 12
--pca --out full_test_pca

## This way allows you to exclude individuals from your cohort, make the text file with individuals you want to exclude
plink --bfile full_cohort_plink --pca --allow-extra-chr --remove note_test.txt --mind 0.9
