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
echo "Experiment date and time: $now"

echo -e "   Clock     BrMisAll     BrIndir     BrMispInd     BrClear" > results.csv

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

#i=6
max=$2
# Compile nasm file.
for (( i=1; i <= $max; ++i ))
do
  #echo -e "\n$i targets!" >> results.csv
  # echo -e "\n1 jump!" >> results.csv
  # nasm -f elf64 -o /tmp/b64.o -i../ \
  #   -Dcounters=$cts \
  #   -Dvar=$i \
  #   -Djump2=0 \
  #   -Pibp_target.nasm \
  #   ../TemplateB64.nasm

  # # Link the A and B files.
  # if [ $? -ne 0 ] ; then exit ; fi
  # g++ -T script.ld -no-pie -flto -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

  # # Running the actual test. 
  # if [ $? -ne 0 ] ; then exit ; fi
  # taskset -c $coreID /tmp/x >> results.csv

#++++++++++++++++++++++++++++++++++++++++++
  #echo -e "\n2 correlated jumps!" >> results.csv
  repeat1=$i*20
  nasm -g -f elf64 -o /tmp/b64.o -i../ \
    -Dcounters=$cts \
    -Dvar=$i \
    -Dibranch=1 \
    -Drepeat1=$repeat1 \
    -Pibp_TargetNumber.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -g -T script.ld -no-pie -flto -m64 a64.o /tmp/b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID /tmp/x >> results.csv
  # done
done

objdump -d /tmp/x > x.asm
