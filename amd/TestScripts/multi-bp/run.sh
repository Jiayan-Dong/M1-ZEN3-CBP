#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

rm results.csv

# Performance Counters.
cts=204,207,25,26,24
echo -e "   Clock   BrRetired    BrMispred    Dec-uops    DSB-uops    LSD-uops" >> results.csv

now="$(date)"
echo "Experiment date and time: $now"

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Compile nasm file.
for i in {0..0..1}
do
  # j=$((2**$i))
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
  taskset -c 0 /tmp/x >> results.csv
done

echo "Number of branches: "
awk -F " " 'END { print s } { s += $2 }' results.csv
echo "Number of mispredictions: "
awk -F " " 'END { print s } { s += $3 }' results.csv

objdump -d /tmp/x > bp.asm