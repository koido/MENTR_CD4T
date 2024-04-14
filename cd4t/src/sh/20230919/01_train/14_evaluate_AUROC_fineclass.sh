#!/bin/bash

set -eu

OUT=./cd4t/resources/trained/03/binary_v1
mkdir -p ${OUT}/AUROC

OUT2=./cd4t/resources/trained/03/binary_v1/sub

function run_eval {

  # if each variable is not set, then exit
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <phen> <phen2>"
    exit 1
  fi

  # if not defined variable exists, then exit
  if [ -z ${OUT+x} ]; then echo "OUT is unset"; exit 1; fi

  # args
  ## model phenotype
  phen=$1
  ## evaluate phenotype
  phen2=$2

  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}

  in_sample2=$(basename ${phen2} .phen.gz)
  phenotype2=${OUT2}/${phen2}

  # If ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt exist then skip
  if [ -e ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt ]; then
    echo "Skip: ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt"
    continue
  fi

  Rscript ./cd4t/src/R/calc_pred_accuracy_allowmissingExpr_cross.more_free.R \
    --pred_file ${OUT}/gbtree_logistic_sample_name.${in_sample}_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc_type.test_expr_pred_c.txt.gz \
    --truth_phen ${phenotype2} \
    --col_types ciccdd \
    --out_dir_cmn ${OUT}/AUROC \
    --out_name model_${in_sample}__truth_${in_sample2}.txt \
    --auroc
}

#for tmp_phen in xx
#do
#  run_eval F2_vs_F3.phen.gz ${tmp_phen}
#done

#for tmp_phen in xx
#do
#  run_eval F2_vs_F3.phen.gz ${tmp_phen}
#done

#for tmp_phen in xx
#do
#  run_eval F9_vs_F10.phen.gz ${tmp_phen}
#done

for tmp_phen in F12_vs_F17.phen.gz F13_vs_F17.phen.gz F14_vs_F17.phen.gz F15_vs_F17.phen.gz
do
  run_eval F11_vs_F17.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  run_eval F11_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  run_eval F11_F17_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  run_eval F17_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F2_vs_F34.phen.gz F3_vs_F34.phen.gz F4_vs_F34.phen.gz F5_vs_F34.phen.gz F23_vs_F34.phen.gz F24_vs_F34.phen.gz F25_vs_F34.phen.gz F26_vs_F34.phen.gz F27_vs_F34.phen.gz F28_vs_F34.phen.gz
do
  run_eval F1_vs_F34.phen.gz ${tmp_phen}
done






