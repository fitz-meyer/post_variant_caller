#/bin/sh
#Date: 2/03/26
#Author: Emily Fitzmeyer but also google AI - I am just another slop drone
#Activate seqtk_env before running
#Run in directory with files you want to downsample like so: ./thisScript.sh

fqdir=...
for r1 in `ls *_R1_ifiltered.fastq.gz`; do
    r2=${r1/_R1_ifiltered.fastq.gz/_R2_ifiltered.fastq.gz}
	
    # Generate the output filenames 
    R1_SUBAMPLED=${r1/_R1_ifiltered.fastq.gz/_R1_subsampled.fastq.gz}
    R2_SUBAMPLED=${r2/_R2_ifiltered.fastq.gz/_R2_subsampled.fastq.gz}

    # Ensure the corresponding R2 file exists
    if [[ -f $r2 ]] ; then
        echo "Subsampling $r1 and $r2"

        # Subsample R1 file
        # The output is piped to gzip to keep it compressed
        seqtk sample -s 100 $r1 0.1 | gzip > $R1_SUBAMPLED

        # Subsample R2 file using the SAME seed
        seqtk sample -s 100 $r2 0.1 | gzip > $R2_SUBAMPLED

        echo "Done with $r1 pair."
    else
        echo "Warning: Corresponding R2 file not found for $r1"
    fi
    
done

mkdir subsampled_fastq
mv *subsampled.fastq.gz subsampled_fastq/

echo "All subsampling complete."
