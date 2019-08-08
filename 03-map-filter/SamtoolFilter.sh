#!/bin/bash
#SBATCH -J samtoolsfilter
#SBATCH -o samtoolsfilter.o%j
#SBATCH -e samtoolsfilter.e%j
#SBATCH -N 4
#SBATCH -n 128
#SBATCH --ntasks-per-node=32
#SBATCH -p normal
#SBATCH -t 06:00:00
#SBATCH -A P.hallii_expression

module load launcher
ml samtools

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="filter.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
