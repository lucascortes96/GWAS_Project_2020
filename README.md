# GATK Variant Discovery Pipeline for Stickleback Genomics Project 2019-2020



#Lucas Cortes 2019 germline short variant discovery (SNPs and indels) PIPELINE
 (justification for running all files together
 https://gatkforums.broadinstitute.org/gatk/discussion/8639/run-genotypegvcfs
 -by-populations-separately-or-all-populations-together)



##Fix for header issue using SED COMMAND (you can see this in the header of
## each BAM file)
for filename in *.vcf/bam; do name=$(ls $filename | cut -d"_" -f1,2) ;
  echo sed -ie \"s/FORMAT\\t20/FORMAT\\t$name/g\" $filename; done

##FIRST, DOWNLOAD sambamba

for Filename in *trimmedaligned.bam; do name=`ls $Filename | cut -d"." -f1`
  ~programs/sambamba-0.6.8
  view -t 8 -h -f bam $Filename -o $name"_unique.bam" ;
done

## Mark Duplicates 

for Filename in *.bam; do name=`ls $Filename | cut -d"." -f1`
  ~/programs/sambamba-0.6.8  markdup -r -t 8 $Filename $name".DUPremoved.bam";
done

## VALIDATE BAM FILE 

java -jar picard.jar ValidateSamFile I=AF_DUPremoved.bam MODE=SUMMARY

## Add or repalce read groups

for Filename in *DUPremoved.bam; do name=`ls $Filename | cut -d"." -f1`
  java -jar ~/programs/picard.jar AddOrReplaceReadGroups
  I=$Filename O=$name"_fixed.bam" RGLB=libl RGPL=illumina RGPU=until RGSM=20 ;
done


## Samtools Sort

for filename in *fixed.bam; do name=`ls $filename
  | cut -d"." -f1`; samtools sort $filename -o $name".sorted.bam";
done

## NEXT call variants with haplotype caller in GVCF mode, add all files into this step,
## You can even create a list of the files and use it as --input-list

for filename in *fixed.bam.sorted.bam; do name=`ls $filename
  | cut -d"_" -f1,2,3`
  java -jar  ../../programs/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar
  HaplotypeCaller -ERC GVCF -R revisedAssemblyUnmasked.fa
  -I $filename -O $name"_output.raw.snps.indels.g.vcf";
done


## Combining all the individual gVCFs produced above into one
java -jar -Xmx100G ../../programs/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar
  CombineGVCFs -R revisedAssemblyUnmasked.fa
  --variant 5270-S102_S5_trimmedaligned_unique_fixed.bam.sorted.bam_output.vcf
  --variant 5270-S100_S4_trimmedaligned_unique_fixed.bam.sorted.bam_output.vcf
-O combined.vcf

## Joint Genotyping of combine gVCF

for filename in *output.raw.snps.indels.g.vcf; do name=`ls $filename
  | cut -d"." -f1` java -jar
  ./../programs/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar GenotypeGVCFs -
  R revisedAssemblyUnmasked.fa --variant combined.vcf -o full_cohort.vcf;
 done

