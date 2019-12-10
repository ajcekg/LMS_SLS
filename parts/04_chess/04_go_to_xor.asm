PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000
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

data :40 dta b(0)
	ins 'data\gotoxor.dta_0'

.align $400
dlist
	:2	 dta b($70)
	:1	 dta b($30)
dlfl equ *+1
	:101 dta b($4d),a(data)
	:1   dta b($41),a(dlist)

	utils_wait_one_frame
mainend	.local
.if PGENE = 1
	jsr rom_off
.endif

	jsr wait_one_frame
	mwa #dlist dlptr
	mva #0 colbak
	mva #15 colpf0
	set_vbl vblk
	mva #0 end_eff

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
l0	ldx #1
	lda data_l,x
	sta dlfl+(50*3)
	lda data_h,x
	sta dlfl+(50*3)+1
	inx
	cpx #81
	beq n0
	stx l0+1
	
n0	
	ldx #0
l1	ldy #0
	bmi i0
	cpy #80
	beq w0
l2	lda data_l,y
	sta dlfl+(51*3),x
	inx
	lda data_h,y
	sta dlfl+(51*3),x
	inx
	inx
	cpx #(3*50)
	beq i0
	dey
	bpl l2
i0	inc l1+1

w0  
	ldx #147
k1	ldy #0
	bmi j0
k2	cpy #80
	beq end
	lda data_l,y
	sta dlfl,x
	inx
	lda data_h,y
	sta dlfl,x	
	dex
	dex
	dex
	dex
	beq j0
	dey
	bpl k2
j0	inc k1+1
	
	
end	lda #0
	cmp #84
	beq end2
	inc end+1
	lsr
	lsr
	tax
	lda coltab,x
	sta colbak
	jmp end1
end2
	restore_vbl
	mva #1 end_eff
end1
	plr
	rti
.endl

coltab dta b(0,1,1,2,3,3,4,5,5,6,7,8,8,9,10,11,12,13,14,15,15,15,15,15,15,15,15,15)

.align
data_h
.rept 81 #*40
	dta h(data+:1)
.endr
data_l
.rept 81 #*40
	dta l(data+:1)
.endr


end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	