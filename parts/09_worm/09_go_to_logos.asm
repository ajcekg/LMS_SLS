PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400
RUN_ADDRESS		equ	mainend
dptr			equ first_free_zp


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
	dta b($20)
	dta b($80)
ptr
.rept 28
	dta b($c2),a(scr)
.endr
	dta b($42),a(scr)
	:1   dta b($41),a(dlist)

	utils_wait_one_frame
	utils_wait_end_frame

.align
scr :41  dta b(0)
	:40  dta b(1)
	:100 dta b(0)

mainend	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	mva #$0 gtictl
	set_vbl vblk
	set_dli dli
	mwa #dlist dlptr
	mva #0 colbak
	mva #0 colpf2
	mva #0 end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	lda #>fnt
	sta chbase
	
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
	cpw #scr+84 ptr+1
	beq end
	ldy #1
	mwa #ptr dptr
	ldx #0
l0	lda wtab,x
	beq go
	dec wtab,x
l2	iny
	iny
	iny
	inx
	cpx #29
	bne l0
	jmp eend
go	
//	dec stab,x
//	dec stab,x	
//	bpl l2
//	lda #15
//	sta stab,x
	lda (dptr),y
	clc
	adc #1
	sta (dptr),y
	iny
	lda (dptr),y
	adc #0
	sta (dptr),y
	dey
	jmp l2
end
	restore_nmi
	mva #1 end_eff
eend	
	plr
	rti
.endl

dli	.local
	phr
l0	ldx #0
	//lda stab,x
	sta wsync
	//nop
	//nop
	//sta hscrol
	lda scol,x
	sta colpf1
	inc l0+1
	cpx #29
	bne end
	lda #0
	sta l0+1
end	plr
	rti
.endl


wtab	:29 dta b(1)
stab	:29 dta b(15)

scol	dta b($02,$13,$24,$35,$46,$57,$68,$79,$8a,$9b,$ac,$bd,$ce,$df,$ef)
		dta b($df,$ce,$bd,$ac,$9b,$8a,$79,$68,$57,$46,$35,$24,$13,$02,$00)

.align $400
fnt	:8	dta(0)
		dta(0,254,254,254,254,254,254,254)

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	