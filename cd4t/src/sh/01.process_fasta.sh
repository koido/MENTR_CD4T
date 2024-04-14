#!/bin/bash

cd resources

# Keep only chr1-22, X, Y and rename header simply
cat GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta | \
    awk '{
        if ($0 ~ /^>chr([1-9]|1[0-9]|2[0-2]|X|Y|M) /) {
            split($0, array, " ");
            if(array[1] == ">chrM"){
            exit;
            }
            print array[1];
        } else {
            print $0;
        }
    }' > GRCh38_no_alt_analysis_set_GCA_000001405.15.simple.fasta

samtools faidx GRCh38_no_alt_analysis_set_GCA_000001405.15.simple.fasta

cd - 1> /dev/null 2>&1