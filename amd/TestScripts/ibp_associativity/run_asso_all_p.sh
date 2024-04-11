#!/bin/bash
max=195
for (( i = 0; i <= $max; ++i ))
do
    echo "left shift phr by $i branch(es)"
    ./run_asso_single_p.sh 0 15 $i
done