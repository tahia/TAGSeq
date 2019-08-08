#!/bin/bash
# TASLIMA HAQUE
# Jan 20 2018
# make-qr-param.sh - makes parameter file for running the quality control program

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]]; then
    echo "usage: make-prinseq-param.sh </raw-fastq-path/> </output-path/>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
PARAM="prinseq.param"
LOG="logs/"
SCRIPT="perl /work/02786/taslima/stampede2/bckup_stampede1/tools/prinseq-lite-0.20.4/prinseq-lite.pl "

# Check if input dir exists
if [[ ! -d $DIRS ]]; then
    echo "ERROR: The input directory $DIRS doesn't exist!!!"
    exit 1;
fi

# Check if output and log dirs exist, if not make them
if [ ! -d $ODIR ]; then
    echo "Output directory doesn't exist. Making $ODIR"
    mkdir $ODIR
else 
    rm -r $ODIR*
fi

ODIRG="${ODIR}GOOD/"
ODIRB="${ODIR}BAD/"


#make directory for GOOD and BAD sequence files
mkdir $ODIRG
mkdir $ODIRB

if [ ! -d $LOG ]; then 
    echo "Log directory doesn't exist. Making $LOG"
    mkdir $LOG
fi

# Check if parameter file exists. Remove it and create placeholder
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# Loop through dirs
for fil in ${DIRS}*_R1.fastq; do
    BASE=$(basename $fil)
    NAME=${BASE%_R1.fastq*}
    IN1="${DIRS}${NAME}_R1.fastq"
    IN2="${DIRS}${NAME}_R2.fastq"
    OF1="${ODIRG}${NAME}"
    OF2="${ODIRB}${NAME}"
    OLOG="${LOG}${NAME}.log"
    echo "$SCRIPT -fastq $IN1 -fastq2 $IN2 -out_format 3  -out_good $OF1 -out_bad $OF2 -min_len 50 -min_qual_mean 20 -trim_left 9 > $OLOG" >> $PARAM
done
