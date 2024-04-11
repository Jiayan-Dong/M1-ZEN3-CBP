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
    align 1<<15
start_test:
    jmp target1
    ; align 1<<31, detect BTB miss
    ; %REP 0FFFFH
    ;     %REP 1000H
    ;         nop8
    ;     %ENDREP
    ; %ENDREP

    ; %REP 7FFBH
    ;     nop
    ; %ENDREP

    align 1<<30, detect BTB miss
    %REP 7FFFH
        %REP 1000H
            nop8
        %ENDREP
    %ENDREP

    %REP 7FFBH
        nop
    %ENDREP
    
    ; align 1<<29, not detect BTB miss
    ; %REP 3FFFH
    ;     %REP 1000H
    ;         nop8
    ;     %ENDREP
    ; %ENDREP

    ; %REP 7FFBH
    ;     nop
    ; %ENDREP
    
    ; align 1<<27
target1:
    jmp target2

target2:


    %rep 16
     nop8
    %endrep

%endmacro
