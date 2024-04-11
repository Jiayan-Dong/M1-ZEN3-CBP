; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  50             ; Number of repetitions of whole test. Default = 8
%define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    
    jmp start_test
    align 1<<25
    start_test:
    %rep 27
     nop
    %endrep
    jmp t_1
    align 1<<25
    %rep var
     nop
    %endrep
    t_1:
    jmp t_2
    t_2:

    %rep 64
     nop
    %endrep

%endmacro