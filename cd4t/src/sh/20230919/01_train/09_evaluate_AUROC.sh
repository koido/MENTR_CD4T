#!/bin/bash

set -eu

OUT=./cd4t/resources/trained/03/binary_v1
mkdir -p ${OUT}/AUROC

for phen in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
do
  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}

  Rscript ./cd4t/src/R/calc_pred_accuracy_allowmissingExpr.R \
    --input_file ${OUT}/gbtree_logistic_sample_name.${in_sample}_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc_type.test_expr_pred_c.txt.gz \
    --col_types ciccdd \
    --out_dir_cmn ${OUT}/AUROC \
    --out_name ${in_sample}.txt \
    --auroc
done