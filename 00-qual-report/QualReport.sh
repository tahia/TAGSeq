#!/bin/bash
#SBATCH -J fastqc
#SBATCH -o fastqc.o%j
#SBATCH -e fastqc.e%j
#SBATCH -N 4
#SBATCH -n 64
#SBATCH --ntasks-per-node=16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression
#SBATCH --mail-user=taslima@utexas.edu
#SBATCH --mail-type=ALL

module load launcher
ml fastqc

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="Qual-File.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
