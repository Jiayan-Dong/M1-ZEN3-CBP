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
    
    %rep 8
     nop8
    %endrep

    %assign j 1
    %rep 8
        aligned_jmp j
        %assign j j+1
    %endrep

    %rep 8
     nop8
    %endrep

%endmacro

%macro aligned_jmp 1
    jmp start_test%+ %1
    align 1<<24
start_test%+ %1:
    %assign i 1
    %rep 8
    jmp target%+ i %+ %1
target%+ i %+ %1:
    %assign i i+1 
    %endrep
%endmacro