#!/bin/sh -l

#SBATCH --nodes=1
#SBATCH --tasks-per-node=16
#SBATCH --time=24:00:00
#SBATCH --job-name MetaAnalysis
#SBATCH -A microbiome

###################################################################
echo  "Start time: "
date +"%d %B %Y %H:%M:%S"

echo "Loading modules and conda environments..."
module load anaconda
module load use.own
module load conda-env/mypackages-py3.7.6
echo "Done"
python3 -u CombineASV.py

echo  "End time: "
date +"%d %B %Y %H:%M:%S"

