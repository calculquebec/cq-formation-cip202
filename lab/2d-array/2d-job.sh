#!/bin/bash

#SBATCH --array=0-31

i=$SLURM_ARRAY_TASK_ID

x=$((i % 8))  # mod
y=$((i / 8))  # div

echo "Testing drug candidate $x vs receptor $y"
