; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  20             ; Number of repetitions of whole test. Default = 8
%define repeat1  2000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100

%include "phr_model.nasm"
%include "phr_model_init.nasm"
%include "victim_phr_model.nasm"
%include "victim_phr_model_init.nasm"


%macro testinitc 0              ; Macro to call in each test before reading counters.

    PHR_Model_Init
    Victim_PHR_Model_Init

%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    victim: 
    Victim_PHR_Model
    cmp rdi, rdi
    je last_branch_victim
    last_branch_victim:
    nop

    PHR_Model
    cmp rdi, rdi
    jne attacker
    attacker:

%endmacro
