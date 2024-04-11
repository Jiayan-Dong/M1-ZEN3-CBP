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
output_file=results.csv

echo -e "   Clock     BrRetired     BrMispred     BrMispInd     BrClear" > results.csv

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

#i=6
max=60
# Compile nasm file.
for (( i=$max; i>0; --i ))
do

  echo -e "\nvar = $i!" >> results.csv
  nasm -f elf64 -o ../b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -PiTB_phr_index.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -m64 a64.o ../b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID /tmp/x >> results.csv
done

objdump -d /tmp/x > x.asm