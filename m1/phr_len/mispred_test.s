
	.arch armv8-a
	.file	"mispred_test.c"
	.text
	.global	a
	.bss
	.align	3
	.type	a, %object
	.size	a, 880
a:
	.zero	880
	.text
	.align	2
	.global	genRand
	.type	genRand, %function
genRand:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	wzr, [sp, 28]
	b	.L2
.L3:
	bl	rand
	cmp	w0, 0
	and	w0, w0, 1
	csneg	w2, w0, w0, ge
	adrp	x0, a
	add	x0, x0, :lo12:a
	ldrsw	x1, [sp, 28]
	str	w2, [x0, x1, lsl 2]
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L2:
	ldr	w0, [sp, 28]
	cmp	w0, 219
	ble	.L3
	nop
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	genRand, .-genRand
	.section	.rodata
	.align	3
.LC0:
	.string	"sched_setaffinity([0])"
	.align	3
.LC1:
	.string	"python3 -c 'import math'"
	.align	3
.LC2:
	.string	"%5.3f\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB7:
	.cfi_startproc
	mov	x12, 32240
	sub	sp, sp, x12
	.cfi_def_cfa_offset 32240
	stp	x29, x30, [sp]
	.cfi_offset 29, -32240
	.cfi_offset 30, -32232
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32224
	.cfi_offset 20, -32216
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 32232]
	mov	x1, 0
	add	x0, sp, 232
	movi	v0.4s, 0
	stp	q0, q0, [x0]
	stp	q0, q0, [x0, 32]
	stp	q0, q0, [x0, 64]
	stp	q0, q0, [x0, 96]
	mov	x0, 7
	str	x0, [sp, 96]
	ldr	x0, [sp, 96]
	cmp	x0, 1023
	bhi	.L6
	ldr	x0, [sp, 96]
	lsr	x0, x0, 6
	lsl	x1, x0, 3
	add	x2, sp, 232
	add	x1, x2, x1
	ldr	x2, [x1]
	ldr	x1, [sp, 96]
	and	w1, w1, 63
	mov	x3, 1
	lsl	x1, x3, x1
	lsl	x0, x0, 3
	add	x3, sp, 232
	add	x0, x3, x0
	orr	x1, x2, x1
	str	x1, [x0]
.L6:
	add	x0, sp, 232
	mov	x2, x0
	mov	x1, 128
	mov	w0, 0
	bl	sched_setaffinity
	str	w0, [sp, 56]
	ldr	w0, [sp, 56]
	cmn	w0, #1
	bne	.L7
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	perror
	mov	w0, -1
	bl	exit
.L7:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	system
	str	w0, [sp, 60]
	add	x0, sp, 136
	mov	x2, 96
	mov	w1, 0
	bl	memset
	add	x0, sp, 136
	bl	perf_open
	adrp	x0, a
	add	x20, x0, :lo12:a
	str	wzr, [sp, 48]
	b	.L8
.L16:
	add	x0, sp, 232
	mov	x1, 32000
	mov	x2, x1
	mov	w1, 0
	bl	memset
	str	wzr, [sp, 52]
	b	.L9
.L13:
	bl	genRand
	adrp	x0, a
	add	x0, x0, :lo12:a
	ldr	w19, [x0]
	add	x0, sp, 136
	bl	perf_start
	cmp	w19, 0
	beq	.L10
	ldr	w0, [sp, 44]
	add	w0, w0, 114
	str	w0, [sp, 44]
.L10:


    add	x0, x20, 4 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_1 // 11
.LBB3_1:
    
    
    add	x0, x20, 8 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_2 // 11
.LBB3_2:
    
    
    add	x0, x20, 12 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_3 // 11
.LBB3_3:
    
    
    add	x0, x20, 16 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_4 // 11
.LBB3_4:
    
    
    add	x0, x20, 20 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_5 // 11
.LBB3_5:
    
    
    add	x0, x20, 24 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_6 // 11
.LBB3_6:
    
    
    add	x0, x20, 28 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_7 // 11
.LBB3_7:
    
    
    add	x0, x20, 32 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_8 // 11
.LBB3_8:
    
    
    add	x0, x20, 36 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_9 // 11
