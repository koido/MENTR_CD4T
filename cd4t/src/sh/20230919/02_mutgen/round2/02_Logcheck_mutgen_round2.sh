#!/usr/bin/zsh

verbose=0

rerun=$1
# if second arg exist, set it to verbose
if [ $# -eq 2 ]; then
  verbose=$2
fi

# if rerun is empty raise error message
if [ -z ${rerun} ]; then
  echo "Error: rerun is empty. If you want to rerun, please set 1 to rerun. If not, please set 0 to rerun."
  exit 1
fi

while read line
do

  err_flg=0

  tmpCAGEID=`echo ${line} | awk -F' ' '{print $5}'`
  uniq_name=`echo ${line} | awk -F' ' '{print $1"_"$2"_"$3"_"$4"_"$5}' | sed -e "s/:/--/g"`

  out_dir=${PWD}/cd4t/mutgen/v3/round2_pair/${uniq_name}
  log=${out_dir}/mutgen.log
  sge_log=${out_dir}/mutgen.sge.log

  # If ${sge_log} is not empty, raise error message
  if [ -s ${sge_log} ]; then
    if [ ${verbose} -eq 1 ]; then
      echo "Error: ${sge_log} is not empty."
    fi
    #echo "Error: ${sge_log} is not empty."
    err_flg=1
  fi

  # If the last line of ${log} is not "./cd4t/bin/v3", raise error message
  if [ `tail -n 1 ${log} | grep -c "./cd4t/bin/v3"` -eq 0 ]; then
    if [ ${verbose} -eq 1 ]; then
      echo "Error: ${log} is not finished."
    fi
    #echo "Error: ${log} is not finished."
    err_flg=1
  fi

  # If final output file is not exist, raise error message
  if [ ! -e ${out_dir}/output/all_qcd_res.txt.gz ]; then
    if [ ${verbose} -eq 1 ]; then
      echo "Error: ${out_dir}/output/all_qcd_res.txt.gz is not exist."
    fi
    #echo "Error: ${out_dir}/output/all_qcd_res.txt.gz is not exist."
    err_flg=1
  else
    # If final output file has zero rows, raise error message
    if [ `zcat ${out_dir}/output/all_qcd_res.txt.gz | wc -l` -eq 0 ]; then
      if [ ${verbose} -eq 1 ]; then
        echo "Error: ${out_dir}/output/all_qcd_res.txt.gz has zero rows."
      fi
      #echo "Error: ${out_dir}/output/all_qcd_res.txt.gz has zero rows."
      err_flg=1
    fi
  fi

  if [ ${err_flg} -eq 1 ]; then
    echo "Found some error(s) in ${out_dir}"
  fi

  if [ ${err_flg} -eq 1 ] && [ ${rerun} -eq 1 ]; then
      qsub -g XX \
        -l rt_G.small=1 \
        -l h_rt=1:00:00 \
        -N mutgen_pair \
        -o ${out_dir}/mutgen.sge.log \
        -e ${out_dir}/mutgen.sge.log \
        -cwd \
        -V \
        ${out_dir}/tmp.mutgen.sh
  fi

done < ${PWD}/cd4t/resources/20230919_mutgen/mutgen_round2.n14.biallelic_pair.uniq.txt