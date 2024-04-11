%include "../nops.inc"

%define repeat0  40              ; Number of repetitions of whole test. Default = 8
%define repeat1  2000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define clearPHR 1
%define setPHR   1
%define indTargetDistance 32

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
    ; mov r8, %+ indTargetDistance
    ; mov r9, 0
    ; xor rdx, rdx
    ; mov dl, byte[rdi]
    ; cmp rdx, 1
    ; cmovz r9, r8
    ; mfence
    mov r8, %+ indTargetDistance
    mov r9, 0
    xor rdx, rdx
    mov rdx, [rdi]
    cmp rdx, 1
    cmovz r9, r8
    mfence

    %assign k 1
    %rep var
        lea r10, [indirect_target00_%+ k]
        add r10, r9
        mfence

        CLEAR_PHR_OLD 95,k

        ; SET_PHR_EVEN 1,k

        ; %assign j k+20
        ; CLEAR_PHR 5,j
        ; SET_PHR_EVEN 1,j

        ; %assign j k+50
        ; CLEAR_PHR var,j
        ; SET_PHR_ODD 1,j

        ; %assign j k+100
        ; CLEAR_PHR 10,j

        SET_PHR 6+k, k
        ; %assign j k+100
        ; CLEAR_PHR_OLD 1,j
        
        ; %rep 128-1
        ;  nop
        ; %endrep

        ijmp_%+ k:
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

    ; %assign k 10
    ; %rep 2
    ;     lea r10, [indirect_target00_%+ k]
    ;     add r10, r9
    ;     mfence

    ;     CLEAR_PHR 95,k

    ;     SET_PHR_ODD 1,k

    ;     ; %assign j k+20
    ;     ; CLEAR_PHR 3,j
    ;     ; SET_PHR_EVEN 1,j

    ;     %assign j k+100
    ;     CLEAR_PHR 4,j

    ;     %rep 64*k-1
    ;      nop
    ;     %endrep
    ;     ijmp_%+ k:
    ;     ; INDIRECT JUMP A
    ;     jmp r10
    ;     %rep 32 
    ;     nop
    ;     %endrep
    ;     indirect_target00_%+ k:
    ;     %rep indTargetDistance
    ;      nop
    ;     %endrep
    ;     indirect_target01_%+ k:
    ;     %rep 64
    ;      nop
    ;     %endrep
    ; %assign k k+1
    ; %endrep

    xor rax, rax
    inc rdx
    cmp rdx, 2
    cmovae rdx, rax
    mov [rdi], rdx

    %rep 64
     nop
    %endrep

%endmacro

%macro CLEAR_PHR 2
    ; ---------------- Start of CLEAR PHR
    mov rax, %1
    jmp dummy_loop%+ %2
    align 1<<19
    %rep (1<<19)-64-60
     nop
    %endrep
    dummy_loop%+ %2:
    %rep 60
     nop
    %endrep
    shift_phr_loop%+ %2:
    %rep 64-8
     nop
    %endrep
    dec rax
    cmp rax, 0
    jg shift_phr_loop%+ %2
    ; ---------------- END of CLEAR PHR
%endmacro


%macro CLEAR_PHR_OLD 2
    ; ---------------- Start of CLEAR PHR
    mov rax, %1
    jmp dummy_loop%+ %2
    align 1<<19
    %rep (1<<19)-64
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

%macro SET_PHR_BOTH 2
    cmp rdx, 1
    %assign i 0
    je history_target_je_%+ %2_%+ i
    align 1<<6
    %rep 3
     nop
    %endrep
    history_target_je_%+ %2_%+ i:
    %rep 180-128
     nop
    %endrep
%endmacro

%macro SET_PHR_ODD 2
    cmp rdx, 1
    %assign i 0
    je history_target_je_%+ %2_%+ i
    align 1<<6
    %rep 2
     nop
    %endrep
    history_target_je_%+ %2_%+ i:
    %rep 180-127
     nop
    %endrep
%endmacro

%macro SET_PHR_EVEN 2
    cmp rdx, 1
    %assign i 0
    je history_target_je_%+ %2_%+ i
    align 1<<6
    %rep 1
     nop
    %endrep
    history_target_je_%+ %2_%+ i:
    %rep 180-126
     nop
    %endrep
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