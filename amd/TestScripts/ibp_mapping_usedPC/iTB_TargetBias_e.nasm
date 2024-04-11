%include "../nops.inc"

%define repeat0  40              ; Number of repetitions of whole test. Default = 8
%define repeat1  2000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define clearPHR 1
%define setPHR   1
%define indTargetDistance 32

%macro testinitc 0              ; Macro to call in each test before reading counters.
    mov ebx, 1000
    lea rdi, [UserData]
    binary_generate:
    xor rax, rax
    mov rax, 1
    mov rcx, 0
    cmp ebx, 999
    cmovbe rax, rcx
    mov [rdi], al
    inc rdi
    dec ebx
    jnz binary_generate
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
    mov rcx, 1
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    
    mov r8, %+ indTargetDistance
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    
    %assign m 0
    %rep ijmp_number
        call initiate_PHR_%+ m
        %rep 64
         nop
        %endrep
        mfence
    %assign m m+1
    %endrep

    inc rcx
    inc rdi
    mov rax, 1
    lea rdx, [UserData]
    cmp rcx, 1000
    cmova rdi, rdx
    cmova rcx, rax

    %rep 64
     nop
    %endrep

%endmacro

%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov rax, %1
    jmp dummy_loop%+ %2
    align 1<<12
    %rep (1<<12)-(64)
     nop
    %endrep
    dummy_loop%+ %2:
    %rep 56
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
        %rep 1
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
        %rep 1
        nop
        %endrep
        history_target_jne_%+ %2_%+ i:
        %rep 32 
        nop
        %endrep
        %assign i i+1
    %endrep
%endmacro

%assign k 0
%rep ijmp_number
    SECTION .initiate_PHR_%+ k exec
    initiate_PHR_%+ k:
        ; CLEAR PHR
        %rep clearPHR
         CLEAR_PHR 30,k
        %endrep

        mfence
        ; SET PHR
        %rep setPHR
         SET_PHR 3,k
        %endrep

        lea r10, [indirect_target00_%+ k]
        add r10, r9
        mfence
        call ijmp_%+ k
        mfence
        ret

%assign k k+1
%endrep

SECTION .ijmp_0 exec
ijmp_0:
    ; INDIRECT JUMP A
    %rep 1<<shift
     nop
    %endrep
    jmp r10
    %rep 32 
    nop
    %endrep
indirect_target00_0:
    %rep indTargetDistance
    nop
    %endrep
indirect_target01_0:
    %rep 64 
    nop
    %endrep
    ret

SECTION .ijmp_1 exec
ijmp_1:
    ; INDIRECT JUMP A
    jmp r10
    %rep 32 
    nop
    %endrep
indirect_target00_1:
    %rep indTargetDistance
    nop
    %endrep
indirect_target01_1:
    %rep 64 
    nop
    %endrep
    ret