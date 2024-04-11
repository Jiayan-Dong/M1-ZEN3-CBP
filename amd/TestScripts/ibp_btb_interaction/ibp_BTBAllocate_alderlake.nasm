%include "../nops.inc"

%define repeat0  10              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2

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
    mov r8, 64
    mov r9, 0
    cmp byte[rdi], 0
    cmovz r9, r8 


    jmp start_test
    align 1<<16
    %rep 128
        nop
    %endrep
start_test:
    %assign i 1
    %rep var ;number of indirect jumps
    lea r10, [target0%+ i]
    add r10, r9
    jmp r10
    align 1<<16
target0%+ i:
    %rep 64
        nop
    %endrep
target1%+ i:
    %rep 64
        nop
    %endrep
    %assign i i+1 
    %endrep

    %rep 64
     nop
    %endrep

%endmacro

; SECTION .indirect_branch exec
;     align 1<<15
; indirect_branch:
;     %rep 64
;         nop
;     %endrep
;     jmp r10
;     target00:
;     %rep 32 
;      nop
;     %endrep
;     target01:
;     nop
;     ret
