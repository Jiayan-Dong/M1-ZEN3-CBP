%include "../nops.inc"

%define repeat0  40              ; Number of repetitions of whole test. Default = 8
%define repeat1  2000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define clearPHR 1
%define setPHR   1
%define indTargetDistance 32

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
    mov r8, %+ indTargetDistance
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    mfence

    %assign k 1
    %rep ijmp_number
        
        lea r10, [indirect_target00_%+ k]
        add r10, r9
        mfence
        
        %rep clearPHR
         CLEAR_PHR 30,k
        %endrep

        %rep setPHR
         SET_PHR 1,k
        %endrep
        
        %rep varIsSet 
         %assign j k+100
         CLEAR_PHR var,j
        %endrep

        %rep 32*k-1
         nop
        %endrep
        ijmp_%+ k:
        ; INDIRECT JUMP A
        jmp r10
        %rep 32 
        nop
        %endrep
        indirect_target00_%+ k:
        %rep indTargetDistance
         nop
        %endrep
        indirect_target01_%+ k:
        %rep 64
         nop
        %endrep
    %assign k k+1
    %endrep


    %rep 64
     nop
    %endrep

%endmacro

%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov rax, %1
    jmp dummy_loop%+ %2
    align 1<<12
    %rep (1<<12)-(16)
     nop
    %endrep
    dummy_loop%+ %2:
    %rep 8
     nop
    %endrep
    dec rax
    cmp rax, 0
    jg dummy_loop%+ %2
    ; ---------------- END of CLEAR PHR
%endmacro

%macro SET_PHR 2
    ; cmp rdx, 1
    ; %assign i 0
    ; %rep %1
    ;     align 1<<4
    ;     je history_target_je_%+ %2_%+ i
    ;     align 1<<4
    ;     %rep 3
    ;      nop
    ;     %endrep
    ;     history_target_je_%+ %2_%+ i:
    ;     %rep 32
    ;     nop
    ;     %endrep
    ;     %assign i i+1
    ; %endrep
    ; align 1<<4
    ; %rep 16-9
    ;  nop
    ; %endrep

    ; cmp rdx, 1
    ; %assign i 0
    ; %rep %1
    ;     je history_target_je_%+ %2_%+ i
    ;     align 1<<4
    ;     %rep 3
    ;      nop
    ;     %endrep
    ;     history_target_je_%+ %2_%+ i:
    ;     %rep 32 
    ;     nop
    ;     %endrep
    ;     %assign i i+1
    ; %endrep

    ; cmp rdx, 1
    ; %assign i 0
    ; %rep %1
    ;     jne history_target_jne_%+ %2_%+ i
    ;     align 1<<4
    ;     %rep 3
    ;      nop
    ;     %endrep
    ;     history_target_jne_%+ %2_%+ i:
    ;     %rep 32 
    ;     nop
    ;     %endrep
    ;     %assign i i+1
    ; %endrep

    cmp rdx, 1
    %assign i 0
    align 1<<4
    %rep 0
     nop
    %endrep
    je history_target_je_%+ %2_%+ i
    align 1<<4
    %rep 0
     nop
    %endrep
    history_target_je_%+ %2_%+ i:
    %rep 17
     nop
    %endrep

    jne history_target_jne_%+ %2_%+ i
    align 1<<4
    %rep 0
     nop
    %endrep
    history_target_jne_%+ %2_%+ i:
    %rep 55
     nop
    %endrep
%endmacro
