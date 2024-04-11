
; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  20             ; Number of repetitions of whole test. Default = 8
%define repeat1  4000           ; Repeat count for loop around testcode. Default = no loop
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
    
    ; dummy_branch 300, 0

    ; jmp rand_branch
    mov rax, 0x100000000
    mov rbx, rand_branch_back
    mov rdx, 200
    mov rcx, 0
    cmp rcx, 0
    jmp rax
    rand_branch_back:

    dummy_branch var, 5

    ; test branch
    READ_PMC_START
    cmp byte[rdi],0
    je target2
    target2:
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
            %assign i j  
      %endrep
    ;   align (1 << my_align)
      label%+ j:
%endmacro

SECTION .dummy_branch_0 exec
    dummy_label_0:
    dec rdx
    cmp rdx, 0 
    jmp dummy_label_1

SECTION .dummy_branch_1 exec
    dummy_label_1:
    jne dummy_label_0
    jmp dummy_label_2

SECTION .dummy_branch_2 exec
    dummy_label_2:
    cmp byte[rdi],0
    align (1 << b_align)
    je rand_target
    align (1 << t_align)
    rand_target:
    jmp rbx

    ; je dummy_label_3

; SECTION .dummy_branch_3 exec
;     dummy_label_3:
;     je dummy_label_4

; SECTION .dummy_branch_4 exec
;     dummy_label_4:
;     je dummy_label_5
