#!/bin/bash
max=50
for (( i = 0; i <= $max; ++i ))
do  
    echo "left shift phr by $i branch(es)"
    ./run_asso_single_skylake.sh 0 10 $i
done