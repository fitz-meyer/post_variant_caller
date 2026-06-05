#/bin/sh
#Date: 6/04/26
#Author: Emily Fitzmeyer 
#Activate bcftools_env before running
#Run in directory with files you want to extract info from like so: ./thisScript.sh

fqdir=...
for file in `ls *.vcf.gz`; do
    reseqFile=${file/.KR868734.1.bam.snv.vcf.gz/_reseq.KR868734.1.bam.snv.vcf.gz}
	
    # Generate the output filenames 
    AF_info=${file/.KR868734.1.bam.snv.vcf.gz/.txt}
    AF_info_reseq=${reseqFile/.KR868734.1.bam.snv.vcf.gz/.txt}
    merged=${file/.KR868734.1.bam.snv.vcf.gz/.csv}

    # Ensure the corresponding RESEQ file exists
    if [[ -f $reseqFile ]] ; then
        echo "Extracting AF INFO from $file and $reseqFile"

        # Get INFO from file
        bcftools query -f '%POS %REF %ALT %INFO/AF' $file > $AF_info

        # Get INFO from RESEQ file
        bcftools query -f '%POS %REF %ALT %INFO/AF' $reseqFile >> $AF_info_reseq
        
        # merge files as CSV
        paste $AF_info $AF_info_reseq > $merged

        echo "Done with $file pair."
    else
        echo "Warning: Corresponding RESEQ file not found for $file"
    fi
    
done

mkdir AF_info_files
mv *.csv AF_info_files/
rm *.txt

echo "Done :D"








