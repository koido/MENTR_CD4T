#!/bin/bash
#$ -l rt_M.large=1
#$ -l h_rt=36:00:00
#$ -N MakeHDF5
#$ -o ${LARGE_DIR}/mutgen_cmn/count/make_hdf5.sge.log
#$ -e ${LARGE_DIR}/mutgen_cmn/count/make_hdf5.sge.log
#$ -cwd
#$ -V

set -eu

LARGE_DIR=$1

# Direcotry for MENTR customized tool
mentr_cstm_dir=.

# peak file (w/o header)
## col1: clusterID (chr1:XXX-XXX)
## col2: midpoint
peakFile=${mentr_cstm_dir}/cd4t/resources/20230919.uniq.midpoint.id.bed.input.txt.gz

# Cluster file (w/o header in this custom version)
## col1: clusterID
## col2: type (promoter or enhancer)
clusterFile=${mentr_cstm_dir}/cd4t/resources/20230919.uniq.midpoint.id.bed.input.clusterfile.txt.gz

# pre-calculated epigenetic data from ref genome (w/o header)
chromFile=${LARGE_DIR}/mutgen_cmn/cage_peak_seqEffects.peak_window_100000.reduced_wo_strand.txt.gz

# output directory
out_dir=${LARGE_DIR}/mutgen_cmn/count
mkdir -p ${out_dir}

# Make hdf5 file for training MENTR
python -u ${mentr_cstm_dir}/cd4t/src/py3/seq2chrom_res2hdf5_nocount.py \
  --output ${out_dir}/ \
  --chromFile ${chromFile} \
  --peakFile ${peakFile} \
  --clusterFile ${clusterFile}
