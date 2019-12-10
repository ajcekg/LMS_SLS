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
	:1   dta b($41),a(dlist)

	utils_wait_one_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	mva #$30 colbak
	mva #0 dmactl
	mva #$0 gtictl
	set_vbl vblk
	mwa #dlist dlptr
	mva #0 end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

tcol	dta b($30,$41,$52,$63,$74,$85,$96,$a7,$b8,$c9,$da,$eb,$fc,$1d,$2e,$1e,$0e)


vblk	.local
	phr
l1	ldx #0
	cpx #17
	beq eend
	lda tcol,x
	sta colbak
	inc l1+1
	jmp end
eend
	restore_nmi
	mva #1 end_eff
end	plr
	rti
.endl

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	