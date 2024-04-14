#!/bin/bash

OUT=./cd4t/resources/trained/03/binary_v1

rm -f ${OUT}/AUROC/auroc.summary.v1.txt

for phen in F2_vs_F3.phen.gz F9_vs_F10.phen.gz F11_vs_F17.phen.gz F11_vs_F21.phen.gz F11_F17_vs_F21.phen.gz F17_vs_F21.phen.gz F1_vs_F34.phen.gz
do
  # example
  # 8_vs_10.phen.gz (phen): 8_vs_11 (phen_name)
  in_sample=$(basename ${phen} .phen.gz)
  phenotype=${OUT}/${phen}
  
  if [ ! -e ${OUT}/AUROC/auroc.summary.v1.txt ]; then
    cat ${OUT}/AUROC/each/${in_sample}.txt | head -n 1 | awk -F"\t" 'BEGIN{OFS="\t"}{print "sample", $0}' > ${OUT}/AUROC/auroc.summary.v1.txt
  fi
  cat ${OUT}/AUROC/each/${in_sample}.txt | tail -n +2 | awk -F"\t" -v smpl=${in_sample}  'BEGIN{OFS="\t"}{print smpl, $0}' >> ${OUT}/AUROC/auroc.summary.v1.txt
done