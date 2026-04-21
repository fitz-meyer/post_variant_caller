#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=8:00:00
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --job-name=nf-batch
#SBATCH --mail-user=eafitz@colostate.edu
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND
#SBATCH --output=%x.%j.log # gives slurm.ID.log

module load miniforge # for conda
conda activate variantID_env  # for nextflow

# make a parseable log if run in batch mode
if [[ ! -t 1 ]]
then
    export NXF_ANSI_LOG=false
fi

# full command
cmd="./snpgenie.pl --vcfformat=4 --snpreport=./merge_20260330.vcf --fastafile=./KR868734.1.fasta --gtffile=./KR868734.1.gtf --outdir=./snpGenie_20260330"
echo $cmd
eval $cmd
