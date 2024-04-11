; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  20             ; Number of repetitions of whole test. Default = 8
%define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100

%macro testinitc 0              ; Macro to call in each test before reading counters.

    mov ebx, 8000
    lea rdi, [UserData]
    rand_loop:
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop

%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    inc rdi

    %assign i 0
    %rep 2
    %assign j i+100
    ; ------------------------
    mov r8, 32
    mov r9, 0
    cmp byte[rdi], 0
    cmovz r9, r8
    lea r11, indirect_target%+ i
    add r11, r9

    CLEAR_PHR 195, i

    cmp byte[rdi], 0
    %rep 3
     nop
    %endrep
    je cond_target%+ i
    align 1<<6
    cond_target%+ i:

    CLEAR_PHR 100, j

    %rep i<<6
     nop
    %endrep
    jmp r11
    indirect_target%+ i:
    %rep 64 
     nop
    %endrep
    ; ------------------------
    %assign i i+1
    %endrep
    
%endmacro

%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov r10, %1
    jmp clear_phr_loop%+ %2
    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    clear_phr_loop%+ %2:
    %rep 60
     nop
    %endrep
    dec r10
    jnz clear_phr_loop%+ %2
    ; ---------------- END of CLEAR PHR
%endmacro

%macro SHIFT_PHR 2
    ; ---------------- Start of SHIFT PHR
    mov r10, (%1)+1
    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    shift_phr_loop%+ %2:
    %rep 60
     nop
    %endrep
    dec r10
    jnz shift_phr_loop%+ %2
    ; ---------------- END of SHIFT PHR
%endmacro
