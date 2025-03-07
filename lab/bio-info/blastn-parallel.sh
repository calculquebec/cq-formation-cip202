#!/bin/bash
#SBATCH --cpus-per-task=X
#SBATCH --mem-per-cpu=2000M
#SBATCH --time=0-00:10

module load StdEnv/2023 gcc/12.3 blast+/2.14.1 seqkit/2.5.1

mkdir -p results

parallel 'blastn -db spec_{} -query chr_{}.fa > results/align_{}_{}' \
   A B C D  K L M N O P Q R S T U V W X Y Z
