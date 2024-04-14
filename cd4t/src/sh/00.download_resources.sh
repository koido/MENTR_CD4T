#!/bin/bash

wget https://www.encodeproject.org/files/GRCh38_no_alt_analysis_set_GCA_000001405.15/@@download/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz -P ./resources

mkdir -p resources
cd resources

gunzip GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz

cd - 1> /dev/null 2>&1
