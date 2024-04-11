%include "../nops.inc"
%include "./PHR_Maker_0.nasm"
%include "./PHR_Maker_1.nasm"

%define repeat0  20              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define PRINT_CUSTOM_PMC 1

%macro testinitc 0              ; Macro to call in each test before reading counters.
    mov dword[PrintCustomPMC], PRINT_CUSTOM_PMC

    mov ebx, 1500             
    lea rdi, [UserData]
    rand_loop:
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop

    lea rdi, [UserData]
    lea rbx, [UserData]
    mov [rbx+2000], rdi                                                                                                                                                                                 
    mov rcx, 100
ijmp_initial:
    mov rdi, [rbx+2000]
    mov r8, 32
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    inc rdi
    mov [rbx+2000], rdi
    mov [rbx+2008], rdx
    mov [rbx+2016], r9
    mov [rbx+2032], rcx
    mfence
    %rep 64
     nop
    %endrep
    call test_1
    %rep 64
     nop
    %endrep
    mov rcx, [rbx+2032]
    dec rcx
    jnz ijmp_initial

    %rep 64
     nop
    %endrep
open_msr_file:
    mov rdi, msr_file_name
    mov rsi, open_flag     ; Second argument: flags (O_WRONLY)
    mov rax, syscall_open
    syscall                
    mov [rbx+2024], rax ; store the msr file descriptor
    %rep 512
     nop
    %endrep
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
    lea rbx, [UserData]
    mov [rbx+2000], rdi
%endmacro

%macro testafter3 0 
close_msr_file:
    lea rbx, [UserData]
    mov rdi, [rbx+2024]    ; First argument: file descriptor
    mov rax, syscall_close
    syscall
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    lea rbx, [UserData]
    mov rdi, [rbx+2000]
    mov r8, 32
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    inc rdi
    mov [rbx+2000], rdi ; store the current address of UserData
    mov [rbx+2008], rdx ; store the input of this time's test
    mov [rbx+2016], r9
    mfence

    ; call evict_ijmp
    COMMAND_IBPB 1
    %rep 512
     nop
    %endrep

first:
    ; !!!!!!!!!!!!!! custom counter test starts
    READ_PMC_START
    call test_1
    READ_PMC_END
    ; !!!!!!!!!!!!!! custom counter test ends
    %rep 512
     nop
    %endrep
    
    ; flip the input
    lea rbx, [UserData]
    mov rdx, [rbx+2008]
    xor rdx, 1
    mov [rbx+2008], rdx
    mov r8, 32
    mov r9, 0
    cmp rdx, 1
    cmovz r9, r8
    mov [rbx+2016], r9
    mfence
second:
    call test_1
    %rep 512
     nop
    %endrep
%endmacro

%macro COMMAND_IBPB 1
pwrite_msr_file%+ %1:
    SERIALIZE
    lea rbx, [UserData]

    mov rdi, [rbx+2024]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 73            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall

    SERIALIZE
    lea rbx, [UserData]
%endmacro

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
    lea rbx, [UserData]
    mov rdx, [rbx+2008]
    cmp rdx, 1
    %assign i 0
    %rep %1
        je history_target_je_%+ %2_%+ i
        %rep 64
        nop
        %endrep
        history_target_je_%+ %2_%+ i:
        %rep 64
        nop
        %endrep
        %assign i i+1
    %endrep

    cmp rdx, 1
    %assign i 0
    %rep %1
        jne history_target_jne_%+ %2_%+ i
        %rep 64
        nop
        %endrep
        history_target_jne_%+ %2_%+ i:
        %rep 64
        nop
        %endrep
        %assign i i+1
    %endrep
%endmacro

SECTION .ijmp exec
test_1:
    %rep 64
     nop
    %endrep
    lea rbx, [UserData]
    CLEAR_PHR 195, 0
    SET_PHR 50, 0
    align 1<<15
    %rep 7<<5
     nop
    %endrep
    mov r9, [rbx+2016]
    lea r10, [indirect_target0]
    add r10, r9
    mfence
    jmp r10
    %rep 32
     nop
    %endrep
indirect_target0:
    %rep 32
     nop
    %endrep
indirect_target1:
    %rep 64
     nop
    %endrep
    ret

SECTION .evict_ijmp exec
evict_ijmp:
    %assign i 1
    %rep 24
        align 1<<15
        %rep 7<<5
        nop
        %endrep
        %rep 21
         nop
        %endrep
        jmp direct_target%+ i
        %rep 64
         nop
        %endrep
direct_target%+ i:
    %assign i i+1
    %endrep
    ret
