PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400-3
RUN_ADDRESS		equ	main

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS-$80
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
	.align
.endif

fnt :8 dta b(0)
	:8 dta b(%01010101)
	:8 dta b(%10101010)
	:8 dta b(%11111111)
	:8 dta b(0)
scr0 dta b(0,0,0,0,1,1,1,1,0,0,0,0,2,2,2,2,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
scr1 dta b(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,3,3,3,3,0,0,0,0)
scr2 dta b(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2)
	:8 dta b(0)
scr3 = scr0-8
scr4 = scr1-8
scr5 = scr2+8
dlist
	:5   dta b($70)
	:1	 dta b($80)
	:1	 dta b($44),a(scr0)
	:1	 dta b($44),a(scr0)
	:1	 dta b($44),a(scr0)
	:1	 dta b($c4),a(scr0)
	:1	 dta b($44),a(scr1)
	:1	 dta b($44),a(scr1)
	:1	 dta b($44),a(scr1)
	:1	 dta b($c4),a(scr1)
	:1	 dta b($44),a(scr2)
	:1	 dta b($44),a(scr2)
	:1	 dta b($44),a(scr2)
	:1	 dta b($c4),a(scr2)
	:1	 dta b($44),a(scr3)
	:1	 dta b($44),a(scr3)
	:1	 dta b($44),a(scr3)
	:1	 dta b($c4),a(scr3)	
	:1	 dta b($44),a(scr4)
	:1	 dta b($44),a(scr4)
	:1	 dta b($44),a(scr4)
	:1	 dta b($44),a(scr4)	
	:1   dta b($41),a(dlist)

	utils_wait_one_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	mva #$00 pmcntl	
	lda #0
	sta gtictl
    sta colbak
	sta end_eff
	lda #>fnt
	sta chbase
	set_vbl vblk
	set_dli dli0
	mwa #dlist dlptr

	mva #@dmactl(standard|dma) dmactl

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
	jsr flash
end	plr
	rti
.endl

dli0	.local
	sta regA
c0	lda #0
	sta wsync
	sta colpf0
c1	lda #0
	sta colpf1
c2	lda #0
	sta colpf2
	set_dli dli1
	lda regA
	rti
.endl

dli1	.local
	sta regA
c0	lda #0
	sta wsync
	sta colpf0
c1	lda #0
	sta colpf1
c2	lda #0
	sta colpf2
	set_dli dli2
	lda regA
	rti
.endl

dli2	.local
	sta regA
c0	lda #0
	sta wsync
	sta colpf0
c1	lda #0
	sta colpf1
c2	lda #0
	sta colpf2
	set_dli dli3
	lda regA
	rti
.endl

dli3	.local
	sta regA
c0	lda #0
	sta wsync
	sta colpf0
c1	lda #0
	sta colpf1
c2	lda #0
	sta colpf2
	set_dli dli4
	lda regA
	rti
.endl

dli4	.local
	sta regA
c0	lda #0
	sta wsync
	sta colpf0
c1	lda #0
	sta colpf1
c2	lda #0
	sta colpf2
	set_dli dli0
	lda regA
	rti
.endl

flash	.local
i0	ldx #0
	lda coltab+195,x
	cmp #$ff
	beq a0
	inc i0+1
	sta dli0.c0+1
	jmp i1
a0	lda #0
	sta dli0.c0+1

i1	ldx #0
	lda coltab+170,x
	cmp #$ff
	beq a1
	inc i1+1
	sta dli0.c1+1
	jmp i2
a1	lda #0
	sta dli0.c1+1

i2	ldx #0
	lda coltab+185,x
	cmp #$ff
	beq a2
	inc i2+1
	sta dli0.c2+1
	jmp i3
a2	lda #0
	sta dli0.c2+1

//line 2

i3	ldx #0
	lda coltab+160,x
	cmp #$ff
	beq a3
	inc i3+1
	sta dli1.c0+1
	jmp i4
a3	lda #0
	sta dli1.c0+1

i4	ldx #0
	lda coltab+175,x
	cmp #$ff
	beq a4
	inc i4+1
	sta dli1.c1+1
	jmp i5
a4	lda #0
	sta dli1.c1+1

i5	ldx #0
	lda coltab+150,x
	cmp #$ff
	beq a5
	inc i5+1
	sta dli1.c2+1
	jmp i6
a5	lda #0
	sta dli1.c2+1

//line 3

i6	ldx #0
	lda coltab+140,x
	cmp #$ff
	beq a6
	inc i6+1
	sta dli2.c0+1
	jmp i7
a6	lda #0
	sta dli2.c0+1

i7	ldx #0
	lda coltab+150,x
	cmp #$ff
	beq a7
	inc i7+1
	sta dli2.c1+1
	jmp i8
a7	lda #0
	sta dli2.c1+1

i8	ldx #0
	lda coltab+155,x
	cmp #$ff
	beq a8
	inc i8+1
	sta dli2.c2+1
	jmp i9
a8	lda #0
	sta dli2.c2+1

//line 3

i9	ldx #0
	lda coltab+130,x
	cmp #$ff
	beq a9
	inc i9+1
	sta dli3.c0+1
	jmp i10
a9	lda #0
	sta dli3.c0+1

i10	ldx #0
	lda coltab+100,x
	cmp #$ff
	beq a10
	inc i10+1
	sta dli3.c1+1
	jmp i11
a10	lda #0
	sta dli3.c1+1

i11	ldx #0
	lda coltab+120,x
	cmp #$ff
	beq a11
	inc i11+1
	sta dli3.c2+1
	jmp i12
a11	lda #0
	sta dli3.c2+1

//line 3

i12	ldx #0
	lda coltab+95,x
	cmp #$ff
	beq a12
	inc i12+1
	sta dli4.c0+1
	jmp i13
a12	lda #0
	sta dli4.c0+1

i13	ldx #0
	lda coltab+110,x
	cmp #$ff
	beq a13
	inc i13+1
	sta dli4.c1+1
	jmp i14
a13	lda #0
	sta dli4.c1+1

i14	ldx #0
	lda coltab+80,x
	cmp #$ff
	beq a14
	inc i14+1
	sta dli4.c2+1
	jmp i15
a14	lda #0
	sta dli4.c2+1

//line 3

eee	mva #0 dmactl
	restore_nmi
	mva #1 end_eff
i15
	rts
	
.endl


coltab :200 dta b(0)
	dta b($30,$31,$32,$33,$34,$35,$36,$37,$37,$37,$37,$37,$37,$37,$37,$36,$35,$34,$33,$32,$31,$30,$ff)

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	