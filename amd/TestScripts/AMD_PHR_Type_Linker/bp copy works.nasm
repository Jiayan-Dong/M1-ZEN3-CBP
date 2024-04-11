
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
    ; mov rdx, 5
    mov rdx, 6
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
    je dummy_label_1

SECTION .dummy_branch_1 exec
    dummy_label_1:
    je dummy_label_2

SECTION .dummy_branch_2 exec
    dummy_label_2:
    je dummy_label_3

SECTION .dummy_branch_3 exec
    dummy_label_3:
    je dummy_label_4

SECTION .dummy_branch_4 exec
    dummy_label_4:
    je dummy_label_5

SECTION .dummy_branch_5 exec
    dummy_label_5:
    je dummy_label_6

SECTION .dummy_branch_6 exec
    dummy_label_6:
    je dummy_label_7

SECTION .dummy_branch_7 exec
    dummy_label_7:
    je dummy_label_8

SECTION .dummy_branch_8 exec
    dummy_label_8:
    je dummy_label_9

SECTION .dummy_branch_9 exec
    dummy_label_9:
    je dummy_label_10

SECTION .dummy_branch_10 exec
    dummy_label_10:
    je dummy_label_11

SECTION .dummy_branch_11 exec
    dummy_label_11:
    je dummy_label_12

SECTION .dummy_branch_12 exec
    dummy_label_12:
    je dummy_label_13

SECTION .dummy_branch_13 exec
    dummy_label_13:
    je dummy_label_14

SECTION .dummy_branch_14 exec
    dummy_label_14:
    je dummy_label_15

SECTION .dummy_branch_15 exec
    dummy_label_15:
    je dummy_label_16

SECTION .dummy_branch_16 exec
    dummy_label_16:
    je dummy_label_17

SECTION .dummy_branch_17 exec
    dummy_label_17:
    je dummy_label_18

SECTION .dummy_branch_18 exec
    dummy_label_18:
    je dummy_label_19

SECTION .dummy_branch_19 exec
    dummy_label_19:
    je dummy_label_20

SECTION .dummy_branch_20 exec
    dummy_label_20:
    je dummy_label_21

SECTION .dummy_branch_21 exec
    dummy_label_21:
    je dummy_label_22

SECTION .dummy_branch_22 exec
    dummy_label_22:
    je dummy_label_23

SECTION .dummy_branch_23 exec
    dummy_label_23:
    je dummy_label_24

SECTION .dummy_branch_24 exec
    dummy_label_24:
    je dummy_label_25

SECTION .dummy_branch_25 exec
    dummy_label_25:
    je dummy_label_26

SECTION .dummy_branch_26 exec
    dummy_label_26:
    je dummy_label_27

SECTION .dummy_branch_27 exec
    dummy_label_27:
    je dummy_label_28

SECTION .dummy_branch_28 exec
    dummy_label_28:
    je dummy_label_29

SECTION .dummy_branch_29 exec
    dummy_label_29:
    je dummy_label_30

SECTION .dummy_branch_30 exec
    dummy_label_30:
    je dummy_label_31

SECTION .dummy_branch_31 exec
    dummy_label_31:
    je dummy_label_32

SECTION .dummy_branch_32 exec
    dummy_label_32:
    je dummy_label_33

SECTION .dummy_branch_33 exec
    dummy_label_33:
    je dummy_label_34

SECTION .dummy_branch_34 exec
    dummy_label_34:
    je dummy_label_35

SECTION .dummy_branch_35 exec
    dummy_label_35:
    je dummy_label_36

SECTION .dummy_branch_36 exec
    dummy_label_36:
    je dummy_label_37

SECTION .dummy_branch_37 exec
    dummy_label_37:
    je dummy_label_38

SECTION .dummy_branch_38 exec
    dummy_label_38:
    je dummy_label_39

SECTION .dummy_branch_39 exec
    dummy_label_39:
    je dummy_label_40

SECTION .dummy_branch_40 exec
    dummy_label_40:
    je dummy_label_41

SECTION .dummy_branch_41 exec
    dummy_label_41:
    je dummy_label_42

SECTION .dummy_branch_42 exec
    dummy_label_42:
    je dummy_label_43

SECTION .dummy_branch_43 exec
    dummy_label_43:
    je dummy_label_44

SECTION .dummy_branch_44 exec
    dummy_label_44:
    je dummy_label_45

SECTION .dummy_branch_45 exec
    dummy_label_45:
    je dummy_label_46

SECTION .dummy_branch_46 exec
    dummy_label_46:
    je dummy_label_47

SECTION .dummy_branch_47 exec
    dummy_label_47:
    je dummy_label_48

SECTION .dummy_branch_48 exec
    dummy_label_48:
    je dummy_label_49

SECTION .dummy_branch_49 exec
    dummy_label_49:
    je dummy_label_50

SECTION .dummy_branch_50 exec
    dummy_label_50:
    je dummy_label_51

SECTION .dummy_branch_51 exec
    dummy_label_51:
    je dummy_label_52

SECTION .dummy_branch_52 exec
    dummy_label_52:
    je dummy_label_53

SECTION .dummy_branch_53 exec
    dummy_label_53:
    je dummy_label_54

SECTION .dummy_branch_54 exec
    dummy_label_54:
    je dummy_label_55

SECTION .dummy_branch_55 exec
    dummy_label_55:
    je dummy_label_56

SECTION .dummy_branch_56 exec
    dummy_label_56:
    je dummy_label_57

SECTION .dummy_branch_57 exec
    dummy_label_57:
    je dummy_label_58

SECTION .dummy_branch_58 exec
    dummy_label_58:
    je dummy_label_59

SECTION .dummy_branch_59 exec
    dummy_label_59:
    je dummy_label_60

SECTION .dummy_branch_60 exec
    dummy_label_60:

    dec rdx
    cmp rdx, 0
    je rand_tt
    mov rax, 0x100000000
    mov rcx, 0
    cmp rcx, 0
    jmp rax
rand_tt:
    ; align (1 << 10)
    cmp byte[rdi],0
    align (1 << b_align)
    je rand_target
    align (1 << t_align)
    rand_target:
    jmp rbx

; SECTION .dummy_branch_61 exec
;     dummy_label_61: