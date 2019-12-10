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
	:1	 dta b($01),a(dls)
dls	:237 dta b(0)
	:1	 dta b($80)
	:1   dta b($41),a(dlist)

	utils_wait_one_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	restore_nmi
	mva #$0 gtictl
	set_vbl vbl
	mwa #dlist dlptr
	mva #0 colbak
	mva #0 end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	jsr wait_one_frame
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

tcol	dta b($30,$41,$52,$63,$74,$85,$96,$a7,$b8,$c9,$da,$eb,$fc,$1d,$2e,$1e,$0e,$0f,$0f,$0f)


vbl	.local
	phr
l1	ldx #0
	cpx #20
	beq eend
	lda tcol,x
	sta colbak
	inc l1+1
	jmp end
eend
	set_vbl vblk
end	plr
	rti
.endl


vblk	.local
	phr
	set_dli dli
	lda #15
	sta colbak
l0	ldx #0
	lda #<dls
	clc
	adc SINUS,x
	sta dlist+1
	lda #>dls
	adc #0
	sta dlist+2
	inx
	cpx #sin_len
	beq eend
	inc l0+1
	jmp end
eend
	restore_nmi
	mva #0 colbak
	mva #1 end_eff
end	plr
	rti
.endl

dli	.local
	sta regA
	lda #0
	sta wsync
	sta wsync
	nop
	nop
	nop
	sta colbak
	lda regA
	rti
.endl
sin_len = sin_end - SINUS
SINUS .byte 0,1,2,3
      .byte 4,6,8,10,13,15
      .byte 18,22,25,29,32,36
      .byte 41,45,49,53,58,63
      .byte 67,72,76,81,85,90
      .byte 94,99,103,107,111,115
      .byte 119,122,126,129,132,135
      .byte 137,140,142,144,146,147
      .byte 148,149,150,151,151,151
      .byte 151,151,150,150,149,148
      .byte 146,145,143,142,140,138
      .byte 136,134,132,130,127,125
      .byte 123,121,119,116,114,112
      .byte 110,109,107,105,104,103
      .byte 102,101,100,99,99,99
      .byte 99,99,100,100,101,103
      .byte 104,106,108,110,112,115
      .byte 117,120,124,127,130,134
      .byte 138,142,146,150,155,159
      .byte 164,168,173,177,182,186
      .byte 191,196,200,204,209,213
      .byte 217,220,224,228,231,234
      .byte 237
sin_end
end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	