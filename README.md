# post_variant_caller
scripts used for file manipulation and analysis after variant caller (LoFreq) pipeline <br>
<br>
<br>
downsample_pairedEnd.sh - downsample paired fastq files with seqtk. <br>
extract_AF_pairedVCFs.sh - extract allele frequency, SNV genome position, and ALT and REF bases from paired VCF files. Compare AF between resequenced file pairs to determine AF threshold to account for batch effects. <br>
<br>
downsample_BAM.sh - has now been incorporated directly into the variant caller pipeline and does not need to be called separately. <br>
<br>
make_vcf_format_sample_cols_DPAD.py - extracts DP and AD values from INFO column and reformats LoFreq vcf files (.bam.snv.vcf) to contain FORMAT and SAMPLE columns for dN/dS calculations with SNPGenie. <br>
<br>
make_vcf_format_sample_cols_DPADAF.py - same as above but also extracts AF values <br>
^ this one does not work with SNPGenie - SNPGenie only expects DP:AD, Shannon's index calculations require AF <br>
<br>
make_vcf_format_sample_cols_GTDPADAF.py - same as above but also extracts GT values <br>
^ this one does not work with SNPGenie - FST calculations with Pixy require GT and AF <br>
<br>
merge_VCFs_for_pixy.sh - generates merged GTDPADAF VCF files for each sample type within each condition for divergence/FST calculations <br>
<br>
vcf_reformat_PY.sh - calls make_vcf_format_sample_cols_DPAD(AF).py to reformat all vcf files in working directory <br>
^ requires bcftools for bgzip, and python
<br>
```ml python/3.10.2``` <br>
```./vcf_reformat_PY.sh```<br>
<br>
run_SNPGenie.sh - runs SNPGenie on reformatted merged vcf files via sbatch <br>
^ edit to specify input file, output directory, and paths to snpgenie.pl and reference files <br>
<br>
<br>
make_vcf_format_sample scripts must be run prior to indexing: <br>
```for F in *.vcf.gz ; do   tabix -f -p vcf ${F}  ; done``` <br>
merging: <br>
```bcftools merge -o merged.vcf *FORSAM.vcf.gz``` <br>
and finally running intended analysis (SNPGenie): <br>
```sbatch run_SNPGenie.sh``` <br>
<br>
<br>
before running pixy (using GTDPADAF merge files) - invariant sites must be filled with '0' for GT: <br>
```bcftools +setGT test_merged.vcf.gz -- \
  -t "." \
  -n "0" | \
  bcftools view -O z -o test_filled.vcf.gz``` <br>
and indexed<br>
```tabix test_filled.vcf.gz```<br>
<br>
```pixy --stats fst \
--vcf test_filled.vcf.gz \
--populations sample_IDs.txt \
--window_size 10287 \
--n_cores 2 \
--output_folder pixy_output \
--bypass_invariant_check \
--fst_type hudson```


