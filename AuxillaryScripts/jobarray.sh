#!/bin/bash

#-------------------------------------------------------------------------------

#  SBATCH CONFIG

#-------------------------------------------------------------------------------

## resources

#SBATCH --partition BioCompute

#SBATCH --array=1-1000

#SBATCH --mem-per-cpu=11G  # memory per core (default is 1GB/core)

#SBATCH --time 0-01:15     # days-hours:minutes

#SBATCH --account=kinglab  # investors will replace this with their account name

#

## labels and outputs

#SBATCH --job-name=ohta_scaling_test

#

# master job ID (%A), array-tasks ID (%a)

#SBATCH --output=/storage/hpc/data/pfp6wc/Ohta/Cows/logs/scaling-%A_%a.out 

#-------------------------------------------------------------------------------

 

echo "### Starting at: $(date) ###"

echo $SLURM_ARRAY_TASK_ID


# load modules then display what we have

module load r/r-3.4.2

module list

 

# file and steps go here

cd /storage/hpc/data/pfp6wc/Ohta/Cows

FILENAME=scripts/parallelohta.R

 

# Science goes here:

Rscript --version

Rscript $FILENAME $SLURM_ARRAY_TASK_ID

 

echo "### Ending at: $(date) ###"
