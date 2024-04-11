#!/bin/bash

(cd .. && . vars.sh)

# Read coreID from input. 
coreID=$1 

# Performance Counters.
if [ $coreID -lt 16 ] ; then #p-core
  cts=311,211,205,206
else #e-core
  cts=212,216,215
fi

now="$(date)"
echo "Experiment date and time: $now"

echo -e "   Clock     L1D_Miss    BrClear   BrIndir    BrMispInd" > results.csv


# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

max=$2
# Compile nasm file.
for (( i=0; i <= $max; ++i ))
do
  echo -e "\nvar=$i!" >> results.csv
  nasm -f elf64 -o /tmp/b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -Pibp_collision_attacker.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -mcmodel=large -T script.ld -no-pie -flto -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID /tmp/x >> results.csv
done

objdump -d /tmp/x > x.asm



