#/bin/sh

bcftools merge -o 22dtr0_BOD.vcf *22dtr0*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 22dtr0_LW.vcf *22dtr0*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 22dtr0_SAL.vcf *22dtr0*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz

bcftools merge -o 22dtr12_BOD.vcf *22dtr12*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 22dtr12_LW.vcf *22dtr12*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 22dtr12_SAL.vcf *22dtr12*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz

bcftools merge -o 26dtr0_BOD.vcf *26dtr0*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 26dtr0_LW.vcf *26dtr0*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 26dtr0_SAL.vcf *26dtr0*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz

bcftools merge -o 26dtr12_BOD.vcf *26dtr12*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 26dtr12_LW.vcf *26dtr12*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 26dtr12_SAL.vcf *26dtr12*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz

bcftools merge -o 30dtr0_BOD.vcf *30dtr0*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 30dtr0_LW.vcf *30dtr0*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 30dtr0_SAL.vcf *30dtr0*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz

bcftools merge -o 30dtr12_BOD.vcf *30dtr12*bod*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 30dtr12_LW.vcf *30dtr12*leg*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz
bcftools merge -o 30dtr12_SAL.vcf *30dtr12*sal*FORSAM.vcf.gz *P3_wnv*FORSAM.vcf.gz


