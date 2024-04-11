
	.arch armv8-a
	.file	"mispred_test.c"
	.text
	.global	a
	.bss
	.align	3
	.type	a, %object
	.size	a, 8000
a:
	.zero	8000
	.text
	.align	2
	.global	get_pc
	.type	get_pc, %function
get_pc:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x0, x30
	mov	x30, x0
	hint	7 // xpaclri
	mov	x0, x30
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	get_pc, .-get_pc
	.align	2
	.global	genRand
	.type	genRand, %function
genRand:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	mov	x0, 0
	bl	time
	bl	srand
	str	wzr, [sp, 28]
	b	.L4
.L5:
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
.L4:
	ldr	w0, [sp, 28]
	cmp	w0, 1999
	ble	.L5
	nop
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
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

.altmacro
.macro dummy_branches1 iter, n, i
	b label1_\iter
	.p2align \i
label1_\iter:
	.if \n-\iter
		dummy_branches1 %iter+1, \n, \i
	.endif
.endm

.altmacro
.macro dummy_branches2 iter, n, i
	b label2_\iter
	.p2align \i
label2_\iter:
	.if \n-\iter
		dummy_branches2 %iter+1, \n, \i
	.endif
.endm

.altmacro
.macro snop n, i
	nop
	.p2align \n
	.if \n-\i
		snop %n-1, \i
	.endif
.endm

main:
.LFB8:
	.cfi_startproc
	mov	x12, 32224
	sub	sp, sp, x12
	.cfi_def_cfa_offset 32224
	stp	x29, x30, [sp]
	.cfi_offset 29, -32224
	.cfi_offset 30, -32216
	mov	x29, sp
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 32216]
	mov	x1, 0
	mov	w0, 3	// cpu
	str	w0, [sp, 32]
	add	x0, sp, 216
	movi	v0.4s, 0
	stp	q0, q0, [x0]
	stp	q0, q0, [x0, 32]
	stp	q0, q0, [x0, 64]
	stp	q0, q0, [x0, 96]
	ldrsw	x0, [sp, 32]
	str	x0, [sp, 72]
	ldr	x0, [sp, 72]
	cmp	x0, 1023
	bhi	.L8
	ldr	x0, [sp, 72]
	lsr	x0, x0, 6
	lsl	x1, x0, 3
	add	x2, sp, 216
	add	x1, x2, x1
	ldr	x2, [x1]
	ldr	x1, [sp, 72]
	and	w1, w1, 63
	mov	x3, 1
	lsl	x1, x3, x1
	lsl	x0, x0, 3
	add	x3, sp, 216
	add	x0, x3, x0
	orr	x1, x2, x1
	str	x1, [x0]
.L8:
	add	x0, sp, 216
	mov	x2, x0
	mov	x1, 128
	mov	w0, 0
	bl	sched_setaffinity
	str	w0, [sp, 36]
	ldr	w0, [sp, 36]
	cmn	w0, #1
	bne	.L9
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	perror
	mov	w0, -1
	bl	exit
.L9:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	system
	str	w0, [sp, 40]
	add	x0, sp, 120
	mov	x2, 96
	mov	w1, 0
	bl	memset
	add	x0, sp, 120
	bl	perf_open
	str	xzr, [sp, 56]
	str	xzr, [sp, 80]
	str	xzr, [sp, 88]
	str	wzr, [sp, 44]
	bl	get_pc
	add x0, x0, 8
	str	x0, [sp, 96] 
	add	x0, sp, 216 // [sp, 96] is here
	mov	x1, 32000
	mov	x2, x1
	mov	w1, 0
	bl	memset
	str	wzr, [sp, 28]
	bl	get_pc
	add x0, x0, 8
	str	x0, [sp, 104]
	str	xzr, [sp, 88] // [sp, 104] is here
	bl	genRand
	str	xzr, [sp, 56]
	add	x0, sp, 120
	bl	perf_start

	adrp	x0, a
	add	x0, x0, :lo12:a
	ldrsw	x1, [sp, 28]
	ldr	w0, [x0, x1, lsl 2]
	str	w0, [sp, 52]
	
	ldr	x0, [sp, 56]
	add x0, x0, 2
	str	x0, [sp, 56]

	ldr	w0, [sp, 52]
	add w0, w0, 1
	str	w0, [sp, 52] // rand is 1 or 2

	mov	w0, 120
	b .L30
	.p2align 12
.L30:
	sub	w0, w0, 1
	.p2align 7
	cbnz w0, .L30

	mov x0, 0x300000000
	mov x1, 0x000000000
	add x0, x0, x1
	adr x1, .L20
	.p2align 6
	br x0

	.p2align 11
.L20:
	ldr	x0, [sp, 56]
	.p2align 2	
	cbz x0, .L11	// co_b to check
	ldr	x0, [sp, 80]
	add	x0, x0, 1
	str	x0, [sp, 80]
	.p2align 2	
.L11:
	add	x1, sp, 216
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 5
	add	x1, x1, x0
	add	x0, sp, 120
	bl	perf_stop
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	cmp	w0, 999
	bgt	.L12
	ldr	x0, [sp, 104]
	br x0
.L12:
	str	xzr, [sp, 64]
	str	wzr, [sp, 28]
	b	.L13
.L14:
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 5
	add	x1, sp, 232
	ldr	d0, [x1, x0]
	ucvtf	d0, d0
	str	d0, [sp, 112]
	ldr	d1, [sp, 64]
	ldr	d0, [sp, 112]
	fadd	d0, d1, d0
	str	d0, [sp, 64]
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L13:
	ldr	w0, [sp, 28]
	cmp	w0, 999
	ble	.L14
	mov	x0, 70368744177664
	movk	x0, 0x408f, lsl 48
	fmov	d1, x0
	ldr	d0, [sp, 64]
	fdiv	d0, d0, d1
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
	ldr	w0, [sp, 44]
	cmp	w0, 19
	bgt	.L15
	ldr	x0, [sp, 96]
	br x0
.L15:
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 32216]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L17
	bl	__stack_chk_fail
.L17:
	mov	w0, w1
	ldp	x29, x30, [sp]
	mov	x12, 32224
	add	sp, sp, x12
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.ident	"GCC: (GNU) 12.1.0"
	.section	.note.GNU-stack,"",@progbits

.section rand_cbz, "ax"
.L10:
	ldr	x0, [sp, 56]
	sub	x0, x0, 1
	str	x0, [sp, 56]

	ldr	w0, [sp, 52]
	sub w0, w0, 1
	str	w0, [sp, 52]
	
	.p2align 8
	cbnz w0, .L10
	br	x1

.section cancel_exp_1, "ax"
	mov x0, 0x10000000000
	mov x2, 0x2000000000
	add x0, x0, x2
	// mov x2, 0x2000000000
	// add x0, x0, x2
	.p2align 6
	br x0
	
.section cancel_exp_2, "ax"
	mov x0, 0x20000000000
	mov x2, 0x2000000000
	add x0, x0, x2
	.p2align 6
	br x0
	
.section back_to_rand_cbnz, "ax"
	mov x0, 0x200000000
	.p2align 6
	br  x0

