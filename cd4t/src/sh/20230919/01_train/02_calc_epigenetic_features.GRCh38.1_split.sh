#!/bin/bash

set -eu

LARGE_DIR=$1

# Direcotry for MENTR customized tool
mentr_cstm_dir=.

# input fasta file (see src/sh/cd4t/00.download_resources.sh)
in_fa=${mentr_cstm_dir}/resources/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta

# deepsea path (need to copy from local)
deepsea=${mentr_cstm_dir}/resources/deepsea.beluga.2002.cpu

# output directory prefix
OUT_CMN=${LARGE_DIR}/mutgen_cmn/cage_peak_split

# peak file
## col1: ID (chr1:XXX-XXX)
## col2: midpoint
in_peak=${mentr_cstm_dir}/cd4t/resources/20230919.uniq.midpoint.id.bed.input.txt.gz

# Split cage_peak.txt file for calculating common sequence effects using a lot of GPUs
mkdir -p ${OUT_CMN}
CMN="${OUT_CMN}/cage_peak_"
zcat ${in_peak} | split -l 5000 -a 3 -d - ${CMN}
for i in `ls -1d ${CMN}*`
do
  gzip ${i}
done
