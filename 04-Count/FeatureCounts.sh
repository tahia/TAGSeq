#!/bin/bash
#SBATCH -J fetCounts
#SBATCH -o fetCounts.o%j
#SBATCH -e fetCounts.e%j
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -p development
#SBATCH -t 02:00:00
#SBATCH -A P.hallii_expression

module load launcher


export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE="featureCounts.param"
 
$LAUNCHER_DIR/paramrun



echo "DONE";
date;
