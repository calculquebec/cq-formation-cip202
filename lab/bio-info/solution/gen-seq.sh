#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=0-00:05

module load StdEnv/2023 gcc/12.3 python/3.11 blast+/2.14.1 seqkit/2.5.1

bash clean.sh

parallel 'python gen_spec.py {} 8000 9600 900 1600 > spec_{}.fa' ::: A B C D
parallel 'makeblastdb -in spec_{}.fa -dbtype nucl -out spec_{}' ::: A B C D

parallel 'python gen_test.py {} 9600 12800 128 256 > chr_{}.fa' \
  ::: K L M N O P Q R S T U V W X Y Z
