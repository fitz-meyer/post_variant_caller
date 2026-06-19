# post_variant_caller
Scripts used for file manipulation and analysis after variant caller (LoFreq) pipeline. <br>
<br>
<br>
merge_diversity_metrics.R - generate one dataframe containing all diversity metrics - richness (SNVs/LVs), shannon's, rate of fixation, dn.ds, pi, etc. - for plotting and downstream analyses. <br>
<br>
variant_summary_analyses.R - manipulate variant_summary.xlsx file produced by variant caller pipeline. <br>
<br>
downsample_pairedEnd.sh - downsample paired fastq files with seqtk. <br>
<br>
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
^ this one does not work with SNPGenie - SNPGenie only expects DP:AD, FST calculations with Pixy require GT and AF <br>
<br>
merge_VCFs_for_input_pixy.sh - generates merged GTDPADAF VCF files for each sample type within each condition for divergence/FST calculations between condition/sample type populations and input population <br>
<br>
vcf_reformat_PY.sh - calls make_vcf_format_sample_cols_DPAD(AF).py to reformat all vcf files in working directory <br>
^ requires bcftools for bgzip, and python
<br>
```ml python/3.10.2``` <br>
```conda activate bcftools_env``` <br>
```./vcf_reformat_PY.sh``` <br>
<br>
make_vcf_format_sample scripts must be run prior to indexing: <br>
```for F in *.vcf.gz ; do   tabix -f -p vcf ${F}  ; done``` <br>
merging: <br>
```bcftools merge -o merged.vcf *FORSAM.vcf.gz``` <br>
and finally running intended analysis (SNPGenie, shannon's, FST) <br>
<br>
run_SNPGenie.sh - runs SNPGenie on reformatted merged vcf files via sbatch <br>
^ edit to specify input file, output directory, and paths to snpgenie.pl and reference files <br>
```sbatch run_SNPGenie.sh``` <br>
<br>
fillGT_runFST.sh - fills missing GT INFO with '0's' (assumes even coverage), generates sample ID text files with population information for pixy, and runs pixy --stats to calculate hudson's FST. <br>
```conda activate bcftools_env``` <br>
```conda activate --stack pixy_env``` <br>
```./fillGT_runFST.sh *.vcf.gz```<br>
<br>




