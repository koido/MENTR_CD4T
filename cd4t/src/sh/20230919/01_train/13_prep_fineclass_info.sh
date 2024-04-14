#!/bin/bash

# Input: bed files

# Output: txt file
## col1: cluster ID (id=$1 ":" $2 "-" $3), col2: case (1) or control (0) (int)
## delim: tab
## header none

# Common Function
function prep_pheno(){
  case=$1
  ctrl=$2
  out=$3

  # if ${out} or ${out}.gz exist, exit
  if [ -e ${out}.gz ]; then
    echo "out file already exists: ${out}"
    exit 1
  fi
  if [ -e ${out} ]; then
    echo "out file already exists: ${out}.gz"
    exit 1
  fi
  # Existance Check
  # case
  if [ ! -e ${case} ]; then
    echo "case file not found: ${case}"
    exit 1
  fi
  # ctrl
  if [ ! -e ${ctrl} ]; then
    echo "ctrl file not found: ${ctrl}"
    exit 1
  fi
  # Directory Check
  out_dir=$(dirname ${out})
  if [ ! -e ${out_dir} ]; then
    echo "out_dir not found: ${out_dir}"
    exit 1
  fi

  # Print number of rows in the each bed file
  echo "N rows in case: " `cat ${case} | wc -l`
  echo "N rows in ctrl: " `cat ${ctrl} | wc -l`

  cat ${case} | \
    awk -F "\t" '
      BEGIN{
        OFS="\t"
      }
      {
        print $1 ":" $2 "-" $3, 1
      }
    ' > ${out}
  cat ${ctrl} | \
    awk -F "\t" '
      BEGIN{
        OFS="\t"
      }
      {
        print $1 ":" $2 "-" $3, 0
      }
    ' >> ${out}
  gzip ${out}
}

# Output dir
out_dir=./cd4t/resources/trained/03/binary_v1/sub
mkdir -p ${out_dir}

# common dir
cmn_dir=./cd4t/resources/20230919

prep_pheno \
   ${cmn_dir}/F2_btcEnhs_afterFiltered_overlap_ATACpeaks.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F2_vs_F34.phen
# N rows in case:  37236
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F3_btcEnhs_afterFiltered_NOToverlap_ATACpeaks.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F3_vs_F34.phen
# N rows in case:  25567
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F4_btcEnhs_afterFiltered_overlap_MicroCAnchor.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F4_vs_F34.phen
# N rows in case:  25597
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F5_btcEnhs_afterFiltered_NOToverlap_MicroCAnchor.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F5_vs_F34.phen
# N rows in case:  37206
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F23_btcEnhs_afterFiltered_armadillo.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F23_vs_F34.phen
# N rows in case:  39181
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F24_btcEnhs_afterFiltered_dog_mouse.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F24_vs_F34.phen
# N rows in case:  8866
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F25_btcEnhs_afterFiltered_lemur.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F25_vs_F34.phen
# N rows in case:  3321
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F26_btcEnhs_afterFiltered_marmoset.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F26_vs_F34.phen
# N rows in case:  6086
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F27_btcEnhs_afterFiltered_rhesus.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F27_vs_F34.phen
# N rows in case:  3319
# N rows in ctrl:  53981

prep_pheno \
   ${cmn_dir}/F28_btcEnhs_afterFiltered_gibbontohuman.bed \
   ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
   ${out_dir}/F28_vs_F34.phen
# N rows in case:  2023
# N rows in ctrl:  53981

prep_pheno \
  ${cmn_dir}/F12_ATACpeaks_NOToverlap_Mask_btc_high10.bed \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${out_dir}/F12_vs_F17.phen
# N rows in case:  19682
# N rows in ctrl:  21191

prep_pheno \
  ${cmn_dir}/F13_ATACpeaks_NOToverlap_Mask_btc_low10.bed \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${out_dir}/F13_vs_F17.phen
# N rows in case:  13296
# N rows in ctrl:  21191

prep_pheno \
  ${cmn_dir}/F14_ATACpeaks_NOToverlap_Mask_btc_high100.bed \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${out_dir}/F14_vs_F17.phen
# N rows in case:  6193
# N rows in ctrl:  21191

prep_pheno \
  ${cmn_dir}/F15_ATACpeaks_NOToverlap_Mask_btc_low100.bed \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${out_dir}/F15_vs_F17.phen
# N rows in case:  26785
# N rows in ctrl:  21191

prep_pheno \
  ${cmn_dir}/F12_ATACpeaks_NOToverlap_Mask_btc_high10.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F12_vs_F21.phen
# N rows in case:  19682
# N rows in ctrl:  88637

prep_pheno \
  ${cmn_dir}/F13_ATACpeaks_NOToverlap_Mask_btc_low10.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F13_vs_F21.phen
# N rows in case:  13296
# N rows in ctrl:  88637

prep_pheno \
  ${cmn_dir}/F14_ATACpeaks_NOToverlap_Mask_btc_high100.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F14_vs_F21.phen
# N rows in case:  6193
# N rows in ctrl:  88637

prep_pheno \
  ${cmn_dir}/F15_ATACpeaks_NOToverlap_Mask_btc_low100.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F15_vs_F21.phen
#N rows in case:  26785
#N rows in ctrl:  88637