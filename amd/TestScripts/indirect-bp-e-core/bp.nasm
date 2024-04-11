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
    %rep var
    %assign j i*100
    ; ------------------------
    mov r8, 32
    mov r9, 0
    cmp byte[rdi], 0
    cmovz r9, r8 
    lea r11, indirect_target1%+ i
    add r11, r9

    CLEAR_PHR 30, i

    %rep (1<<12)-(5)
     nop
    %endrep
    %rep 0
     nop
    %endrep
    cmp byte[rdi], 0
    je cond_target%+ i
    align 1<<6
    %rep 1
     nop
    %endrep
    cond_target%+ i:

    SHIFT_PHR 6, j

    align 1<<15
    %rep i<<5
     nop
    %endrep
    jmp r11
    %rep 32 
     nop
    %endrep
    indirect_target1%+ i:
    %rep 32 
     nop
    %endrep
    indirect_target2%+ i:
    %rep 32 
     nop
    %endrep
    ; ------------------------
    %assign i i+1
    %endrep

%endmacro


%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov r10, (%1)+1
    jmp dummy_loop%+ %2
    align 1<<12
    %rep (1<<12)-(64)
     nop
    %endrep
    dummy_loop%+ %2:
    %rep 60
     nop
    %endrep
    dec r10
    jg dummy_loop%+ %2
    ; ---------------- END of CLEAR PHR
%endmacro

%macro SHIFT_PHR 2
    %assign k %2
    %rep %1
     jmp shift_target%+ k
     align 1<<4
     shift_target%+ k: 
     %assign k k+1
    %endrep
%endmacro