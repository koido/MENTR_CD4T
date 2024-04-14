#!/bin/bash
#
# quick.mutgen.sh
#   Run in silico mutagenesis with default parameters
#
#   Usage:
#     quick.mutgen.sh [-i input_file] [-o cmn_dir] ...
#       -i TEXT  input variant file [required]
#       -o TEXT  output dir [required]
#       -m TEXT  File of DeepSEA Beluga model (deepsea.beluga.2002.cpu)
#       -M TEXT  Directory for xgboost models
#       -f TEXT  File of Reference fasta
#       -t INT   Number of threads. [default:1]
#       -w INT   window size to find variant-CAGE_ID pairs [bp] [default:100000]
#       -b TEXT  midpoint bed file [required]
#                 col1: chr
#                 col2: start (midpoint - 1)
#                 col3: end (midpoint)
#                 col4: strand [+/-/N]
#                 col5: CAGE_peak_ID
#       -p TEXT  CAGE_ID list to find variant-CAGE_ID pairs. If many, please write IDs separated by semicolon [default: ALL CAGE IDs]
#       -l TEXT  xgboost logisit regression model file [required]
#       -q TEXT  calibrated model list file [required]
#       -P TEXT  peak info file [required]
#       -c       CPU mode
#       -h       Show help (this message)

# Move to MENTR/bin dir
cd `dirname $0`

# == utils ==
source ../../src/sh/utils.sh

# == arg parser ==

# init
# Only CPU mode
cpu=0
# Number of CPU
n_cpu=1
# window size [bp]; default is (Promoter TSS / Enhancer midpoint) +/- 100-kb) but you can change this parameter
window_n=100000
# CAGE ID list for evaluation
cage_list=ALL

# get
while getopts ":i:o:m:M:f:t:w:b:p:l:q:P:ch" optKey; do
  case "${optKey}" in
    i)
      in_f="${OPTARG}";;
    o)
      cmn_dir="${OPTARG}";;
    m)
      deepsea="${OPTARG}";;
    M)
      ml_dir="${OPTARG}";;
    f)
      ref_fa="${OPTARG}";;
    t)
      n_cpu="${OPTARG}";;
    w)
      window_n="${OPTARG}";;
    b)
      midpoint_bed="${OPTARG}";;
    p)
      cage_list="${OPTARG}";;
    l)
      model_list_log="${OPTARG}";;
    q)
      calib_modelList="${OPTARG}";;
    P)
      peak_info="${OPTARG}";;
    c)
      cpu=1;;
    h)
      help;;
    :)
      echo -e "Error: Undefined options were observed.\n"
      help;;
    \?)
      echo -e "Error: Undefined options were specified.\n"
      help;;
  esac
done

# required args
if [ -z "${in_f}" ]; then
  echo "Error: -i is required"
  help
fi
if [ -z "${cmn_dir}" ]; then
  echo "Error: -o is required"
  help
fi
if [ -z "${deepsea}" ]; then
  echo "Error: -m is required"
  help
fi
if [ -z "${ref_fa}" ]; then
  echo "Error: -f is required"
  help
fi
if [ -z "${midpoint_bed}" ]; then
  echo "Error: -b is required"
  help
fi
if [ -z "${model_list_log}" ]; then
  echo "Error: -l is required"
  help
fi
if [ -z "${calib_modelList}" ]; then
  echo "Error: -q is required"
  help
fi
if [ -z "${peak_info}" ]; then
  echo "Error: -P is required"
  help
fi
if [ -z "${ml_dir}" ]; then
  echo "Error: -M is required"
  help
fi

# INT check
int_chk ${n_cpu} "-t"
int_chk ${window_n} "-w"

if [ ${cage_list} != "ALL" ]; then
  original_midpoint_bed=${midpoint_bed}
  # time stamp for file name
  yymmddmmss=`date +%Y%m%d%H%M%S`_${RANDOM}${RANDOM}
  join -t$'\t' -1 5 \
    <(sort -t$'\t' -k5,5 ${midpoint_bed}) \
    <(echo ${cage_list} | sed -e "s/;/\n/g" | sort) | \
    awk -F"\t" 'BEGIN{OFS="\t"}{print $2,$3,$4,$5,$1}' > ${midpoint_bed}.${yymmddmmss}.tmp
  midpoint_bed=${midpoint_bed}.${yymmddmmss}.tmp
  echo -e "\nUse custom bed file (${midpoint_bed}) for finding variant-promoter/enhancer pairs.\n"
fi

echo -e "Preprocessing for getting variant-promoter/enhancer pairs...\n\n"
bash ./01.get.pairs.sh -i ${in_f} -o ${cmn_dir} -w ${window_n} -b ${midpoint_bed} -t ${n_cpu}

echo -e "Preprocessing for collecting information of input files...\n\n"
bash ./02.collect.inputs.sh -o ${cmn_dir}

if [ ${cpu} -eq 1 ]; then
  echo -e "Running in silico mutagenesis using only CPUs...\n\n"
  bash ./03.run.mutgen.sh -o ${cmn_dir} -m ${deepsea} -M ${ml_dir} -f ${ref_fa} -t ${n_cpu} -l ${model_list_log} -q ${calib_modelList} -P ${peak_info} -c
else
  echo -e "Running in silico mutagenesis...\n\n"
  bash ./03.run.mutgen.sh -o ${cmn_dir} -m ${deepsea} -M ${ml_dir} -f ${ref_fa} -t ${n_cpu} -l ${model_list_log} -q ${calib_modelList} -P ${peak_info}
fi

echo -e "Postprocessing...\n\n"
bash ./04.post.mutgen.sh -o ${cmn_dir}

if [ ${cage_list} != "ALL" ] && [ ${midpoint_bed} != ${original_midpoint_bed} ]; then
  rm -f ${midpoint_bed}
fi

cd - 1> /dev/null 2>&1
