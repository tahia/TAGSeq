#!/bin/bash
#SBATCH -J bwa
#SBATCH -o bwa.o%j
#SBATCH -e bwa.e%j
#SBATCH -N 8
#SBATCH -n 128
#SBATCH --ntasks-per-node=16
#SBATCH -p normal
#SBATCH -t 04:00:00
#SBATCH -A P.hallii_expression

module load launcher
ml bwa

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="bwa.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
