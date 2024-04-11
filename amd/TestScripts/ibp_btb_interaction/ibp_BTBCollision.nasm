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
    mov r8, 32
    mov r9, 0
    cmp byte[rdi], 0
    cmovz r9, r8 

    jmp start_test
    align 1<<15
start_test:
    %rep 128
     nop
    %endrep
    %assign i 1
    %rep 11
    jmp target_far%+ i
    align 1<<15
target_far%+ i:
    %rep 128
     nop
    %endrep
    %assign i i+1 
    %endrep

    
    cmp byte[rdi], 0
    align 1<<5
    je c_target01
    %rep 32
     nop
    %endrep
    c_target01:
    %rep 64
     nop
    %endrep

    ; call conditional_branch
    ; %rep 1000 
    ;  nop
    ; %endrep

    lea r10, [indirect_target00]
    add r10, r9
    call indirect_branch_a
    %rep 64 
     nop
    %endrep
    ;call direct_branch


    ; create different history for indirect branch b
    %assign i 0
    %rep 10
    jmp target%+ i
target%+ i:
    %rep 64
     nop
    %endrep
    %assign i i+1
    %endrep

    lea r10, [indirect_target10]
    add r10, r9
    call indirect_branch_b
    %rep 64 
     nop
    %endrep

    ;call direct_branch
    %rep 64 
     nop
    %endrep
%endmacro

SECTION .conditional_branch exec
conditional_branch:
    %rep 62
        nop
    %endrep
    cmp byte[rdi], 0
    je conditional_target1
    conditional_target0:
    %rep 32 
     nop
    %endrep
    conditional_target1:
    %rep 64 
     nop
    %endrep
    ret

SECTION .direct_branch exec
direct_branch:
    %rep 65
        nop
    %endrep
    jmp direct_target
    %rep 64 
     nop
    %endrep
    direct_target:
    %rep 64 
     nop
    %endrep
    ret

SECTION .indirect_branch_a exec
indirect_branch_a:
    %rep 2
     nop
    %endrep
    jmp r10
    %rep 32
     nop
    %endrep
    indirect_target00:
    %rep 32
     nop
    %endrep
    indirect_target01:
    %rep 64 
     nop
    %endrep
    ret

SECTION .indirect_branch_b exec
indirect_branch_b:
    %rep 2
     nop
    %endrep
    jmp r10
    %rep 32
     nop
    %endrep
    indirect_target10:
    %rep 32
     nop
    %endrep
    indirect_target11:
    %rep 64 
     nop
    %endrep
    ret


SECTION .clear_phr exec
clear_phr:
    jmp start_clear
    align 1<<16
    start_clear:
    mov r10, 200
    align 1<<5
    dummy_loop:
    dec r10
    align 1<<11
    jnz dummy_loop
    ret