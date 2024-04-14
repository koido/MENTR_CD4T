#!/bin/bash

set -eu

LARGE_DIR=$1

IN_PATH=${LARGE_DIR}/mutgen_cmn/count

OUT=./cd4t/resources/trained/03/binary_v1
mkdir -p ${OUT}

for phen in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
do
  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}

  echo -e "=== Calibrating on ${in_sample} dataset. ==="

  python -u ./cd4t/src/py3/calibrate_chrom2exp_logistic_model_manual_binary_y.py \
    --verbose \
    --y ${phenotype} \
    --infile_dir ${IN_PATH} \
    --xgb_res_path "${OUT}/gbtree_logistic_sample_name.${in_sample}_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc_type.{}.expr_pred.txt.gz" \
    --out_dir ${OUT} \
    --out_suffix "gbtree_logistic_sample_name.${in_sample}_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc" 1> ${OUT}/${in_sample}.MENTR.calibrate.log 2>&1
done