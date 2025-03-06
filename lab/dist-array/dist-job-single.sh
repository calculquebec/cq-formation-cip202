#!/bin/bash

#SBATCH --job-name=dist
#SBATCH --mem=1G
#SBATCH --time=00:05:00

module load StdEnv/2023 python/3.11.5 scipy-stack/2025a

mkdir -p results

python3 ./dist.py "results/dist.csv"
