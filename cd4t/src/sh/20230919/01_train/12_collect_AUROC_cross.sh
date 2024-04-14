#!/bin/bash

OUT=./cd4t/resources/trained/03/binary_v1
OUT_F=${OUT}/AUROC/auroc.summary.cross.v1.txt

rm -f ${OUT_F}

for phen in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
do
  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}

  for phen2 in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
  do
    # example
    # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
    in_sample2=$(basename ${phen2} .phen.gz)
    phenotype2=${OUT}/${phen2}

    if [ ! -e ${OUT_F} ]; then
      cat ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt | head -n 1 | awk -F"\t" 'BEGIN{OFS="\t"}{print "model", "truth", $0}' > ${OUT_F}
    fi
      cat ${OUT}/AUROC/each/cross/model_${in_sample}__truth_${in_sample2}.txt | tail -n +2 | awk -F"\t" -v smpl=${in_sample} -v truth=${in_sample2} 'BEGIN{OFS="\t"}{print smpl, truth, $0}' >> ${OUT_F}

  done
done