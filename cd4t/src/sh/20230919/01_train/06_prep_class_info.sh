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

  # Check file existance
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
  # Check directory
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
out_dir=./cd4t/resources/trained/03/binary_v1
mkdir -p ${out_dir}

# common dir for input file
cmn_dir=./cd4t/resources/20230919

## F2_btcEnhs_afterFiltered_overlap_ATACpeaks.bed (n = 37236) vs
## F3_btcEnhs_afterFiltered_NOToverlap_ATACpeaks.bed (n = 25567)*
prep_pheno \
  ${cmn_dir}/F2_btcEnhs_afterFiltered_overlap_ATACpeaks.bed \
  ${cmn_dir}/F3_btcEnhs_afterFiltered_NOToverlap_ATACpeaks.bed \
  ${out_dir}/F2_vs_F3.phen

## F9_ATACpeaks_overlap_Mask_tr.bed (n = 22519) vs
## F10_ATACpeaks_overlap_Mask_nontr.bed (n = 3794)
prep_pheno \
  ${cmn_dir}/F9_ATACpeaks_overlap_Mask_tr.bed \
  ${cmn_dir}/F10_ATACpeaks_overlap_Mask_nontr.bed \
  ${out_dir}/F9_vs_F10.phen

## F11_ATACpeaks_NOToverlap_Mask_btc.bed (n = 32978) vs
## F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed (n = 21191)
prep_pheno \
  ${cmn_dir}/F11_ATACpeaks_NOToverlap_Mask_btc.bed \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${out_dir}/F11_vs_F17.phen

## F11_ATACpeaks_NOToverlap_Mask_btc.bed (n = 32978) vs
## F21_ATACpeaks_NOToverlap_Mask_nontr.bed (n = 88637)
prep_pheno \
  ${cmn_dir}/F11_ATACpeaks_NOToverlap_Mask_btc.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F11_vs_F21.phen

## F11_ATACpeaks_NOToverlap_Mask_btc.bed (n = 32978) + 
## F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed (n = 21191)
## vs F21_ATACpeaks_NOToverlap_Mask_nontr.bed (n = 88637)
cat ${cmn_dir}/F11_ATACpeaks_NOToverlap_Mask_btc.bed ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed > ${out_dir}/tmp.11_17.bed
prep_pheno \
  ${out_dir}/tmp.11_17.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F11_F17_vs_F21.phen

## F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed (n = 21191) vs
## F21_ATACpeaks_NOToverlap_Mask_nontr.bed (n = 88637)
prep_pheno \
  ${cmn_dir}/F17_ATACpeaks_NOToverlap_Mask_unitc_high10.bed \
  ${cmn_dir}/F21_ATACpeaks_NOToverlap_Mask_nontr.bed \
  ${out_dir}/F17_vs_F21.phen

# CD4 btcEnhs vs [F5 enhancer – CD4 btcEnhs]
## F1_btcEnhs_afterFiltered.bed (n = 62803) vs 
## [F33_FANTOM5_hg38_enhancers.bed (n = 63285)－F1_btcEnhs_afterFiltered.bed] **
## **[F33_FANTOM5_hg38_enhancers.bed (n = 63285)－F1_btcEnhs_afterFiltered.bed] -> F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed (n = 53981)
prep_pheno \
  ${cmn_dir}/F1_btcEnhs_afterFiltered.bed \
  ${cmn_dir}/F34_FANTOM5_hg38_enhancers_NOToverlap_btcEnhs_afterFiltered.bed \
  ${out_dir}/F1_vs_F34.phen

