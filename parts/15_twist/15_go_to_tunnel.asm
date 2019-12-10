PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400
RUN_ADDRESS		equ	main

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
	:1	 dta b($44),a(scr)
	:29	 dta b($04)
	:1   dta b($41),a(dlist)

scr :1200 dta b(0)

	utils_wait_one_frame
	utils_wait_x_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	lda #2
	jsr wait_x_frame
	jsr wait_one_frame
	set_vbl vblk
	mwa #dlist dlptr
	lda #0
	sta colbak
	sta end_eff
	sta gtictl
	sta pmcntl
	mva #$64 colpf0
	mva #$88 colpf1
	mva #$9b colpf2
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	mva #>fnt chbase

.if PGENE = 0
	jsr OS_PREP_NEXT_PART //tu tak ma byæ - nic nie zmieniaæ !!!!
	jmp OS_PREP_NEXT_PART //tu te¿ !!!
.else
	jmp *
.endif
.endl

vblk	.local
	phr
	mwa #dlist dlptr	
	jsr draw_line_01
	jsr draw_line_02
	jsr draw_line_03
	jsr draw_line_04
v0	ldx #80
	beq eend
	dec v0+1
	jmp end
eend
	restore_nmi
	lda #0
	sta dmactl
	sta colbak
	sta colpf0
	sta colpf1
	sta colpf2
	mva #1 end_eff
end	plr
	rti
.endl

line_h
.rept 30 #*40
	dta h(scr+:1)
.endr
line_l
.rept 30 #*40
	dta l(scr+:1)
.endr

addr equ first_free_zp

draw_line_01	.local
p0	ldx #29
p1	ldy #0
	lda line_l,x
	sta addr
	lda line_h,x
	sta addr+1
l0	lda #3
	sta (addr),y
	adw addr #40
	iny
	cpy #40
	beq l1	
	inx
	cpx #30
	bne l0	
	ldx p0+1
	beq l1
	dex
	stx p0+1
	jmp end
l1	lda p1+1
	cmp #39
	beq end
	inc p1+1	
end	
	rts
.endl

draw_line_02	.local
	lda #2
	beq p0
	dec draw_line_02+1
	rts
p0	ldx #29
p1	ldy #0
	lda line_l,x
	sta addr
	lda line_h,x
	sta addr+1
l0	lda #2
	sta (addr),y
	adw addr #40
	iny
	cpy #40
	beq l1	
	inx
	cpx #30
	bne l0	
	ldx p0+1
	beq l1
	dex
	stx p0+1
	jmp end
l1	lda p1+1
	cmp #39
	beq end
	inc p1+1	
end	
	rts
.endl

draw_line_03	.local
	lda #5
	beq p0
	dec draw_line_03+1
	rts
p0	ldx #29
p1	ldy #0
	lda line_l,x
	sta addr
	lda line_h,x
	sta addr+1
l0	lda #1
	sta (addr),y
	adw addr #40
	iny
	cpy #40
	beq l1	
	inx
	cpx #30
	bne l0	
	ldx p0+1
	beq l1
	dex
	stx p0+1
	jmp end
l1	lda p1+1
	cmp #39
	beq end
	inc p1+1	
end	
	rts
.endl

draw_line_04	.local
	lda #10
	beq p0
	dec draw_line_04+1
	rts
p0	ldx #29
p1	ldy #0
	lda line_l,x
	sta addr
	lda line_h,x
	sta addr+1
l0	lda #0
	sta (addr),y
	adw addr #40
	iny
	cpy #40
	beq l1	
	inx
	cpx #30
	bne l0	
	ldx p0+1
	beq l1
	dex
	stx p0+1
	jmp end
l1	lda p1+1
	cmp #39
	beq end
	inc p1+1	
end	
	rts
.endl


.align $400
fnt	dta b(0,0,0,0,0,0,0,0)
	dta b(0,0,%00010101,%00010101,%00010101,%00010101,%00010101,%00010101)
	dta b(0,0,%00101010,%00101010,%00101010,%00101010,%00101010,%00101010)
	dta b(0,0,%00111111,%00111111,%00111111,%00111111,%00111111,%00111111)

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	