#!/bin/bash
#$ -l rt_G.small=1
#$ -l h_rt=12:00:00
#$ -N ComputeEff
#$ -o ${LARGE_DIR}/mutgen_cmn/cage_peak_split/ComputeEff.sge.log
#$ -e ${LARGE_DIR}/mutgen_cmn/cage_peak_split/ComputeEff.sge.log
#$ -cwd
#$ -t 1-136
#$ -V

echo -e "JOB_ID ${JOB_ID}"

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

# Split cage_peak.txt file for calculating common sequence effects using a lot of GPUs
CMN="${OUT_CMN}/cage_peak_"

# Calculate epigenetic features using DeepSEA Beluga.
window=100000
i=$((${SGE_TASK_ID} - 1))
i_cat=`printf %03d ${i}`

python -u ${mentr_cstm_dir}/cd4t/src/py3/seq2chrom_ref.py \
  --output ${CMN}${i_cat}_seqEffects \
  --cuda \
  --peak_file ${CMN}${i_cat}.gz \
  --ref ${in_fa} \
  --model ${deepsea} \
  --peak_window_size ${window} 1> ${CMN}${i_cat}_seqEffects_100kb.std.log 2> ${CMN}${i_cat}_seqEffects_100kb.err.log
