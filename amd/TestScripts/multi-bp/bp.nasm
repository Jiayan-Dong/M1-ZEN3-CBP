; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  20             ; Nsumber of repetitions of whole test. Default = 8
%define repeat1  20000           ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100


%macro testinitc 0              ; Macro to call in each test before reading counters.

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

    align 1<<6

    mov r11, 300
    mov edx, 0
    mov eax, r12d
    div r11
    mov r10d, edx
    
    mov r11, 200
    mov edx, 0
    mov eax, r12d
    div r11

    cmp edx, 0
    je target1
    target1:

    cmp r10d, 0
    je target2
    target2:

    align 1<<6

%endmacro

%macro dummy_branch 2
      %assign i (100)*(%2)
      %assign j (100)*(%2)
      %rep %1
            %assign j i+1
            align 1<<16
            %rep 5
             nop
            %endrep
            label%+ i:
            jmp label%+ j 
            %assign i j  
      %endrep
      align 1<<16
      %rep 5
        nop
      %endrep
      label%+ j:
%endmacro