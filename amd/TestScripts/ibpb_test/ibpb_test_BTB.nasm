%include "../nops.inc"

%define repeat0  20              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2

%macro testinitc 0              ; Macro to call in each test before reading counters.
    mov dword[PrintCustomPMC], 1
    mov ebx, 8000             
    lea rdi, [UserData]
    rand_loop:
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop

open_msr_file:
    lea rbx, [UserData]
    mov rdi, msr_file_name
    mov rsi, open_flag     ; Second argument: flags (O_WRONLY)
    mov rax, syscall_open
    syscall                
    mov [rbx+9000], rax
    %rep 512
     nop
    %endrep
%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
    lea rbx, [UserData]
    mov [rbx+10000], rdi
%endmacro

%macro testafter3 0 
close_msr_file:
    lea rbx, [UserData]
    mov rdi, [rbx+9000]    ; First argument: file descriptor
    mov rax, syscall_close
    syscall
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
    lea rbx, [UserData]
    mov rdi, [rbx+10000]
    mov r8, 32
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    mov [rbx+11000], rdx
    inc rdi
    mov [rbx+10000], rdi

    ; CLEAR_PHR 195,1
    mov r8, 0 ; counter
    %rep 64
     nop
    %endrep

branch_test_start:
    ; indirect branch
    READ_PMC_START
    %assign i 0
    %rep 1
    lea r10, [indirect_target0_%+ i]
    add r10, r9
    jmp r10
    %rep 1
     nop
    %endrep
indirect_target0_%+ i:
    %rep 32
     nop
    %endrep
indirect_target1_%+ i:
    %rep 64
     nop
    %endrep
    %assign i i+1
    %endrep

    ; direct branch
    %assign i 0
    %rep 0
    jmp direct_target%+ i
    %rep 32
     nop
    %endrep
direct_target%+ i:
    %rep 64
     nop
    %endrep
    %assign i i+1
    %endrep

    ; conditional branch
    %assign i 0
    %rep 0
    lea rbx, [UserData]
    mov r10, [rbx+11000]
    cmp r10, 1
    je conditional_target%+ i
    %rep 32
     nop
    %endrep
conditional_target%+ i:
    %rep 64
     nop
    %endrep
    %assign i i+1
    %endrep

    cmp r8, 1
    je branch_test_end
    inc r8
    %rep 64
     nop
    %endrep
    COMMAND_IBPB 1
    ; COMMAND_IBRS 1
    %rep 512
     nop
    %endrep
    jmp branch_test_start
    %rep 64
     nop
    %endrep

branch_test_end:
    READ_PMC_END
    %rep 64
     nop
    %endrep

%endmacro

%macro COMMAND_IBPB 1
pwrite_msr_file_ibpb%+ %1:
    lea rbx, [UserData]
    mov rdi, [rbx+9000]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 73            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall
%endmacro

%macro COMMAND_IBRS 1
pwrite_msr_file_ibrs%+ %1:
    lea rbx, [UserData]
    mov rdi, [rbx+9000]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 72            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall
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
    mov rdx, [rbx+11000]
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
