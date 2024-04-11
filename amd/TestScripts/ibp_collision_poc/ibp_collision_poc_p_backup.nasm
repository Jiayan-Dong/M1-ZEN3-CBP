%include "../nops.inc"

%define repeat0  20              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define clearPHR 1
%define setPHR   1
%define indTargetDistance 32

%macro testinitc 0              ; Macro to call in each test before reading counters.
    mov dword[PrintCustomPMC], 1
    mov ebx, 2000             
    lea rdi, [UserData]
    rand_loop:
    clflush [rdi+4000]
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop
    ; xor rax, rax
    ; lea rdi, [UserData]
    ; mov [rdi], rax
    %rep 64
     nop
    %endrep
    lea rbx, [UserData]  
open_msr_file:
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
    ; lea rdi, [UserData]
    lea rbx, [UserData]
    mov [rbx+10000], rbx
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
    ; inc rdi
    mov r8, %+ indTargetDistance
    mov r9, 0
    xor rdx, rdx
    mov dl, byte[rdi]
    cmp rdx, 1
    cmovz r9, r8
    mov [rbx+11000], rdx
    inc rdi
    mov [rbx+10000], rdi

    clflush [rbx+4000]
    mfence
    ; READ_PMC_START
    call victim_ijmp
    ; READ_PMC_END

    ; clflush [rbx+4000]
    ; mov r10, [rbx+4000]
    READ_PMC_START
    lea rbx, [UserData]
    mfence
    mov r10, [rbx+4000]
    mfence
    READ_PMC_END

    ; lea rbx, [UserData]
    ; clflush [rbx+4000]
    ; mov r10, [rbx+4000]
    ; rdtscp
    ; shl rdx, 32
    ; or rax, rdx
    ; mov ecx, eax
    ; mfence
    ; mov r10, [rbx+4000]
    ; mfence
    ; rdtscp
    ; shl rdx, 32
    ; or rax, rdx
    ; sub eax, ecx
    ; mov dword[rbx+4008], eax

    ; READ_PMC_START
    ; lea rbx, [UserData]
    ; mov eax, dword[rbx+4008]
    ; cmp eax, 200
    ; jg c_target
    ; %rep 64
    ;  nop
    ; %endrep
    ; c_target:
    ; %rep 64
    ;  nop
    ; %endrep
    ; READ_PMC_END

    %rep 64
     nop
    %endrep
    COMMAND_IBPB 0
    ; COMMAND_IBRS 0
    %rep 64
     nop
    %endrep

    ; call attacker_ijmp

    ; READ_PMC_START
    lea rbx, [UserData]
    ; clflush [rbx+4000]
    ; mov r10, 0x15660000
    lea rbx, [UserData]
    mov rdx, [rbx+11000]
    xor rdx, 1
    mov [rbx+11000], rdx
    mov r8, 32
    mov r9, 0
    cmp rdx, 1
    cmovz r9, r8
    ; mov [rbx+110016], r9
    mfence
    mfence
    call attacker_ijmp
    ; READ_PMC_END
    

    %rep 64
     nop
    %endrep

    %rep 64
     nop
    %endrep

    ; xor rax, rax
    ; inc rdx
    ; cmp rdx, 2
    ; cmovae rdx, rax
    ; mov [rdi], rdx
    ; %rep 64
    ;  nop
    ; %endrep


%endmacro

%macro COMMAND_IBPB 1
pwrite_msr_file_ibpb%+ %1:
    SERIALIZE
    lea rbx, [UserData]

    mov rdi, [rbx+9000]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 73            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall

    SERIALIZE
    lea rbx, [UserData]
%endmacro

%macro COMMAND_IBRS 1
pwrite_msr_file_ibrs%+ %1:
    SERIALIZE
    lea rbx, [UserData]

    mov rdi, [rbx+9000]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 72            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall

    SERIALIZE
    lea rbx, [UserData]
%endmacro

%macro SET_PHR 2
    lea rbx, [UserData]
    mov rdx, [rbx+11000]
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


SECTION .attacker_ijmp exec
attacker_ijmp:
    lea rbx, [UserData]
    lea r10, [indirect_target00_0]
    add r10, r9
    mfence
    
    CLEAR_PHR 195,0
    SET_PHR 50,0
    CLEAR_PHR 1,1

    %rep 64+3
     nop
    %endrep
    ; INDIRECT JUMP A
    jmp r10
    %rep 32 
    nop
    %endrep
indirect_target00_0:
    mov r11b, byte[rbx+4000]
    %rep indTargetDistance
    nop
    %endrep
indirect_target01_0:
    mov r11b, byte[rbx+4000]
    %rep 64 
    nop
    %endrep
    ret

SECTION .victim_ijmp exec
victim_ijmp:
    lea rbx, [UserData]
    lea r10, [indirect_target00_1]
    add r10, r9
    mov [rbx+3000], r10
    clflush [rbx+3000]
    mfence

    CLEAR_PHR 195,2
    SET_PHR 50,2
    CLEAR_PHR 1, 3
    
    %rep 64
     nop
    %endrep
    ; INDIRECT JUMP A
    jmp [rbx+3000]
    %rep 0 
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

