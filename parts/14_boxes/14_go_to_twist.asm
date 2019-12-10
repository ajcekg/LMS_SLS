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

dlist .local
c0	:1	 dta b($01),a(a0)
	:84  dta b($00)
a0	:1   dta b($80)	
c1	:1	 dta b($01),a(a1)
a1	:234 dta b($00)
	:1	 dta b($80)
	:1   dta b($41),a(dlist)
.endl
	utils_wait_one_frame
	utils_wait_end_frame
main	.local
.if PGENE = 1
	jsr rom_off
.endif
    .rept 15
    jsr wait_one_frame
    .endr
    
	jsr wait_end_frame
	lda #$0
	sta gtictl
	sta colbak
	sta end_eff
	set_vbl vblk
	set_dli dli1
	mwa #dlist dlptr
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
v0	ldx #0
	sec
	lda #<dlist.a0
	sbc SINUSU,x
	sta dlist.c0+1
	lda #>dlist.a0
	sbc #0
	sta dlist.c0+2
	inx
	cpx #83
	beq col
	inc v0+1
	
	dex
	lda SINUSU,x
	asl
	sta v1+1
	clc
	lda #<dlist.a1
v1	adc #0
	sta dlist.c1+1
	lda #>dlist.a1
	adc #0
	sta dlist.c1+2	
col
	ldx #0
	lda SINUSC,x
	cmp #$ff
	beq eend
	ora #$80
	sta dli1.c+1
	inc col+1
	jmp end
eend
	lda #0
	sta dmactl
	restore_nmi
	mva #1 end_eff
end	
	plr
	rti
.endl

dli1 .local
	sta regA
c	lda #0
	sta wsync
	nop
	nop
	sta colbak
	set_dli dli2
	lda regA
	rti
.endl

dli2 .local
	sta regA
	lda #0
	sta wsync
	nop
	nop
	sta colbak
	set_dli dli1
	lda regA
	rti
.endl


SINUSU .byte 0,2,3,5,7,8
      .byte 10,12,13,15,16,18
      .byte 20,21,23,24,26,28
      .byte 29,31,32,34,35,37
      .byte 38,40,41,42,44,45
      .byte 47,48,49,51,52,53
      .byte 55,56,57,58,59,61
      .byte 62,63,64,65,66,67
      .byte 68,69,70,71,72,72
      .byte 73,74,75,76,76,77
      .byte 78,78,79,79,80,80
      .byte 81,81,82,82,82,83
      .byte 83,83,83,84,84,84
      .byte 84,84,84,84,84,84
      .byte 84,84

SINUSC .byte 0,0,0,1,1,1
      .byte 1,1,2,2,2,2
      .byte 2,3,3,3,3,3
      .byte 3,4,4,4,4,4
      .byte 5,5,5,5,5,5
      .byte 6,6,6,6,6,6
      .byte 6,7,7,7,7,7
      .byte 7,7,8,8,8,8
      .byte 8,8,8,8,9,9
      .byte 9,9,9,9,9,9
      .byte 9,9,9,9,10,10
      .byte 10,10,10,10,10,10
      .byte 10,10,10,10,10,10
      .byte 10,10,10,10,10,10
      .byte 10,10,10,10,10,10
      .byte 10,10,10,10,10,10
      .byte 10,9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,255

end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	