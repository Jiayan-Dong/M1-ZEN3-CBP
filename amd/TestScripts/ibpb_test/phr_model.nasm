%macro PHR_Model 1

    lea r8, [Victim_PHR0%+ %1]
    lea r9, [Victim_PHR1%+ %1]
    lea rcx, [Victim_PHR2%+ %1]
    lea rdx, [Victim_PHR3%+ %1]
    lea rsi, [Victim_End%+ %1]
    mov qword [UserData+0], r8
    mov qword [UserData+16], r9
    mov qword [UserData+32], rcx
    mov qword [UserData+48], rdx
    mov qword [UserData+64], rsi

    lea r8, [UserData]
    lea r9, [UserData]
    add r9, 3000

    movzx r11, byte[r9]
    shl r11, 4
    jmp qword [r11+r8]

    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    Victim_PHR0%+ %1:
        %rep 50
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    Victim_PHR1%+ %1:
        %rep 58
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    Victim_PHR2%+ %1:
        %rep 2
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    Victim_PHR3%+ %1:
        %rep 10
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    Victim_End%+ %1:

%endmacro