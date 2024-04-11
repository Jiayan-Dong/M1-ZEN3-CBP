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

    dummy_branch_align 200, 20

    inc rdi
    jmp randb0
    align (1 << 16)
    randb0:
    cmp byte[rdi],0
    jmp randb1
    align (1 << 16)
    randb1:
    je target1
    jmp randb2
    align (1 << 16)
    randb2:
    jne target1
    align (1 << 16)
    target1:
    align 64

    dummy_branch var,0
    dummy_branch_jmp var,5
    dummy_branch_jne var,10
;     dummy_branch_jmp_reg var,0

    ; test branch
    READ_PMC_START
    jmp colb0
    align (1 << 16)
    colb0:
    cmp byte[rdi],0
    jmp colb1
    align (1 << 16)
    colb1:
    je target2
    jmp colb2
    align (1 << 16)
    colb2:
    target2:
    align 64
    READ_PMC_END

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
            align 64
            %assign i j  
      %endrep
      label%+ j:
%endmacro

%macro dummy_branch_jmp 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      %rep %1
            %assign j i+1
            label%+ i:
            jmp label%+ j
            align 64
            %assign i j  
      %endrep
      label%+ j:
%endmacro

%macro dummy_branch_jne 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      %rep %1
            %assign j i+1
            label%+ i:
            cmp rax, 0
            jne label%+ j
            align 64
            %assign i j  
      %endrep
      label%+ j:
%endmacro

%macro dummy_branch_jmp_reg 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      %rep %1
            %assign j i+1
            label%+ i:
            mov rax, label%+ j
            jmp rax
            align 64
            %assign i j  
      %endrep
      label%+ j:
%endmacro

%macro dummy_branch_align 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      jmp label%+ i
      %rep %1
            %assign j i+1
            align (1 << 16)
            label%+ i:
            jmp label_a%+ i
            align (1 << 16)
            label_a%+ i:
            cmp rax, 0
            jmp label_b%+ i
            align (1 << 16)
            label_b%+ i:
            je label%+ j
            align 64
            %assign i j  
      %endrep
      label%+ j:
%endmacro