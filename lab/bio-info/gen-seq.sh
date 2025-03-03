#!/bin/bash
#SBATCH --cpus-per-task=X
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=0-00:05

module load StdEnv/2023 gcc/12.3 python/3.11 blast+/2.14.1 seqkit/2.5.1

bash clean.sh

for spec in A B C D; do
  python gen_spec.py $spec 8000 9600 900 1600 > spec_$spec.fa
  makeblastdb -in spec_$spec.fa -dbtype nucl -out spec_$spec
done

for test in K L M N O P Q R S T U V W X Y Z; do
  python gen_test.py $test 9600 12800 128 256 > chr_$test.fa
done
