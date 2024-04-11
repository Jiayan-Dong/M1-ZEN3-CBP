; ------------------------------------
; Author: Hosein Yavarzadeh 
; Email: hyavarzadeh@ucsd.edu
; Supervisor: Prof. Dean Tullsen
; ------------------------------------
; Don't modify r12, r13, r14, r15!
; ------------------------------------

%define repeat0  1000           ; Number of repetitions of whole test. Default = 8
%define repeat1  1              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100


%macro testinitc 0              ; Macro to call in each test before reading counters.

    ; CLFLUSH the specified data from all cache levels (L1, L2, and L3)
    lea rdi,[UserData]
    clflush [rdi]
    clflush [rdi+64]
    clflush [rdi+128]
    mfence              ; For synchronization purpose

    ; Calling the victim 
    mov ebx, 1000
    align 1<<6
    call_victim:
    rdrand r9
    and r9, 1
    victim
    dec ebx
    jnz call_victim
    ; mfence

%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    lea rdi,[UserData]
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code. 
    main_test:
    mov r10b, byte[rdi+64]
%endmacro

; Before calling the victim, make sure to move the proper value into r9  
; r9 determines the direction of branches.
%macro victim 0
    ; Initializing the registers
    lea r10, [UserData]

    ; if (r9 == 0) then r10 += 32
    cmp r9, 0
    jne vt1
    add r10, 31
    vt1:

    ; if (r9 == 1) then r10 += 32
    cmp r9, 1
    jne vt2
    add r10, 33
    vt2:
    
    ; load [rdi+r10+r11] from memory 
    mov r10b, byte[r10]
%endmacro