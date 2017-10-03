#!/bin/bash


# usage
# script, [pattern (excluding leading *), required] [maxDepth, optional, default is 1]
# ~/Documents/Dropbox/ucsc/projects/gitCode/misc-scripts/reviewVcfs.sh "mini.ann.vcf"
thisPattern=$1 # .precise_merged.mini.ann.vcf
thisMaxDepth=${2-1}


hmCounter=0
allVarCounter=0
# cd /pod/pstore/users/hbeale/projects/rnaSeqVar/
a=`find . -maxdepth $thisMaxDepth -iname "*${thisPattern}"`

# a=`find . -maxdepth 1 -iname "*.precise_merged.mini.ann.vcf" `
# how many files are there?
# fileArray=( $a ); echo "the total number of vcfs is: " ${#fileArray[@]}
# show contents of files with variants
for i in $a; do 
bCount=`cat  $i | grep -v ^# | wc -l`
if [ "$bCount" -gt 0 ]; then 
allVarCounter=$((allVarCounter +1))
b=`cat  $i | grep -v ^# |  cut  -f1-8 | sed 's/AB=.*;EFF=\([^)]*\)).*/\1/' | grep -v -e 'LOW\|MODIFIER'  | cut -d'|' --output-delimiter " " -f1,2,4,6`
if [ ! -z "$b" ]; then 
hmCounter=$((hmCounter +1))
# echo $i; echo $b ; fi
printf '%s\n' "$i"
printf '%s\n' "$b"
fi
fi
done

fileArray=( $a ); echo "the total number of vcfs is: " ${#fileArray[@]}
echo  "the number of vcfs with any variant is: " $allVarCounter
echo  "the number of vcfs with HIGH and MODERATE variants is: " $hmCounter
