#!/bin/sh

# fill GT values and 
# conda stack pixy_env and bcftools_env

# define arguments passed as 'file'
file=$@

# alert the user if input is not supplied
if [ $# == 0 ]
then
	echo -e ">>>>>ERROR>>>>>
	Please provide input like so: ./this_script *.vcf.gz"
fi

for file in ${file[@]}
do

	# define output file name and population name
	output_file=${file/.vcf.gz/_GTfilled.vcf.gz}
	pop_name=${file/.vcf.gz/}
	
	# and output directory
	out_dir=${file/.vcf.gz/_pixy}
	
	# and sample ID file
	sample_IDs=${file/.vcf.gz/.txt}
	
	# fille GT values
	bcftools +setGT $file -- \
	-t "." \
	-n "0" | \
	bcftools view -O z -o $output_file
	
	tabix $output_file
	
	# Claude contribution
	# write sample IDs to temp file, then add population column
	bcftools query -l $output_file > ${sample_IDs}.tmp
	
	while IFS= read -r sample; do
		if [[ "$sample" == *"P3_wnv"* ]]; then
			echo -e "${sample}\tP3_wnv"
		else
			echo -e "${sample}\t${pop_name}"
		fi
	done < ${sample_IDs}.tmp > $sample_IDs
	
	rm ${sample_IDs}.tmp
	# end Claude contribution
	
	# run pixy
	pixy --stats fst \
	--vcf $output_file \
	--populations $sample_IDs \
	--window_size 10287 \
	--n_cores 2 \
	--output_folder $out_dir \
	--bypass_invariant_check \
	--fst_type hudson

	echo -e "Completed: $file"

done

# tell the user the script is done
echo -e "Done"



