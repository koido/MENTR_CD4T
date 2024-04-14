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

CMN="${OUT_CMN}/cage_peak_"

# Aggregate results
window=100000
OUT=${LARGE_DIR}/mutgen_cmn/cage_peak_seqEffects.peak_window_${window}.reduced_wo_strand.txt
rm -f ${OUT} ${OUT}.gz

for i in `seq 0 135`
do
  i_cat=`printf %03d ${i}`
  IN=${CMN}${i_cat}_seqEffects.peak_window_${window}.reduced_wo_strand.txt.gz
  zcat ${IN} >> ${OUT}
done
gzip ${OUT}
