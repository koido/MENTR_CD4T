#!/bin/bash
#$ -l rt_C.large=1
#$ -l h_rt=24:00:00
#$ -N train_MENTR
#$ -o ./cd4t/resources/trained/03/binary_v1/train_MENTR.sge.log
#$ -e ./cd4t/resources/trained/03/binary_v1/train_MENTR.sge.log
#$ -cwd
#$ -V

# example to run
# qsub -g XX 23_02_train_MENTR_2class_test.sh 8_vs_11 8_vs_11.phen.gz

set -eu

OUT=./cd4t/resources/trained/03/binary_v1
mkdir -p ${OUT}

in_sample=$1
phenotype=$2
LARGE_DIR=$3
IN_PATH=${LARGE_DIR}/mutgen_cmn/count

#   --num_round 3 --verbose \
python -u ./cd4t/src/py3/train_chrom2exp_model_manual_binary_y.v2.py \
  --y ${phenotype} \
  --out_dir ${OUT} \
  --infile_dir ${IN_PATH} \
  --sample_name ${in_sample} \
  --gbt --evalauc \
  --threads 40 1> ${OUT}/${in_sample}.MENTR.train.log 2>&1