.LBB3_9:
    
    
    add	x0, x20, 40 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_10 // 11
.LBB3_10:
    
    
    add	x0, x20, 44 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_11 // 11
.LBB3_11:
    
    
    add	x0, x20, 48 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_12 // 11
.LBB3_12:
    
    
    add	x0, x20, 52 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_13 // 11
.LBB3_13:
    
    
    add	x0, x20, 56 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_14 // 11
.LBB3_14:
    
    
    add	x0, x20, 60 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_15 // 11
.LBB3_15:
    
    
    add	x0, x20, 64 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_16 // 11
.LBB3_16:
    
    
    add	x0, x20, 68 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_17 // 11
.LBB3_17:
    
    
    add	x0, x20, 72 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_18 // 11
.LBB3_18:
    
    
    add	x0, x20, 76 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_19 // 11
.LBB3_19:
    
    
    add	x0, x20, 80 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_20 // 11
.LBB3_20:
    
    
    add	x0, x20, 84 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_21 // 11
.LBB3_21:
    
    
    add	x0, x20, 88 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_22 // 11
.LBB3_22:
    
    
    add	x0, x20, 92 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_23 // 11
.LBB3_23:
    
    
    add	x0, x20, 96 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_24 // 11
.LBB3_24:
    
    
    add	x0, x20, 100 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_25 // 11
.LBB3_25:
    
    
    add	x0, x20, 104 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_26 // 11
.LBB3_26:
    
    
    add	x0, x20, 108 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_27 // 11
.LBB3_27:
    
    
    add	x0, x20, 112 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_28 // 11
.LBB3_28:
    
    
    add	x0, x20, 116 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_29 // 11
.LBB3_29:
    
    
    add	x0, x20, 120 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_30 // 11
.LBB3_30:
    
    
    add	x0, x20, 124 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_31 // 11
.LBB3_31:
    
    
    add	x0, x20, 128 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_32 // 11
.LBB3_32:
    
    
    add	x0, x20, 132 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_33 // 11
.LBB3_33:
    
    
    add	x0, x20, 136 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_34 // 11
.LBB3_34:
    
    
    add	x0, x20, 140 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_35 // 11
.LBB3_35:
    
    
    add	x0, x20, 144 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_36 // 11
.LBB3_36:
    
    
    add	x0, x20, 148 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_37 // 11
.LBB3_37:
    
    
    add	x0, x20, 152 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_38 // 11
.LBB3_38:
    
    
    add	x0, x20, 156 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_39 // 11
.LBB3_39:
    
    
    add	x0, x20, 160 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_40 // 11
.LBB3_40:
    
    
    add	x0, x20, 164 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_41 // 11
.LBB3_41:
    
    
    add	x0, x20, 168 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_42 // 11
.LBB3_42:
    
    
    add	x0, x20, 172 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_43 // 11
.LBB3_43:
    
    
    add	x0, x20, 176 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_44 // 11
.LBB3_44:
    
    
    add	x0, x20, 180 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_45 // 11
.LBB3_45:
    
    
    add	x0, x20, 184 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_46 // 11
.LBB3_46:
    
    
    add	x0, x20, 188 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_47 // 11
.LBB3_47:
    
    
    add	x0, x20, 192 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_48 // 11
.LBB3_48:
    
    
    add	x0, x20, 196 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_49 // 11
.LBB3_49:
    
    
    add	x0, x20, 200 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_50 // 11
.LBB3_50:
    
    
    add	x0, x20, 204 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_51 // 11
.LBB3_51:
    
    
    add	x0, x20, 208 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_52 // 11
.LBB3_52:
    
    
    add	x0, x20, 212 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_53 // 11
.LBB3_53:
    
    
    add	x0, x20, 216 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_54 // 11
.LBB3_54:
    
    
    add	x0, x20, 220 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_55 // 11
.LBB3_55:
    
    
    add	x0, x20, 224 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_56 // 11
.LBB3_56:
    
    
    add	x0, x20, 228 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_57 // 11
.LBB3_57:
    
    
    add	x0, x20, 232 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_58 // 11
.LBB3_58:
    
    
    add	x0, x20, 236 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_59 // 11
.LBB3_59:
    
    
    add	x0, x20, 240 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_60 // 11
