# post_variant_caller
scripts used for file manipulation and analysis after variant caller (LoFreq) pipeline <br>
<br>
downsample_BAM.sh - has now been incorporated directly into the variant caller pipeline and does not need to be called separately. <br>
<br>
run_SNPGenie.sh - runs SNPGenie on reformatted merged vcf files via sbatch <br>
<br>
vcf_reformat_PY.sh - calls make_vcf_format_sample_cols_DPAD(AF).py to reformat all vcf files in working directory 
<br>
make_vcf_format_sample_cols_DPAD.py - extracts DP and AD values from INFO column and reformats LoFreq vcf files (.bam.snv.vcf) to contain FORMAT and SAMPLE columns <br>
<br>
make_vcf_format_sample_cols_DPADAF.py - same as above but also extracts AF values

