#!/bin/bash
#SBATCH -J cutadapt
#SBATCH -o cutadapt.o%j
#SBATCH -e cutadapt.e%j
#SBATCH -N 4
#SBATCH -n 64
#SBATCH --ntasks-per-node=16
#SBATCH -p development
#SBATCH -t 02:00:00
#SBATCH -A P.hallii_expression
#SBATCH --mail-user=taslima@utexas.edu
#SBATCH --mail-type=ALL

module load launcher
ml cutadapt
export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="cutadapt.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
