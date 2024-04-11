#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Read coreID from input. 
coreID=$1 

# Performance Counters.
cts=204,206,207,212

now="$(date)"
echo "Experiment date and time: $now"

echo -e "   Clock     BrRetired     BrMispInd      BrMispred      BrClear" > results.csv

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

#i=6
max=$2
# Compile nasm file.
for (( i=0; i <= $max; ++i ))
do
  echo -e "\nvar=$i!" >> results.csv
  nasm -g -f elf64 -o b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -Pibpb_test.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -g -no-pie -flto -m64 a64.o b64.o -o./x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID ./x >> results.csv
done

objdump -d ./x > x.asm
