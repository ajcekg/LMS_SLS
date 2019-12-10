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
j1	:1		dta b($01),a(f1)
f1	:117	dta b($0)
e1	:1		dta b($80)
j2	:1		dta b($01),a(f2)
e2	:233	dta b($0)
f2	:1		dta b($80)
	:1   dta b($41),a(dlist)

dlist1
	:1	 dta b($40)
	:115 dta b($4d),a(buf)
	:1	 dta b($41),a(dlist1)
buf :40 dta b(%01010101)	

	utils_wait_one_frame
	utils_wait_end_frame
	
main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_end_frame
	mva #$1 gtictl
	set_vbl vblk
	set_dli dli1
	mwa #dlist dlptr
	lda #0
	sta colbak
	sta end_eff
	pm_out_of_screen

		lda #0
		sta colpm0
		sta colpm1
		lda #3
		sta sizep0
		sta sizep1
		lda #255
		sta grafp0
		sta grafp1
		lda #16
		sta hposp0
		lda #208
		sta hposp1
		lda #1
		sta gtictl

	mva #@dmactl(standard|dma) dmactl

l0	jsr wait_one_frame
l00	lda #$90
	cmp #$9f
	beq l1
	sta dli1.c0+1
	sta dli1.c1+1
	inc l00+1
	jmp l0
	
l1	jsr wait_one_frame
	inw j1+1
	dew j2+1
	lda #$9f
	sta dli1.c0+1
	sta dli2.c2+1
	lda #$90
	sta dli1.c1+1
	lda #0
	sta vblk.on+1


.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
	mva #0 colbak
on	lda #1
	bne end
k0	ldx #113
	beq eend
	inw j1+1
	dew j2+1
	dew j2+1
	dec k0+1
	jmp end
eend
	set_vbl vblk1
end	plr
	rti
.endl

vblk1	.local
	phr
l0	ldx #$9f
	cpx #$8f
	beq eend
	stx dli1.c0+1
	stx dli2.c2+1
	dec l0+1
	jmp end
eend
	mva #$90 colpf0
	restore_nmi
	mwa #dlist1 dlptr
	mva #1 end_eff	
end	plr
	rti
.endl

dli1	.local
	sta regA
c0	lda #0
	sta wsync
	nop
	nop
	sta colbak
c1	lda #0
	sta wsync
	nop
	nop
	sta colbak
g	set_dli dli2
	lda regA
	rti
.endl

dli2	.local
	sta regA
c2	lda #$00
	sta wsync
	nop
	nop
	sta colbak
	lda #0
	sta wsync
	nop
	nop
	sta colbak
	set_dli dli1
	lda regA
	rti
.endl

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	