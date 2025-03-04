#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=1000M
#SBATCH --time=00:05:00

parallel < cmd.txt
grep -E '[0-9]+' prod_*
