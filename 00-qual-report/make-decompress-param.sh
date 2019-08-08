#!/bin/bash
# Taslima Haque
# make-qr-decompress-param.sh - makes parameter file for decompress of bz2 file

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]]; then
    echo "usage: make-decompress.sh </raw-fastq-path/> </output-path/>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
PARAM="bunzip.param"
LOG="logs/"
SCRIPT="bunzip2 -c "

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
for fil in ${DIRS}*.bz2; do
    BASE=$(basename $fil)
    NAME=${BASE%.bz2*}
    OFIL="${ODIR}${NAME}"
    OLOG="${LOG}${NAME}.log"
    echo "$SCRIPT  $fil > $OFIL 2> $OLOG" >> $PARAM
done
