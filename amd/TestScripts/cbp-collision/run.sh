#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Performance Counters.
echo -e "   Clock     BrClear     BrCond     BrTaken     BrNTaken    BrMispred    MisTak" > results.csv
cts=211,203,201,202,207,208
# cts=205

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
  /tmp/x >> results.csv
done

# objdump -d /tmp/x > bp.asm