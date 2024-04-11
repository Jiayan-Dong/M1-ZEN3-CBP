%include "../nops.inc"

%define repeat0  10              ; Number of repetitions of whole test. Default = 8
%define repeat1  1000              ; Repeat count for loop around testcode. Default = no loop
%define repeat2  1              ; Repeat count for repeat macro around testcode. Default = 100
%define noptype  2

%macro testinitc 0              ; Macro to call in each test before reading counters.

%endmacro

%macro testinit2 0              ; Macro with initializations before each test. Default = nothing
    
%endmacro

%macro testcode 0               ; A multi-line macro executing any piece of test code.

    mov rax, 0x100041100 ;jump1
    mov rbx, 0x200041100 ;jump2
    ; lea rax, jump1
    ; lea rbx, jump2
    ; mov rcx, 0x6000100   ;back_to_main1
    ; mov rdx, 0x6000110   ;back_to_main2
    call rax
main1:

    call rbx
main2:

    %rep 16
     nop8
    %endrep


%endmacro

SECTION back_to_main1 exec
    jmp main1

SECTION back_to_main2 exec
    jmp main2

SECTION test_jump1 exec
jump1:
    nop
    align 1<<6
    jmp target1

SECTION test_target1 exec
target1:
    %rep 8
     nop8
    %endrep
    ;jmp rcx ;back_to_main1
    ret


SECTION test_jump2 exec
jump2:
    nop
    align 1<<6
    jmp target2

SECTION test_target2 exec
target2:
    %rep 8
     nop8
    %endrep
    ;jmp rdx ;back_to_main2
    ret