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

    mov ebx, 8000             
    lea rdi, [UserData]
    rand_loop:
    clflush [rdi+9000]
    rdrand eax
    and eax, 1
    mov [rdi], al
    inc rdi
    dec ebx
    jnz rand_loop

    ; %rep 2048
    ;  nop
    ; %endrep
    ; mfence
    ; attack
    ; mfence
    ; %rep 2048
    ;  nop
    ; %endrep


%endmacro

%macro testinit2 0

    lea rdi, [UserData]

%endmacro

%macro testcode 0
    
    mfence
    attack
    mfence

    mov r11b, byte[rdi+9512]

%endmacro

%macro attack 0

    lea rdi, [UserData]
    mov rax, 1000
    loop_test:

        inc rdi
        mov r9, 0
        mov r9b, byte[rdi]
        lea r10, [target_ind1]
        lea r11, [target_ind2]
        cmp r9b, 1
        cmove r10, r11
        lea r11, [UserData]         ; r11 = address of [UserData]
        mov [r11+1200], r10
        clflush [r11+1200]          ; r10 = [r11+1200] = indirect jump's target
        mfence
        shl r9, 9
        add r9, r11                 ; r9 = rand() ? (r11 + 512) : r11


        PHR_helper                  ; Insert a key bit (rand()) into the PHR to help the prediciton of indirect branch
        %rep 2048
         nop
        %endrep

        ; SHIFT_PHR 100               ; PHR = constant

        ; -------------------------   Fill a BTB set with 12 branches
        %rep 2048
         nop
        %endrep
        FillBTB 12
        ; -------------------------------------------------------------
        
        ; -------------------------   Indirect Branch
        jmp [r11+1200]              ; r10 = [r11+1200]
        target_ind1:                ; if rand() == 0
        mov r11b, byte[r9+9000]     ; load [9000]
        target_ind2:                ; if rand() == 1
        %rep 32
         nop
        %endrep
        ; -------------------------------------------------------------

    dec rax
    jnz loop_test

%endmacro

%macro FillBTB 1

    jmp start_FillBTB
    align 1<<17
    start_FillBTB:
    %assign i 0
    %rep %1
    jmp fill_target%+ i
    align 1<<17
    fill_target%+ i: 
    %assign i i+1
    %endrep 

%endmacro

%macro PHR_helper 0

    mfence
    cmp r9, r11
    je helper
    %rep 64
     nop
    %endrep
    helper:
    mfence

%endmacro


%macro DummyBranches 1 

    %assign i 0
    %rep %1
    jmp dummy_target%+ i
    dummy_target%+ i: 
    %assign i i+1
    %endrep 

%endmacro

%macro SHIFT_PHR 1

    mov r10, %1
    dummy_loop:
    %rep 100
     nop
    %endrep
    dec r10
    jnz dummy_loop

%endmacro