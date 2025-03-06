#!/bin/bash

#SBATCH --array=1-12

i=$SLURM_ARRAY_TASK_ID

read prot temp agent <<< $(sed "${i}q;d" params.txt)

echo "Loading structure for protein $prot"
echo "Setting temperature to $temp degrees"
if $agent; then
    echo "Adding stabilizing agent"
fi
