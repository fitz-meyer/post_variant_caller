#/bin/sh
#Date: 3/30/26
#Author: Emily Fitzmeyer

# define arguments passed as 'file_base'
file_base=$@

# alert the user if input is not supplied
if [ $# == 0 ]
then
	echo -e "true_barcodes>>>>> ERROR>>>>>
	Please provide input like so: ./this_script file.vcf"
fi

for file_base in ${file_base[@]}
do

	# define output file name
	output_file=${file_base/.KR868734.1.bam.snv.vcf/_FORSAM.vcf}
	
	python make_vcf_format_sample_cols.py $file_base > $output_file
	
	bgzip $output_file

	echo -e "Completed sample: $file_base"

done

# tell the user the script is done
echo -e "Done"