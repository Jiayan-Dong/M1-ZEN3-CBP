; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  50             ; Number of repetitions of whole test. Default = 8
%define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%include "../nops.inc"

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    %rep var
     nop 
    %endrep

%endmacro
