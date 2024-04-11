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
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    ; lea rcx, [indirect_target00]
    ; add rcx, r9

    ; CLEAR_PHR 200,1
    ; SET_PHR 5,1
    call indirect_branch1
    %rep 64
     nop
    %endrep
    
    ; -----------near direct jump-------------
    %assign i 0
    %rep 100
    %assign j i+1
    align 1<<15
    %rep 131
     nop
    %endrep
    jmp target_near%+ j
    %rep 16
     nop
    %endrep
target_near%+ j:
    %assign i i+1 
    %endrep
    ; -----------near direct jump-------------


    ; -----------far direct jump-------------
;     jmp start_test
;     align 1<<15
; start_test:
;     %rep 128
;      nop
;     %endrep
;     %assign i 1
;     %rep 30
;     jmp target_far%+ i
;     align 1<<15
; target_far%+ i:
;     %rep 128
;      nop
;     %endrep
;     %assign i i+1 
;     %endrep
    ; -----------far direct jump-------------


    %rep 127
     nop
    %endrep
    ; CLEAR_PHR 195,2
    ; SET_PHR 5,2
    call indirect_branch1

    ; -----------near direct jump-------------
    %assign i 0
    %rep 200
    %assign j i+1
    align 1<<15
    %rep 131
     nop
    %endrep
    jmp target_near_new%+ j
    %rep 16
     nop
    %endrep
target_near_new%+ j:
    %assign i i+1 
    %endrep
    ; -----------near direct jump-------------


    ; -----------far direct jump-------------
;     jmp start_test_new
;     align 1<<15
; start_test_new:
;     %rep 128
;      nop
;     %endrep
;     %assign i 1
;     %rep 30
;     jmp target_far_new%+ i
;     align 1<<15
; target_far_new%+ i:
;     %rep 128
;      nop
;     %endrep
;     %assign i i+1 
;     %endrep
    ; -----------far direct jump-------------


    %rep 64
     nop
    %endrep

%endmacro

SECTION .indirect_branch1 exec
    align 1<<15
indirect_branch1:
    ; %rep 32+99
    ;  nop
    ; %endrep
    ; jmp rcx
    ; %rep 1
    ;  nop
    ; %endrep
    ; indirect_target00:
    ; %rep 32 
    ;  nop
    ; %endrep
    ; indirect_target01:
    ; nop
    
    ; -----------near indirect jump-------------
    %rep 120
     nop
    %endrep
    %assign i 1
    %rep 1
    lea r10, [indirect_target_near0%+ i]
    add r10, r9
    jmp r10
    %rep 32
     nop
    %endrep
indirect_target_near0%+ i:
    %rep 32
     nop
    %endrep
indirect_target_near1%+ i:
    align 1<<15
    %rep 120
     nop
    %endrep
    %assign i i+1 
    %endrep
    ; -----------near indirect jump-------------


    ; -----------far indirect jump-------------
;     %rep 120
;      nop
;     %endrep
;     %assign i 1
;     %rep 1
;     lea r10, [indirect_target_far0%+ i]
;     add r10, r9
;     jmp r10
;     align 1<<15
; indirect_target_far0%+ i:
;     %rep 32
;         nop
;     %endrep
; indirect_target_far1%+ i:
;     %rep 56+32
;         nop
;     %endrep
;     %assign i i+1 
;     %endrep
    ; -----------far indirect jump-------------

    ret

%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov rax, %1
    jmp dummy_loop%+ %2
    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    dummy_loop%+ %2:
    %rep 64-8
     nop
    %endrep
    dec rax
    cmp rax, 0
    jg dummy_loop%+ %2
    ; ---------------- END of CLEAR PHR
%endmacro

%macro SET_PHR 2
    cmp rdx, 1
    %assign i 0
    %rep %1
        je history_target_je_%+ %2_%+ i
        %rep 16
        nop
        %endrep
        history_target_je_%+ %2_%+ i:
        %rep 32 
        nop
        %endrep
        %assign i i+1
    %endrep

    cmp rdx, 1
    %assign i 0
    %rep %1
        jne history_target_jne_%+ %2_%+ i
        %rep 16
        nop
        %endrep
        history_target_jne_%+ %2_%+ i:
        %rep 32 
        nop
        %endrep
        %assign i i+1
    %endrep
%endmacro



