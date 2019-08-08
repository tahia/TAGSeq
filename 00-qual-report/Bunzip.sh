#!/bin/bash
#SBATCH -J bunzip
#SBATCH -o bunzip.o%j
#SBATCH -e bunzip.e%j
#SBATCH -N 4
#SBATCH -n 64
#SBATCH --ntasks-per-node=16
#SBATCH -p normal
#SBATCH -t 04:00:00
#SBATCH -A P.hallii_expression

module load launcher
ml intel/17.0.4

CMD="bunzip.param"


export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE=$CMD

$LAUNCHER_DIR/paramrun


echo DONE
