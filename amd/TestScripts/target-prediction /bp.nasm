; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------

%define repeat0  50             ; Number of repetitions of whole test. Default = 8
%define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
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
    
    ; jmp start_test
    ; align 1<<20
    ; start_test:
    align 1<<5
    %assign i 1
    %rep var
     jmp target%+ i
     align 1<<5
     target%+ i:
     %assign i i+1
    %endrep

    ; Don't forget the last branch which is not visible here!
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