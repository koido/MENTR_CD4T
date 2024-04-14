#!/bin/bash
#
# 01.get.pairs.sh
#   Preprocessing: get variant-promoter/enhancer pairs 
#
#   Usage:
#     01.get.pairs.sh [-i input_file] [-o cmn_dir] ...
#       -i TEXT  input variant file [required]
#       -o TEXT  output dir [required]
#       -w INT   window size [bp] [default: 100000]
#       -b TEXT  midpoint bed file [required]
#                 col1: chr
#                 col2: start (midpoint - 1)
#                 col3: end (midpoint)
#                 col4: strand [+/-/N]
#                 col5: CAGE_peak_ID
#       -t INT   Number of threads. [default:1]
#       -d       Dry Run mode
#       -h       Show help (this message)

# Move to the dir
cd `dirname $0`

# == utils ==
source ../../src/sh/utils.sh

# == arg parser ==

# init
DryRun=0
# window size [bp]; default is (Promoter TSS / Enhancer midpoint) +/- 100-kb) but you can change this parameter
window_n=100000
# Number of CPU
n_cpu=1

# get
while getopts ":i:o:w:b:t:dh" optKey; do
  case "${optKey}" in
    i)
      in_f="${OPTARG}";;
    o)
      cmn_dir="${OPTARG}";;
    w)
      window_n="${OPTARG}";;
    b)
      midpoint_bed="${OPTARG}";;
    t)
      n_cpu="${OPTARG}";;
    d)
      DryRun=1;;
    h)
      help `basename $0`;;
    :)
      echo -e "Error: Undefined options were observed.\n"
      help `basename $0`;;
    \?)
      echo -e "Error: Undefined options were specified.\n"
      help `basename $0`;;
  esac
done

# required args
if [ -z "${in_f}" ]; then
  echo "Error: -i is required"
  help `basename $0`
fi
if [ -z "${cmn_dir}" ]; then
  echo "Error: -o is required"
  help `basename $0`
fi
if [ -z "${midpoint_bed}" ]; then
  echo "Error: -b is required"
  help `basename $0`
fi

# INT check
int_chk ${window_n} "-w"

# == common args ==

# whether input file contains header or not [T/F]
header=F

# Show args
echo -e "# == Args for 01.get.pairs.sh =="
echo -e "# in_f: ${in_f}"
echo -e "# cmn_dir: ${cmn_dir}"
echo -e "# window_n: ${window_n}"
echo -e "# midpoint_bed: ${midpoint_bed}"
echo -e "# header: ${header}"
echo -e "# DryRun: ${DryRun}"
echo -e "# n_cpu: ${n_cpu}"
echo -e ""

if [ ${n_cpu} -gt 1 ]; then
  parallel=T

  # check availability of GNU parallel
  if ! type parallel > /dev/null 2>&1; then
    echo -e "Error: GNU parallel is not available."
    exit 1
  fi

else
  parallel=F
fi

# == Dry RUN ==
if [ ${DryRun} -eq 1 ]; then
  echo -e "# ** Dry Run **"
  echo -e "# in_f: ${in_f}"
  echo -e "# cmn_dir: ${cmn_dir}"
  echo -e "bash ../../src/sh/insilico_mutgen_make_closest_gene_prospective.sh ${cmn_dir} ${midpoint_bed} ${in_f} ${window_n} ${header} ${parallel} ${n_cpu}"
  exit 1
fi

# == RUN ==
bash ../../src/sh/insilico_mutgen_make_closest_gene_prospective.sh \
  ${cmn_dir} \
  ${midpoint_bed} \
  ${in_f} \
  ${window_n} \
  ${header} \
  ${parallel} ${n_cpu} && \
  bash ../../src/sh/insilico_mutgen_targets_count.sh ${cmn_dir}
