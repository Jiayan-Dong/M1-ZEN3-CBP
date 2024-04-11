%include "../nops.inc"

%define repeat0  10              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2

%macro testinitc 0              ; Macro to call in each test before reading counters.

%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    jmp start_test
align 1<<14
start_test:
    %assign i 1
    %rep var
    jmp target%+ i
align 1<<14
target%+ i:
    %assign i i+1 
    %endrep

    %rep 16
     nop8
    %endrep

%endmacro
