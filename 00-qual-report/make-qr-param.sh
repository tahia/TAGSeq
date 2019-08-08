#!/bin/bash
# TASLIMA HAQUE
# Jan 20 2018
# make-qr-param.sh - makes parameter file for running the quality control program

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]]; then
    echo "usage: make-qr-param.sh </raw-fastq-path/> </output-path/>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
PARAM="Qual-File.param"
LOG="logs/"
SCRIPT="fastqc "

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
    OLOG="${LOG}${NAME}.log"
    echo "$SCRIPT --noextract -f fastq -o $ODIR -t 4 $fil > $OLOG" >> $PARAM
done
