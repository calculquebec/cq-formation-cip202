#!/bin/bash

proteins="A B"
temperatures="30 37 44"

rm -f params.txt

for prot in $proteins; do
    for temp in $temperatures; do
        for agent in true false; do
            echo $prot $temp $agent >> params.txt
        done
    done
done
