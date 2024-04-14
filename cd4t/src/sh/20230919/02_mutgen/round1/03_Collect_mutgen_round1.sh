#!/usr/bin/zsh

out_f=${PWD}/cd4t/mutgen/v3/round1_pair/all_qcd_res.txt
rm -f ${out_f} ${out_f}.gz

while read line
do

  tmpCAGEID=`echo ${line} | awk -F' ' '{print $5}'`
  uniq_name=`echo ${line} | awk -F' ' '{print $1"_"$2"_"$3"_"$4"_"$5}' | sed -e "s/:/--/g"`

  out_dir=${PWD}/cd4t/mutgen/v3/round1_pair/${uniq_name}

  if [ ! -e ${out_f} ]; then
    zcat ${out_dir}/output/all_qcd_res.txt.gz > ${out_f}
  else
    zcat ${out_dir}/output/all_qcd_res.txt.gz | tail -n +2 >> ${out_f}
  fi

done < ${PWD}/cd4t/resources/20230919_mutgen/mutgen_round1.n802.biallelic_pair.uniq.txt

gzip -f ${out_f}