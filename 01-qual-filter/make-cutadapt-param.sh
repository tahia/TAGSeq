#!/bin/bash
# TASLIMA HAQUE
# Jan 20 2018
# make-qr-param.sh - makes parameter file for running the quality control program

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]]; then
    echo "usage: make-cutadapt-param.sh </raw-fastq-path/> </output-path/>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
PARAM="cutadapt_1.param"
LOG="logs/"
SCRIPT="cutadapt "

# Check if input dir exists
if [[ ! -d $DIRS ]]; then
    echo "ERROR: The input directory $DIRS doesn't exist!!!"
    exit 1;
fi

# Check if output and log dirs exist, if not make them
if [ ! -d $ODIR ]; then
    echo "Output directory doesn't exist. Making $ODIR"
    mkdir $ODIR
fi



if [ ! -d $LOG ]; then 
    echo "Log directory doesn't exist. Making $LOG"
    mkdir $LOG
fi

# Check if parameter file exists. Remove it and create placeholder
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# Loop through dirs
for fil in ${DIRS}*.fastq; do
    BASE=$(basename $fil)
    NAME=${BASE%.fastq*}
    #IN1="${DIRS}${NAME}_R1_001.fastq"
    #IN2="${DIRS}${NAME}_R1_001.fastq"
    OF="${ODIR}${NAME}.fastq"
    #OF2="${ODIR}${NAME}_R2.fastq"
    OLOG="${LOG}${NAME}.log"
    #echo "$SCRIPT -g CAGATGTGTATAAGAGACAG -a GAGATGTGTATAAGAGACAG -A CAGATGTGTATAAGAGACAG -g GAGATGTGTATAAGAGACAG -O 8 -u 9 -m 50 --pair-filter=both -o $OF1 -p $OF2 $IN1 $IN2 > $OLOG" >> $PARAM
    #echo "$SCRIPT -a \"A{20}\"  $fil -u 18 -m 70 | $SCRIPT -a \"T{20}\" -m 70 - | $SCRIPT -g ACACGACGCTCTTCCGATCT -O 15 - | $SCRIPT -a CGTATGCCGTCTTCTGCTTG -O 15 -o $OF -m 70 -   > $OLOG" >> $PARAM
    echo "$SCRIPT -a \"A{15}\"  $fil -u 18 -m 70 | $SCRIPT -a \"T{15}\" -m 70  - | $SCRIPT -g ACACGACGCTCTTCCGATCT -O 12 - | $SCRIPT -a ATCTCGTATGCCGTCTTCTG -O 12 -m 70 -o $OF - > $OLOG" >> $PARAM
    #echo "$SCRIPT -a CAGATGTGTATAAGAGACAG  $IN2 -O 8 -m 50 | $SCRIPT -b CTGTCTCTTATACACATCT -O 8 -m 50 -o $OF2 - > $OLOG" >> $PARAM
done
