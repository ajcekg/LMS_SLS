PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400
RUN_ADDRESS		equ	mainend

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

dlist
	:4	dta b($70)
	:1	dta b($60,$80)
	:4	dta b($70)
	:1	dta b($60,$80)
	:4	dta b($70)
	:1	dta b($60,$80)
	:4	dta b($70)
	:1	dta b($60,$80)
	:4	dta b($70)
	:1	dta b($60,$80)				
	:1   dta b($41),a(dlist)

	utils_wait_one_frame
	
mainend	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	restore_nmi
	mwa #dlist dlptr
	mva #$22 colbak
	mva #0 end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	set_vbl vblk
	set_dli dli1
	
	
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

tabcol  dta b($22,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$1f)
		dta b($0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00)
tabwait	dta b(0,8,16,24,32,40)
tabinx	dta b(0,0,0,0,0,0)

vblk	.local
	phr
	ldx #0
n0	lda tabwait,x
	beq p0
	dec tabwait,x
n1	inx
	cpx #6
	bne n0
	jmp end
p0	ldy tabinx,x
	cpy #32
	beq n1
	inc tabinx,x	
	lda tabcol,y
	cpx #0
	bne q1
	sta c0+1
q1	cpx #1
	bne q2
	sta dli1.c1+1
q2	cpx #2
	bne q3
	sta dli2.c2+1
q3	cpx #3
	bne q4
	sta dli3.c3+1
q4	cpx #4
	bne	q5
	sta dli4.c4+1			
q5	cpx #5
	bne q6
	sta dli5.c5+1
q6	jmp n1	
end	
c0	lda #$22
	sta colbak
	lda dli5.c5+1
	bne eend
	restore_nmi
	mva #1 end_eff
eend	
	plr
	rti
.endl

dli1	.local
	pha
c1	lda #$22
	sta wsync
	nop
	nop
	sta colbak
	set_dli dli2
	pla
	rti
.endl
dli2	.local
	pha
c2	lda #$22
	sta wsync
	nop
	nop
	sta colbak	
	set_dli dli3
	pla
	rti
.endl
dli3	.local
	pha
c3	lda #$22
	sta wsync
	nop
	nop	
	sta colbak	
	set_dli dli4
	pla
	rti
.endl
dli4	.local
	pha
c4	lda #$22
	sta wsync
	nop
	nop	
	sta colbak	
	set_dli dli5
	pla
	rti
.endl
dli5	.local
	pha
c5	lda #$22
	sta wsync
	nop
	nop	
	sta colbak	
	set_dli dli1
	pla
	rti
.endl

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	