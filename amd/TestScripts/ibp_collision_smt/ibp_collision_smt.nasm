%include "../nops.inc"

%define nthreads 2
%define repeat0  20              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2
%define clearPHR 1
%define setPHR   1
%define indTargetDistance 32

%define t2_repeat1 1000
%define t2_repeat2 1

%macro testinitc 0              ; Macro to call in each test before reading counters.
    
acquire_spinlock_init:
    mov   eax, 1
    xchg  eax, dword[thread_lock]
    test  eax, eax
    jnz   acquire_spinlock_init

    mov eax, dword[inputGen_counter]
debug_init:
    cmp dword[inputGen_counter], 1
    je reset_counter

    mov dword[PrintCustomPMC], 1
    mov ebx, 4000
    lea rdi, [UserData]
    rand_loop:
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop
    %rep 64
     nop
    %endrep
    inc dword[inputGen_counter]
    jmp release_spinlock_init

reset_counter:
    dec dword[inputGen_counter]
release_spinlock_init:
    mfence
    dec dword[thread_lock]

open_msr_file:
    lea rbx, [UserData]
    mov rdi, msr_file_name
    mov rsi, open_flag     ; Second argument: flags (O_WRONLY)
    mov rax, syscall_open
    syscall                
    mov [rbx+4024], rax
    %rep 512
     nop
    %endrep
%endmacro

%macro testinit0 0              ; Macro with initializations before each test. Default = nothing
    lea rbx, [UserData]
    mov [rbx+4008], rbx
%endmacro

%macro testafter3 0 
close_msr_file:
    lea rbx, [UserData]
    mov rdi, [rbx+4024]    ; First argument: file descriptor
    mov rax, syscall_close
    syscall
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.
acquire_spinlock_0:
    mov   eax, 1
    lock cmpxchg dword[thread_lock], eax
    test  eax, eax
    jnz   acquire_spinlock_0
    
    mov rdi, [rbx+4008]
    xor rdx, rdx
    mov dl, byte[rdi]
    mov [rbx+4016], rdx
    inc rdi
    mov [rbx+4008], rdi

    ; call evict_ijmp
    ; COMMAND_IBPB 0
    ; COMMAND_IBRS 0
    ; %rep 64
    ;  nop
    ; %endrep
    %rep 1
     clflush [rbx+8192]
     mfence
    %endrep

    ; READ_PMC_START
    call victim_ijmp
    ; READ_PMC_END

    ; READ_PMC_START
    ; mov rdx, [rbx+4016]
    ; xor rdx, 1
    ; mov [rbx+4016], rdx
    ; clflush [rbx+8192]
    ; mfence
    ; call victim_ijmp
    ; READ_PMC_END
    ; %rep 64
    ;  nop
    ; %endrep

    ; clflush [rbx+8192]
    ; mov r10, [rbx+8192]
    READ_PMC_START
    mfence
    mov r10, [rbx+8192]
    mfence
    READ_PMC_END
release_spinlock_0:
    mfence
    inc dword[thread_lock]

    %rep 64
     nop
    %endrep
%endmacro

%macro t2_testcode 0
acquire_spinlock_1:
    mov   eax, 0
    lock cmpxchg dword[thread_lock], eax
    test  eax, eax
    jz   acquire_spinlock_1

    lea rdi, [UserData+2000]
    mov [rbx+5008], rdi
    mov rcx, 10
attacker_ijmp_initial:
    mov rdi, [rbx+5008]
    xor rdx, rdx
    mov dl, byte[rdi]
    mov [rbx+4016], rdx
    inc rdi
    mov [rbx+5008], rdi
    mov [rbx+5016], rcx
    mfence
    %rep 64
     nop
    %endrep
    call attacker_ijmp
    %rep 64
     nop
    %endrep
    mov rcx, [rbx+5016]
    dec rcx
    jnz attacker_ijmp_initial
    %rep 64
     nop
    %endrep

release_spinlock_1:
    mfence
    dec dword[thread_lock]
    %rep 64
     nop
    %endrep

%endmacro

%macro COMMAND_IBPB 1
pwrite_msr_file_ibpb%+ %1:
    SERIALIZE
    lea rbx, [UserData]

    mov rdi, [rbx+4024]    ; First argument: file descriptor
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

    mov rdi, [rbx+4024]    ; First argument: file descriptor
    mov rsi, data          ; Second argument: pointer to data
    mov rdx, 8             ; Third argument: count (number of bytes to write)
    mov r10, 72            ; Fourth argument: offset
    mov rax, syscall_pwrite
    syscall

    SERIALIZE
    lea rbx, [UserData]
%endmacro

%macro SET_PHR 2
    mov rdx, [rbx+4016]
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


SECTION .victim_ijmp exec
victim_ijmp:
    mov rdx, [rbx+4016]
    lea r10, [indirect_target00_1]
    lea r9, [indirect_target01_1]
    cmp rdx, 1
    cmovz r10, r9
    mov [rbx+4128], r10
    clflush [rbx+4128]
    mov rcx, 8192
    mfence

    CLEAR_PHR 195,2
    SET_PHR 10,2
    CLEAR_PHR 1, 3
    %rep 64
     nop
    %endrep
debug_victim:
    jmp [rbx+4128]
    %rep 32
    nop
    %endrep
indirect_target00_1:
    %rep 32
    nop
    %endrep
indirect_target01_1:
    %rep 32 
    nop
    %endrep
    ret

SECTION .attacker_ijmp exec
attacker_ijmp:
    mov rdx, [rbx+4016]
    lea r10, [indirect_target00_0]
    lea r9, [indirect_target01_0]
    cmp rdx, 1
    cmovz r10, r9
    mov rcx, 9500
    mfence
    
    CLEAR_PHR 195,0
    SET_PHR 10,0
    CLEAR_PHR 1,1
    %rep 64+3
     nop
    %endrep
    ; %rep 1024
    ;  nop
    ; %endrep
debug_attacker:
    jmp r10
    %rep 32 
    nop
    %endrep
indirect_target00_0:
    mov r11, [rbx+rcx]
    %rep 32
     nop
    %endrep
    ret
indirect_target01_0:
    mov r11, [rbx+rcx]
    %rep 64
     nop
    %endrep
    ret
