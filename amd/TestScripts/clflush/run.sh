#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Performance Counters.
cts=9,311,320,321
echo -e "      Clock     Instns     L1Miss     L2Miss     L3Miss" > results.csv
cts=9,203,207,206,211
echo -e "      Clock     Instns   CondBrRet  CondBrMisp  BrMispInd  BACLEAR" > results.csv

now="$(date)"
echo "Experiment date and time: $now"

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Compile nasm file.
nasm -f elf64 -o /tmp/b64.o -i../ \
  -Dcounters=$cts \
  -Pclflush.nasm \
  ../TemplateB64.nasm

# Link the A and B files.
if [ $? -ne 0 ] ; then exit ; fi
g++ -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

# Running the actual test. 
if [ $? -ne 0 ] ; then exit ; fi
taskset -c 0 /tmp/x >> results.csv 

echo "Number of L1 Misses: "
awk -F " " 'END { print s } { s += ($3 > 0) }' results.csv
echo "Number of L2 Misses: "
awk -F " " 'END { print s } { s += ($4 > 0) }' results.csv
echo "Number of L3 Misses: "
awk -F " " 'END { print s } { s += ($5 > 0) }' results.csv

# objdump -d /tmp/x > clflush.asm