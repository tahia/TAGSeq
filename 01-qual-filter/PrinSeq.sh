#!/bin/bash
#SBATCH -J prinseq
#SBATCH -o prinseq.o%j
#SBATCH -e prinseq.e%j
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --ntasks-per-node=2
#SBATCH -p development
#SBATCH -t 02:00:00
#SBATCH -A P.hallii_expression

module load launcher

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="prinseq.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
