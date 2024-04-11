#!/bin/bash
max=30
for (( i = 0; i <= $max; ++i ))
do
    echo "left shift phr by $i branch(es)"
    ./run_asso_single_e.sh 16 15 $i
done