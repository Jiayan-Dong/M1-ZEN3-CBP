%macro PHR_Model 0

    lea r8, [PHR0]
    lea r9, [PHR1]
    lea rcx, [PHR2]
    lea rdx, [PHR3]
    lea rsi, [End]
    mov qword [UserData+0], r8
    mov qword [UserData+16], r9
    mov qword [UserData+32], rcx
    mov qword [UserData+48], rdx
    mov qword [UserData+64], rsi

    lea r8, [UserData]
    lea r9, [UserData]
    add r9, 2000

    movzx r11, byte[r9]
    shl r11, 4
    jmp qword [r11+r8]

    align 1<<16
    %rep (1<<16)-64
     nop
    %endrep
    PHR0:
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
    PHR1:
        %rep 58
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    PHR2:
        %rep 2
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    PHR3:
        %rep 10
         nop
        %endrep
        inc r9
        movzx r11, byte[r9]
        shl r11, 4
        jmp qword [r11+r8]

    align 1<<16
    End:

%endmacro