.LBB3_60:
    
    
    add	x0, x20, 244 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_61 // 11
.LBB3_61:
    
    
    add	x0, x20, 248 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_62 // 11
.LBB3_62:
    
    
    add	x0, x20, 252 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_63 // 11
.LBB3_63:
    
    
    add	x0, x20, 256 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_64 // 11
.LBB3_64:
    
    
    add	x0, x20, 260 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_65 // 11
.LBB3_65:
    
    
    add	x0, x20, 264 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_66 // 11
.LBB3_66:
    
    
    add	x0, x20, 268 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_67 // 11
.LBB3_67:
    
    
    add	x0, x20, 272 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_68 // 11
.LBB3_68:
    
    
    add	x0, x20, 276 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_69 // 11
.LBB3_69:
    
    
    add	x0, x20, 280 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_70 // 11
.LBB3_70:
    
    
    add	x0, x20, 284 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_71 // 11
.LBB3_71:
    
    
    add	x0, x20, 288 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_72 // 11
.LBB3_72:
    
    
    add	x0, x20, 292 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_73 // 11
.LBB3_73:
    
    
    add	x0, x20, 296 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_74 // 11
.LBB3_74:
    
    
    add	x0, x20, 300 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_75 // 11
.LBB3_75:
    
    
    add	x0, x20, 304 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_76 // 11
.LBB3_76:
    
    
    add	x0, x20, 308 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_77 // 11
.LBB3_77:
    
    
    add	x0, x20, 312 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_78 // 11
.LBB3_78:
    
    
    add	x0, x20, 316 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_79 // 11
.LBB3_79:
    
    
    add	x0, x20, 320 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_80 // 11
.LBB3_80:
    
    
    add	x0, x20, 324 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_81 // 11
.LBB3_81:
    
    
    add	x0, x20, 328 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_82 // 11
.LBB3_82:
    
    
    add	x0, x20, 332 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_83 // 11
.LBB3_83:
    
    
    add	x0, x20, 336 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_84 // 11
.LBB3_84:
    
    
    add	x0, x20, 340 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_85 // 11
.LBB3_85:
    
    
    add	x0, x20, 344 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_86 // 11
.LBB3_86:
    
    
    add	x0, x20, 348 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_87 // 11
.LBB3_87:
    
    
    add	x0, x20, 352 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_88 // 11
.LBB3_88:
    
    
    add	x0, x20, 356 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_89 // 11
.LBB3_89:
    
    
    add	x0, x20, 360 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_90 // 11
.LBB3_90:
    
    
    add	x0, x20, 364 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_91 // 11
.LBB3_91:
    
    
    add	x0, x20, 368 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_92 // 11
.LBB3_92:
    
    
    add	x0, x20, 372 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_93 // 11
.LBB3_93:
    
    
    add	x0, x20, 376 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_94 // 11
.LBB3_94:
    
    
    add	x0, x20, 380 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_95 // 11
.LBB3_95:
    
    
    add	x0, x20, 384 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_96 // 11
.LBB3_96:
    
    
    add	x0, x20, 388 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_97 // 11
.LBB3_97:
    
    
    add	x0, x20, 392 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_98 // 11
.LBB3_98:
    
    
    add	x0, x20, 396 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_99 // 11
.LBB3_99:
    
    
    add	x0, x20, 400 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_100 // 11
.LBB3_100:
    
    
    add	x0, x20, 404 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_101 // 11
.LBB3_101:
    
    
    add	x0, x20, 408 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_102 // 11
.LBB3_102:
    
    
    add	x0, x20, 412 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_103 // 11
.LBB3_103:
    
    
    add	x0, x20, 416 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_104 // 11
.LBB3_104:
    
    
    add	x0, x20, 420 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_105 // 11
.LBB3_105:
    
    
    add	x0, x20, 424 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_106 // 11
.LBB3_106:
    
    
    add	x0, x20, 428 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_107 // 11
.LBB3_107:
    
    
    add	x0, x20, 432 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_108 // 11
.LBB3_108:
    
    
    add	x0, x20, 436 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_109 // 11
.LBB3_109:
    
    
    add	x0, x20, 440 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_110 // 11
