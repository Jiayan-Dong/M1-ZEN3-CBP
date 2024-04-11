#!/bin/bash

(cd .. && . vars.sh)

# Read coreID from input. 
coreID=$1 

cts=204,207,206,212

now="$(date)"
echo "Experiment date and time: $now"

echo -e "   Clock     BrRetired     BrMispred     BrMispInd     BrClear" > results.csv

# Compile PMCTestA file if modified.
if [ ../PMCTestA.cpp -nt a64.o ] ; then
  g++ -O2 -c -m64 -oa64.o ../PMCTestA.cpp
fi

# Define the start and bit-shift limit
start=0x5800000
bit_shift_limit=20

# Convert the start value from hexadecimal to decimal
start_dec=$(printf "%d" $start)

hex_val_last=$start
# Iterate over the range of bits to shift
for ((bit=0; bit<bit_shift_limit; bit++))
do
  # Shift the least significant bit to the left by 'bit' positions
  shifted_val=$((start_dec | (1 << bit)))

  # Convert the shifted value from decimal back to hexadecimal
  hex_val=$(printf "0x%x" $shifted_val)

  # Replace the value in the linker script
  # sed -i "s/${hex_val_last}/${hex_val}/g" script.ld
  hex_val_last=$hex_val

  # echo -e "\n$hex_val" >> results.csv
  nasm -f elf64 -o b64.o -i../ \
    -Dcounters=$cts \
    -Dijmp_number=2 \
    -Dshift=$bit \
    -Pibp_usedPC_skylake.nasm \
    ../TemplateB64.nasm

  # Link the A and B files.
  if [ $? -ne 0 ] ; then exit ; fi
  g++ -T script.ld -no-pie -flto -m64 a64.o b64.o -o/tmp/x -lpthread

  # Running the actual test. 
  if [ $? -ne 0 ] ; then exit ; fi
  taskset -c $coreID /tmp/x >> results.csv
done

# sed -i "s/${hex_val_last}/${start}/g" script.ld
objdump -d /tmp/x > x.asm
