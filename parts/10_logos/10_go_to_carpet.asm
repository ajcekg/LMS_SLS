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

dlist .local
a0	:1	 dta b($01),a(l0)
l0	:116 dta b($00)
a1	:1	 dta b($01),a(l2)
l1	:119 dta b($ed),a(linebuf)
l2	equ *-3
	:1   dta b($41),a(dlist)
.endl
linebuf	:40 dta b($00)

	//utils_wait_one_frame
	utils_wait_end_frame

mainend	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_end_frame
	lda #$0
	sta gtictl
	sta pmcntl
	sta colbak
	sta end_eff
	sta sizem
	mwa #dlist dlptr
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	set_vbl vblk
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

col .byte 0,1,1,2,2,3
      .byte 4,4,5,5,6,6
      .byte 7,7,8,8,9,9
      .byte 10,10,11,11,11,12
      .byte 12,12,13,13,13,14
      .byte 14,14,14,14,15,15
      .byte 15,15,15,15,15,15
      .byte 15,15,15,15,15,14
      .byte 14,14,14,14,13,13
      .byte 13,12,12,12,11,11
      .byte 11,10,10,9,9,8
      .byte 8,7,7,6,6,5
      .byte 5,4,4,3,2,2
      .byte 1,1

vblk	.local
	phr
	jsr make_line_buf
l0	ldx #0
	lda col,x
	sta colpf0
	inx
	cpx #80
	beq eend
	inc l0+1
	jmp end
eend
	restore_nmi
	lda #0
	sta dmactl
	sta colpf0
	lda #1
	sta end_eff
end
	plr
	rti
.endl

pixdata	dta b(64,16,4,1)

make_line_buf	.local
	
l1	lda #79
	beq eend
	tax
	lsr
	lsr
	tay
	txa
	and #$03
	tax
	lda linebuf,y
	ora pixdata,x
	sta linebuf,y
	dec l1+1
	
	lda l1+1
	cmp #21
	bcc l2
	adw dlist.a0+1 #2
	
l2	lda #80
	tax
	lsr
	lsr
	tay
	txa
	and #$03
	tax
	lda linebuf,y
	ora pixdata,x
	sta linebuf,y
	inc l2+1	
	lda l1+1
	cmp #21
	bcc end
	sbw dlist.a1+1 #6
end	rts
eend
	lda #{rts}
	sta make_line_buf
	rts
.endl


end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	