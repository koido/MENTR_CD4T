#!/usr/bin/zsh

mkdir ${PWD}/cd4t/mutgen/v3/round1_pair/each

while read line
do

  tmpCAGEID=`echo ${line} | awk -F' ' '{print $5}'`
  uniq_name=`echo ${line} | awk -F' ' '{print $1"_"$2"_"$3"_"$4"_"$5}' | sed -e "s/:/--/g"`

  out_dir=${PWD}/cd4t/mutgen/v3/round1_pair/${uniq_name}

  mv ${out_dir} ${PWD}/cd4t/mutgen/v3/round1_pair/each/

done < ${PWD}/cd4t/resources/20230919_mutgen/mutgen_round1.n802.biallelic_pair.uniq.txt

cd ${PWD}/cd4t/mutgen/v3/round1_pair
tar cfz each.tar.gz each --remove-files
cd -