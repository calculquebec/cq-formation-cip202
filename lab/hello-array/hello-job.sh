#!/bin/bash

#SBATCH --job-name=hello
#SBATCH --array=1-10

echo "Hello from step $SLURM_ARRAY_TASK_ID"

sleep 60
