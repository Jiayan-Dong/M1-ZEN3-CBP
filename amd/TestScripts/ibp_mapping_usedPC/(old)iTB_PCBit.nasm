%include "../nops.inc"

%define repeat0  10              ; Number of repetitions of whole test. Default = 8
%define repeat1  2000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define indTargetDistance 64

%macro testinitc 0              ; Macro to call in each test before reading counters.
    ; mov ebx, 8000             
    ; lea rdi, [UserData]
    ; rand_loop:
    ; rdrand eax
    ; and eax, 1
    ; mov [rdi], al
    ; inc rdi
    ; dec ebx
    ; jnz rand_loop
    xor rax, rax
    lea rdi, [UserData]
    mov [rdi], rax
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    ; inc rdi
    ; mov r8, %+ indirect_target_distance
    ; mov r9, 0
    ; xor rdx, rdx
    ; mov dl, byte[rdi]
    ; cmp rdx, 1
    ; cmovz r9, r8
    
    mov r8, %+ indirect_target_distance
    mov r9, 0
    xor rdx, rdx
    mov rdx, [rdi]
    cmp rdx, 1
    cmovz r9, r8

    ; cmp rdx, 1
    ; je c_target
    ; %rep 16
    ;  nop
    ; %endrep
    ; c_target:
    ; %rep 64
    ;  nop
    ; %endrep

    mfence
    ;--------------BEGIN SET PHR
    call clear_phr
    align 1<<15
    %assign j (1<<15) - 4
    %rep j
    nop
    %endrep
    call history_branch
    ;--------------END SET PHR

    lea r10, [indirect_target00]
    add r10, r9
    align 1<<var
    jmp r10
    %rep 32 
     nop
    %endrep
indirect_target00:
    %rep indirect_target_distance
     nop
    %endrep
indirect_target01:
    nop
    
    mfence
    ;--------------BEGIN SET PHR
    call clear_phr
    align 1<<15
    %assign j (1<<15) - 4
    %rep j
    nop
    %endrep
    call history_branch
    ;--------------END SET PHR

    lea r11, [indirect_target10]
    add r11, r9
    align 1<<var
    jmp r11
    %rep 32 
     nop
    %endrep
indirect_target10:
    %rep indirect_target_distance
     nop
    %endrep
indirect_target11:
    nop

    mfence

    xor rax, rax
    inc rdx
    cmp rdx, 2
    cmovae rdx, rax
    mov [rdi], rdx

    %rep 64
     nop
    %endrep

%endmacro

SECTION .history_branch exec align=64
history_branch:
    ; xor rax, rax
    ; cmp rax, 0
    ; %assign i 0
    ; %rep 18
    ; je history_target%+ i
    ; %rep 8
    ;  nop
    ; %endrep
    ; history_target%+ i:
    ; %rep 64 
    ;  nop
    ; %endrep
    ; %assign i i+1
    ; %endrep

    cmp rdx, 1
    %assign i 0
    %rep 18
    je history_target%+ i
    %rep 64
     nop
    %endrep
    history_target%+ i:
    %rep 64 
     nop
    %endrep
    %assign i i+1
    %endrep

    cmp rdx, 1
    %rep 18
    jne history_target%+ i
    %rep 64
     nop
    %endrep
    history_target%+ i:
    %rep 64 
     nop
    %endrep
    %assign i i+1
    %endrep
    ret


SECTION .clear_phr exec
clear_phr:
    jmp start_clear
    align 1<<16
    start_clear:
    mov rax, 200
    align 1<<5
    dummy_loop:
    dec rax
    align 1<<10
    %assign j (1<<10)-5
    %rep j
     nop
    %endrep
    jnz dummy_loop
    ret