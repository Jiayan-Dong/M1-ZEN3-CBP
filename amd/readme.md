# Performance Counters 
This repository is the latest version (As of Jan 13 2023) of agner's tool to measure the performance counters. 

# Installing Driver
```
chmod a+x *.sh
make
sudo ./install.sh
```
> Must reinstall after reboot.

# Running the test scripts
```
chmod a+x *.sh
./init.sh 
```

# Template: 
This is for designing more test scripts. 
Two main files are in ```./TestScripts/template/```:
```
template.nasm >> Includes the macros that are useful for the experiments.
run.sh        >> Runnning the experiment. 
```