.LBB3_110:
    
    
    add	x0, x20, 444 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_111 // 11
.LBB3_111:
    
    
    add	x0, x20, 448 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_112 // 11
.LBB3_112:
    
    
    add	x0, x20, 452 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_113 // 11
.LBB3_113:
    
    
    add	x0, x20, 456 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_114 // 11
.LBB3_114:
    
    
    add	x0, x20, 460 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_115 // 11
.LBB3_115:
    
    
    add	x0, x20, 464 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_116 // 11
.LBB3_116:
    
    
    add	x0, x20, 468 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_117 // 11
.LBB3_117:
    
    
    add	x0, x20, 472 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_118 // 11
.LBB3_118:
    
    
    add	x0, x20, 476 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_119 // 11
.LBB3_119:
    
    
    add	x0, x20, 480 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_120 // 11
.LBB3_120:
    
    
    add	x0, x20, 484 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_121 // 11
.LBB3_121:
    
    
    add	x0, x20, 488 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_122 // 11
.LBB3_122:
    
    
    add	x0, x20, 492 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_123 // 11
.LBB3_123:
    
    
    add	x0, x20, 496 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_124 // 11
.LBB3_124:
    
    
    add	x0, x20, 500 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_125 // 11
.LBB3_125:
    
    
    add	x0, x20, 504 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_126 // 11
.LBB3_126:
    
    
    add	x0, x20, 508 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_127 // 11
.LBB3_127:
    
    
    add	x0, x20, 512 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_128 // 11
.LBB3_128:
    
    
    add	x0, x20, 516 // 4
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.LBB3_129 // 11
.LBB3_129:
    
    

	cmp	w19, 0
	beq	.L12
	ldr	w0, [sp, 44]
	add	w0, w0, 514
	str	w0, [sp, 44]
.L12:
	add	x1, sp, 232
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 5
	add	x1, x1, x0
	add	x0, sp, 136
	bl	perf_stop
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L9:
	ldr	w0, [sp, 52]
	cmp	w0, 999
	ble	.L13
	str	xzr, [sp, 64]
	str	xzr, [sp, 72]
	str	xzr, [sp, 80]
	str	xzr, [sp, 88]
	str	wzr, [sp, 52]
	b	.L14
.L15:
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 5
	add	x1, sp, 232
	ldr	d0, [x1, x0]
	ucvtf	d0, d0
	str	d0, [sp, 104]
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 5
	add	x1, sp, 240
	ldr	d0, [x1, x0]
	ucvtf	d0, d0
	str	d0, [sp, 112]
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 5
	add	x1, sp, 256
	ldr	d0, [x1, x0]
	ucvtf	d0, d0
	str	d0, [sp, 120]
	ldrsw	x0, [sp, 52]
	lsl	x0, x0, 5
	add	x1, sp, 248
	ldr	d0, [x1, x0]
	ucvtf	d0, d0
	str	d0, [sp, 128]
	ldr	d1, [sp, 64]
	ldr	d0, [sp, 104]
	fadd	d0, d1, d0
	str	d0, [sp, 64]
	ldr	d1, [sp, 72]
	ldr	d0, [sp, 112]
	fadd	d0, d1, d0
	str	d0, [sp, 72]
	ldr	d1, [sp, 80]
	ldr	d0, [sp, 120]
	fadd	d0, d1, d0
	str	d0, [sp, 80]
	ldr	d1, [sp, 88]
	ldr	d0, [sp, 128]
	fadd	d0, d1, d0
	str	d0, [sp, 88]
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L14:
	ldr	w0, [sp, 52]
	cmp	w0, 999
	ble	.L15
	mov	x0, 70368744177664
	movk	x0, 0x408f, lsl 48
	fmov	d1, x0
	ldr	d0, [sp, 88]
	fdiv	d0, d0, d1
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	str	w0, [sp, 48]
.L8:
	ldr	w0, [sp, 48]
	cmp	w0, 19
	ble	.L16
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 32232]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L18
	bl	__stack_chk_fail
.L18:
	mov	w0, w1
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp]
	mov	x12, 32240
	add	sp, sp, x12
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (GNU) 12.1.0"
	.section	.note.GNU-stack,"",@progbits


