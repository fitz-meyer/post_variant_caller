#/bin/sh

bcftools merge -o 22dtr0_ST.vcf *22dtr0*bod*FORSAM.vcf.gz *22dtr0*sal*FORSAM.vcf.gz

bcftools merge -o 22dtr12_ST.vcf *22dtr12*bod*FORSAM.vcf.gz *22dtr12*sal*FORSAM.vcf.gz

bcftools merge -o 26dtr0_ST.vcf *26dtr0*bod*FORSAM.vcf.gz *26dtr0*sal*FORSAM.vcf.gz

bcftools merge -o 26dtr12_ST.vcf *26dtr12*bod*FORSAM.vcf.gz *26dtr12*sal*FORSAM.vcf.gz

bcftools merge -o 30dtr0_ST.vcf *30dtr0*bod*FORSAM.vcf.gz *30dtr0*sal*FORSAM.vcf.gz

bcftools merge -o 30dtr12_ST.vcf *30dtr12*bod*FORSAM.vcf.gz *30dtr12*sal*FORSAM.vcf.gz

