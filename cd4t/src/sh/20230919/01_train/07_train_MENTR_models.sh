#!/bin/bash

set -eu

LARGE_DIR=$1

CMN_DIR=./cd4t/resources/trained/03/binary_v1
SCRIPT=./cd4t/src/sh/train_MENTR_2class.sh

for phen in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
do
  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  phen_name=$(basename ${phen} .phen.gz)

  log=${CMN_DIR}/${phen_name}.MENTR.train.slurm.log
  rm -f ${log}
  qsub -g XX \
    -o ${log} \
    -e ${log} \
    ${SCRIPT} ${phen_name} ${CMN_DIR}/${phen} ${LARGE_DIR}
done


