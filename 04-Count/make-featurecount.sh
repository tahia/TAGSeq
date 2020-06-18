#!/bin/bash
# This will make paramfile for featurecount 
# This script is for the pipe of TAGSeq data analysis
# Modified by Taslima Haque on 18th Apr,2018

if [[ -z $1 ]] | [[ -z $2 ]] || [[ -z $3 ]] ; then
  echo "Usage: make-featurecount.sh in/dir out/dir annotation/file"
  exit 1;
fi

# PATH to featureCounts
SCRIPT="/work/02786/taslima/stampede2/tools/subread-1.6.1-source/bin/featureCounts"
INDIR=$1
ODIR=$2
ANF=$3
PARAM="featureCounts.param"
LOG="logs/"

if [ ! -d $LOG ]; then mkdir $LOG; fi

if [ ! -d $ODIR ]; then mkdir $ODIR; fi

if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

OFIL="${ODIR}Counts.tab"

# Remove if the output file exists
if [ -e $OFIL ]; then rm $OFIL; fi

# Loop over the filtered bam files 
for fil in ${INDIR}*.bam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*sam}
  IN+="${fil} "
done
  OLOG="${LOG}featureCounts.log"
echo "$SCRIPT -a $ANF -o $OFIL -t gene -g ID --readExtension5 0  --readExtension3 0 -s 1 -Q 0 -d 50 -T 24 --primary $IN  > $OLOG " >> $PARAM

