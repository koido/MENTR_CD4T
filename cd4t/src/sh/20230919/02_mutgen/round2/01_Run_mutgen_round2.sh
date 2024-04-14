#!/usr/bin/zsh

mkdir -p ${PWD}/cd4t/mutgen/v3/round2_pair

#conda activate mentr_cd4t

# common args
deepsea=${PWD}/resources/deepsea.beluga.2002.cpu
ref_fa=${PWD}/resources/GRCh38_no_alt_analysis_set_GCA_000001405.15.simple.fasta
ml_dir=${PWD}/cd4t/resources/trained/03/binary_v1
n_cpu=10
model_list_log=${PWD}/cd4t/resources/trained/03/binary_v1/modellist_xgb.txt
calib_modelList=${PWD}/cd4t/resources/trained/03/binary_v1/modellist_calib.txt
peak_info=${PWD}/cd4t/resources/20230919.uniq.midpoint.id.bed.input.txt.gz
midpoint_bed=${PWD}/cd4t/resources/sortbed4mutgen.midpoint.v3.bed

# Read file is tab-delimited with 5 columns.
# For each line,
## write col1-col4 in ${in_f}
## Use col5 as ${tmpCAGEID}
## Use col1-col5 as unique name for output directory
while read line
do
  
  tmpCAGEID=`echo ${line} | awk -F' ' '{print $5}'`
  uniq_name=`echo ${line} | awk -F' ' '{print $1"_"$2"_"$3"_"$4"_"$5}' | sed -e "s/:/--/g"`

  out_dir=${PWD}/cd4t/mutgen/v3/round2_pair/${uniq_name}
  mkdir -p ${out_dir}
  #rm -Rf ${out_dir}/input
  #rm -Rf ${out_dir}/output

  log=${out_dir}/mutgen.log

  in_f=${out_dir}/in_f.txt

  echo ${line} | \
    awk -F' ' '
      BEGIN{
        OFS="\t"
      }
      {
        print $1,$2,$3,$4
      }' > ${in_f}

  echo -e "bash ${PWD}/cd4t/bin/v3/quick.mutgen.sh \
    -i ${in_f} \
    -o ${out_dir} \
    -m ${deepsea} \
    -M ${ml_dir} \
    -f ${ref_fa} \
    -t ${n_cpu} \
    -b ${midpoint_bed} \
    -l ${model_list_log} \
    -q ${calib_modelList} \
    -p ${tmpCAGEID} \
    -P ${peak_info} 1> ${log} 2>&1" > ${out_dir}/tmp.mutgen.sh

  # run
  qsub -g XX \
    -l rt_G.small=1 \
    -l h_rt=1:00:00 \
    -N mutgen_pair \
    -o ${out_dir}/mutgen.sge.log \
    -e ${out_dir}/mutgen.sge.log \
   -cwd \
   -V \
   ${out_dir}/tmp.mutgen.sh

done < ${PWD}/cd4t/resources/20230919_mutgen/mutgen_round2.n14.biallelic_pair.uniq.txt