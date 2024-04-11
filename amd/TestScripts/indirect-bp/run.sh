#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

rm results.csv

# Performance Counters.
cts=204,210,205,206,207
echo -e "   Clock     BrRetired   BrMisAll    BrIndir    BrMispInd  BrMispCond" >> results.csv

now="$(date)"
echo "Experiment date and time: $now"

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Compile nasm file.
for i in {1..1..1}
do
  nasm -f elf64 -o /tmp/b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -Pbp.nasm \
    ../TemplateB64.nasm
  
  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  echo -e "var: $i" >> results.csv
  taskset -c 0 /tmp/x >> results.csv
done

echo "Number of Branches: "
awk -F " " 'END { print s } { s += $2 }' results.csv
echo "Number of Mispredicted Indirect Branches: "
awk -F " " 'END { print s } { s += $5 }' results.csv

objdump -d /tmp/x > bp.asm