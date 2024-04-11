

    ; ------------------------------------
    ; Author: Hosein Yavarzadeh 
    ; Email: hyavarzadeh@ucsd.edu
    ; Supervisor: Prof. Dean Tullsen
    ; ------------------------------------

    %define repeat0  8             ; Number of repetitions of whole test. Default = 8
    %define repeat1  1000           ; Repeat count for loop around testcode. Default = no loop
    %define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100

    %macro testinitc 0              ; Macro to call in each test before reading counters.
        mov dword[PrintCustomPMC], 1
        mov ebx, 1990989             
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

        add rdi, 221
        
        dummy_rand_branch 200, 0
        
        lfence
        cmp byte[rdi],0
        je target1
        target1:
        
        lfence
        dummy_rand_branch 20, 5

        lfence
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
        label%+ j:
    %endmacro
    
    %macro dummy_rand_branch 2
        mov rax, rdi
        %assign i_rand (100)*(%2)
        %assign j_rand (100)*(%2)
        %rep %1
                %assign j_rand i_rand+1
                label_rand%+ i_rand:
                inc rax
                cmp byte[rax], 0
                je label_rand%+ j_rand 
                %assign i_rand j_rand  
        %endrep
        label_rand%+ j_rand:
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
    lfence
    dec rdx
    cmp rdx, 0
    jmp dummy_label_11

SECTION .dummy_branch_11 exec
    dummy_label_11:
    je dummy_label_12
    lfence
    mov rax, 4294967296
    mov rcx, 0
    cmp rcx, 0
    jmp rax

SECTION .dummy_branch_12 exec
    dummy_label_12:
    lfence
    
    cmp byte[rdi],0
    jmp dummy_label_13

SECTION .dummy_branch_13 exec
    dummy_label_13:
    je dummy_label_14
    jmp dummy_label_14

SECTION .dummy_branch_14 exec
    dummy_label_14:
    jmp rbx
