#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Read coreID from input. 
coreID=$1 

# Performance Counters.
if [ $coreID -lt 16 ] ; then #p-core
  cts=210,205,206,211
else #e-core
  cts=210,216,215,212
fi

now="$(date)"
# echo "Experiment date and time: $now"
output_file=result_e/results_clearPHR_$3.csv

echo -e "   Clock     BrMisAll     BrIndir     BrMispInd      BrClear" > $output_file

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

#i=6
max=$2
# Compile nsm file.
for (( i = 1; i <= $max; ++i ))
do
  echo -e "\nijmp_number=$i!" >> $output_file

  if [ "$3" -eq 0 ]; then
    varIsSet=0
  else
    varIsSet=1
  fi
  nasm -f elf64 -o /tmp/b64.o -i../ \
    -Dcounters=$cts \
    -Dijmp_number=$i \
    -Dvar=$3 \
    -DvarIsSet=$varIsSet \
    -Passo_alderlake_e.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -no-pie -flto -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID /tmp/x >> $output_file
done

objdump -d /tmp/x > x.asm