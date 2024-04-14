#!/bin/bash

OUT=./cd4t/resources/trained/03/binary_v1
# base file
OUT_B=${OUT}/AUROC/auroc.summary.cross.v1.txt
# output file
OUT_F=${OUT}/AUROC/auroc.summary.cross.v2.txt

rm -f ${OUT_F}

function collect {

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

  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}

  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample2=$(basename ${phen2} .phen.gz)
  phenotype2=${OUT}/${phen2}

  if [ ! -e ${OUT_F} ]; then
    cp ${OUT_B} ${OUT_F}
  fi
  cat ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt | tail -n +2 | awk -F"\t" -v smpl=${in_sample} -v truth=${in_sample2} 'BEGIN{OFS="\t"}{print smpl, truth, $0}' >> ${OUT_F}

}

for tmp_phen in F12_vs_F17.phen.gz F13_vs_F17.phen.gz F14_vs_F17.phen.gz F15_vs_F17.phen.gz
do
  collect F11_vs_F17.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  collect F11_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  collect F11_F17_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F12_vs_F21.phen.gz F13_vs_F21.phen.gz F14_vs_F21.phen.gz F15_vs_F21.phen.gz
do
  collect F17_vs_F21.phen.gz ${tmp_phen}
done

for tmp_phen in F2_vs_F34.phen.gz F3_vs_F34.phen.gz F4_vs_F34.phen.gz F5_vs_F34.phen.gz F23_vs_F34.phen.gz F24_vs_F34.phen.gz F25_vs_F34.phen.gz F26_vs_F34.phen.gz F27_vs_F34.phen.gz F28_vs_F34.phen.gz
do
  collect F1_vs_F34.phen.gz ${tmp_phen}
done



