#/bin/sh
#Date: 3/22/26
#Author: Emily Fitzmeyer

# bam downsampling

touch seed_log.txt

fqdir=...
for x in `ls *.KR868734.1.bam`; do
        
    # Generate the output filenames 
    samp_dwn=${x/.KR868734.1.bam/_downsampled.bam}
    
    sampleID=${x/.KR868734.1.bam/ }
    
    # Check file exists
    if [[ -s $x ]]; then
        echo "Downsampling $sampleID"
        
        seed=$(echo $RANDOM)
        
        # Subsample 
		conda run -n bbmap_env reformat.sh in=$x out=$samp_dwn sampleseed=$seed samplereadstarget=400000 mappedonly=t -Xmx900m
        
        echo  "$sampleID" >> seed_log.txt
        echo  "$seed" >> seed_log.txt
        
        echo "Done with $sampleID."
    else
        echo "FUCKTANGULAR!"
    fi
    
done

