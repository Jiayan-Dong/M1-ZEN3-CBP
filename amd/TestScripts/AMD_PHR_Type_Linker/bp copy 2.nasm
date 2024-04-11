; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  20             ; Number of repetitions of whole test. Default = 8
%define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100


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

%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi, [UserData]
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    inc rdi

    cmp byte[rdi],0

    ; jmp rand_branch
    mov rdx, 300
    mov rax, 0x100000000
    mov rcx, 0x120000000
    mov rbx, rand_branch_back
    jmp rax
    rand_branch_back:

    ; dummy_branch 118, 5

    ; test branch
    READ_PMC_START
    cmp byte[rdi],0
    je target2
    target2:
    READ_PMC_END

%endmacro

lk_dummy_branch 3, 0

%macro lk_dummy_branch 2
    ; %assign i (%2)
    ; %assign j (%2)
    ; %rep %1
    ;     %assign j i+1
    ;     SECTION .dummy_branch_%+ i exec
    ;     dummy_label%+ i:
    ;     je dummy_label%+ j
    ;     %assign i j
    ; %endrep
%endmacro

%macro dummy_branch 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      %rep %1
            %assign j i+1
            label%+ i:
            cmp rax, 0
            je label%+ j 
            %assign i j  
      %endrep
    ;   align (1 << my_align)
      label%+ j:
%endmacro