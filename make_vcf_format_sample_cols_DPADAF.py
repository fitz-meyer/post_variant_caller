#!/usr/bin/env python3
import sys

desired_header = """##fileformat=VCFv4.0
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20260217
##source=lofreq call --no-default-filter -f /projects/eafitz@colostate.edu/temptr_study/viral-variant-caller-stglab/refseq//KR868734.1.fasta --no-default-filter -r KR868734.1:1-643 -o /scratch/alpine/eafitz@colostate.edu/.tmp/lofreq2_call_parallel2jrmpet9/0.vcf.gz ex10_r2_30dtr12_12dpi_body1.KR868734.1.bam
##reference=/projects/eafitz@colostate.edu/temptr_study/viral-variant-caller-stglab/refseq//KR868734.1.fasta
##INFO=<ID=DP,Number=1,Type=Integer,Description="Raw Depth">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
##INFO=<ID=SB,Number=4,Type=Integer,Description="Phred-scaled strand bias at this position">
##INFO=<ID=DP4,Number=4,Type=Integer,Description="Counts for ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=INDEL,Number=0,Type=Flag,Description="Indicates that the variant is an INDEL.">
##INFO=<ID=CONSVAR,Number=0,Type=Flag,Description="Indicates that the variant is a consensus variant (as opposed to a low frequency variant).">
##INFO=<ID=HRUN,Number=1,Type=Integer,Description="Homopolymer length to the right of report indel position">
##FILTER=<ID=min_snvqual_52,Description="Minimum SNV Quality (Phred) 52">
##FILTER=<ID=min_indelqual_20,Description="Minimum Indel Quality (Phred) 20">
##FILTER=<ID=min_snvqual_65,Description="Minimum SNV Quality (Phred) 65">
##FILTER=<ID=min_indelqual_20,Description="Minimum Indel Quality (Phred) 20">
##FILTER=<ID=min_af_0.030000,Description="Minimum allele frequency 0.030000">
##FILTER=<ID=min_dp_40,Description="Minimum Coverage 40">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Raw Allele Counts">
##FORMAT=<ID=AF,Number=A,Type=Float,Description="Alt Allele Frequency">"""

print(desired_header)

fname = sys.argv[1]
with open(fname) as infile:
    need_header = True
    for line in infile:
        if line.startswith('##'):
            continue
        elif need_header and line.startswith('#CHROM'):
            sample_name = fname.split('.')[0]
            header_fields = line.split("\t")
            print(f"{line.strip()}\tFORMAT\t{sample_name}")
            need_header = False
            continue
        elif line.startswith('#'): 
            print(line,end="")
        else:
            fields = line.strip().split()
            info = fields[7]
            data = info.split(";")
            DP = None
            DP4 = None
            AF = None	# added
            AD = None
            #print(line.strip(), end="\t")
            #print("DP:AD",end="\t")
            for datum in data:
                if datum.startswith('DP'):
                    key,value = datum.split('=')
                    if key == 'DP':
                        DP = value
                    elif key == 'DP4':
                        DP4 = value
                elif datum.startswith('AF='):  # added
                	AF = datum.split('=')[1]   # added

            # to make testing more readable
            if False: # set to True to use placeholders
                placeholders=["--"] * 7
                print(*placeholders, sep="\t", end="\t")
            else:
                print(*fields, sep="\t", end="\t")


            dp4_vals = list(map(int, DP4.split(',')))
            val1 = dp4_vals[0] + dp4_vals[1]
            val2 = dp4_vals[2] + dp4_vals[3]
            AD = val1,val2

            print("DP:AD:AF", sep="\t", end="\t")	# added
            print(f"{DP}:{AD[0]},{AD[1]}:{AF}")	# added
        

