; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  1              ; Number of repetitions of whole test. Default = 8
%define repeat1  1              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100


%macro testinitc 0              ; Macro to call in each test before reading counters.
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    nop
%endmacro
