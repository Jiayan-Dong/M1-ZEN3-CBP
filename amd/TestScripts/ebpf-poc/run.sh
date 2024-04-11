#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Performance Counters.
cts=9,311,320,321

now="$(date)"
echo "Experiment date and time: $now"

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Compile nasm file.
nasm -f elf64 -o /tmp/b64.o -i../ \
  -Dcounters=$cts \
  -Ppoc.nasm \
  ../TemplateB64.nasm

# Link the A and B files.
if [ $? -ne 0 ] ; then exit ; fi
g++ -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

# Running the actual test. 
if [ $? -ne 0 ] ; then exit ; fi
/tmp/x > results.csv

# Calculating some results and printing them out
echo "The number of L1D Misses: "
awk -F " " 'END { print s } { s += $3 }' results.csv
echo "The number of L2 Misses: "
awk -F " " 'END { print s } { s += $4 }' results.csv
echo "The number of L3 Misses: "
awk -F " " 'END { print s } { s += $5 }' results.csv

objdump -d /tmp/x > poc.asm