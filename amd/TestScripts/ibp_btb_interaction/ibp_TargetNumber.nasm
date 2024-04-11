%include "../nops.inc"

%define repeat0  50             ; Number of repetitions of whole test. Default = 8
; %define repeat1  2000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100

%macro testinitc 0              ; Macro to call in each test before reading counters.
    xor rax, rax
    lea rdi, [UserData]
    mov [rdi], rax
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    ; BEGIN --------------- calculate target distance 
    xor rdx, rdx
    mov rdx, [rdi]
    mov rcx, rdx
    shl rcx, 6
    ; END --------------- calculate target distance

    ; BEGIN --------------- a bunch of conditional jumps to create contexts
    jmp start
    align 1<<16
start:
    %assign i 0
    %rep var
    cmp rdx, %+ i
    je target0_%+ i
    %rep i
     nop
    %endrep
    %assign i i+1
    %endrep

    align 1<<6
    %assign i 0
    %rep var
target0_%+ i:
    %rep 64
     nop
    %endrep
    ;jmp target0_end
    %assign i i+1
    %endrep
;target0_end:
    ; END --------------- a bunch of conditional jumps to create contexts

    ; %assign i 0
    ; %rep 30
    ;     jmp dummy_target%+ i
    ; dummy_target%+ i:
    ;     %rep 64
    ;         nop
    ;     %endrep
    ; %assign i i+1
    ; %endrep
    ; call clear_phr

    %rep 512
     nop
    %endrep

    ; BEGIN --------------- correlated indirect branch
%rep ibranch
    lea rbx, [target1_0]
    add rbx, rcx
    jmp rbx
    align 1<<6
    %assign i 0
    %rep var
target1_%+ i:
    %rep 64
     nop
    %endrep
    ;jmp target1_end
    %assign i i+1
    %endrep
;target1_end:
%endrep
    ; END --------------- correlated indirect branch

    %rep 64
     nop
    %endrep

    ; BEGIN --------------- make userData loop from 0 to var-1
    xor rax, rax
    inc rdx
    cmp rdx, %+ var
    cmovae rdx, rax
    mov [rdi], rdx
    ; END --------------- make userData loop from 0 to var-1

    %rep 64
     nop
    %endrep

%endmacro


SECTION .clear_phr exec
clear_phr:
    jmp start_clear
    align 1<<16
    start_clear:
    mov r10, 200
    align 1<<5
    dummy_loop:
    dec r10
    align 1<<10
    %assign j (1<<10)-5
    %rep j
     nop
    %endrep
    jnz dummy_loop
    ret