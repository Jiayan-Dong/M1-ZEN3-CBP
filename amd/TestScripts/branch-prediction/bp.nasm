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

    dummy_branch 200,5

    align (1 << 12)
    cmp byte[rdi],0
    align (1 << my_align)
    je target1
    ; jmp target1
    align (1 << my_align)
    target1:

    dummy_branch var,0

    ; test branch
    READ_PMC_START
    align 64
    cmp byte[rdi],0
    je target2
    target2:
    READ_PMC_END

%endmacro

%macro dummy_branch 2
      mov rax, 0
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      cmp rax, 0 ; ???
      %rep %1
            %assign j i+1
            label%+ i:
            align 64
            ; cmp rax, 0 ; ???
            je label%+ j 
            %assign i j  
      %endrep
      label%+ j:
%endmacro