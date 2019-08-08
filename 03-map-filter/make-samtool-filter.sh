#!/bin/bash
# This will filter bam file
# This script is for the pipe of TAGSeq data analysis
# Modified by Taslima Haque on 18th Apr,2018

if [[ -z $1 ]] | [[ -z $2 ]] ; then
  echo "Usage: make-samtool-filter.sh in/dir out/dir "
  exit 1;
fi

SCRIPT="samtools view"
INDIR=$1
ODIR=$2
PARAM="filter_2.param"
LOG="logs/"

if [ ! -d $LOG ]; then mkdir $LOG; fi

if [ ! -d $ODIR ]; then mkdir $ODIR; fi

#if [ -e $PARAM ]; then rm $PARAM; fi
#touch $PARAM

# Loop over the sam files
# At this stage this scipt also get the sample name from file name, plaese make change to get the right field which will
# be the name of sample. For instance if you have a file name like this "IMUC_tagseq_Lib1_FC1_I802_L3_R1.sam", this script
# will separate the fields from the file name using "_" and here the sample name is in 4th field which is "FC1"

for fil in ${INDIR}*.sam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*sam}
  SAM=`echo $NAME | awk -F"_" '{print $4}'` #get 4th feild, change as per your need
  #OUT="${ODIR}${SAM}.bam"
  OUT="${ODIR}${NAME}.bam"
  OLOG="${LOG}${NAME}_samsort.log"
  # We can get 3/4 of memory so set memory accordingly (-m 2G , which means 2G of RAM for each job)
  echo "$SCRIPT -b -q 10 $fil | samtools sort -@ 1 -m 2G -o $OUT > $OLOG " >> $PARAM
done
