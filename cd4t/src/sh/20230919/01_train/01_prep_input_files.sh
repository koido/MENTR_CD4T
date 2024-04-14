#!/bin/bash

cd cd4t/resources

# Make unique bed file (not blocked gzip)
cat ./20230919/*.bed | sort-bed - | uniq | gzip -c > 20230919.uniq.bed.gz

# prep midpoint file
## col4: midpoint of col2 and col3
## col5: name
zcat 20230919.uniq.bed.gz | \
  awk -F "\t" '
    function is_even(x){
      return x % 2 == 0
    }
    BEGIN{
      OFS="\t"
    }
    {
      sum=$2+$3;
      id=$1 ":" $2 "-" $3
      if(is_even(sum)){
        est_mid=sum/2
      }else{
        est_mid=(sum-1)/2
      };
      print $0, est_mid, id
    }' | \
  gzip -c > 20230919.uniq.midpoint.id.bed.gz

# peak file
## col1: ID (chr1:XXX-XXX)
## col2: midpoint
zcat 20230919.uniq.midpoint.id.bed.gz | \
  awk -F "\t" '
    BEGIN{
      OFS="\t"
    }
    {
      print $5, $4
    }
  ' | \
  gzip -c > 20230919.uniq.midpoint.id.bed.input.txt.gz

# cluster file
## col1: ID
## col2: type (promoter or enhancer)
zcat 20230919.uniq.midpoint.id.bed.input.txt.gz | \
  awk -F "\t" '
    BEGIN{
      OFS="\t"
    }
    {
      print $1, "enhancer"
    }
  ' | \
  gzip -c > 20230919.uniq.midpoint.id.bed.input.clusterfile.txt.gz

# bed file for in silico mutgen (sort bed)
## col1: chr
## col2: start (midpoint - 1)
## col3: end (midpoint)
## col4: strand: N
## col5: ID
zcat 20230919.uniq.bed.gz | \
  awk -F "\t" '
    function is_even(x){
      return x % 2 == 0
    }
    BEGIN{
      OFS="\t"
    }
    {
      sum=$2+$3;
      id=$1 ":" $2 "-" $3
      if(is_even(sum)){
        est_mid=sum/2
      }else{
        est_mid=(sum-1)/2
      };
      print $1, (est_mid - 1), est_mid, "N", id
    }' | \
  sort-bed - > sortbed4mutgen.midpoint.v3.bed

  cd - 1> /dev/null 2>&1