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
    align 1<<5
    start_test:
    %assign i 0
    %rep var
     jmp target%+ i
     align 1<<5
     target%+ i: 
     %assign i i+1
    %endrep

    ; Don't forget the last branch which is not visible here!
%endmacro
