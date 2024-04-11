#!/bin/bash

# Code to initialize environment variables etc. inside test scripts
(cd .. && . vars.sh)

# Performance Counters.
echo -e "     Clock       BrRetired        BrMispred" > results.csv 
cts=200,204

now="$(date)"
echo "Experiment date and time: $now"

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Compile nasm file.
for i in {0..300..1}
do
  nasm -f elf64 -o b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -Dmy_align=$1 \
    -Pbp.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -T script.ld -no-pie -flto -flto -m64 a64.o b64.o -ox -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  ./x >> results.csv
done

# echo "Number of conditional taken branches: "
# awk -F " " 'END { print s } { s += $3 }' results.csv
# echo "Number of micpredictions: "
# awk -F " " 'END { print s } { s += $4 }' results.csv

# objdump -d /tmp/x > bp.asm