PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000
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

	utils_wait_one_frame
	utils_wait_end_frame
	utils_wait_x_frame

vram equ $c800
fnt1 equ vram+$400

line_len	equ 6*16
line_count	equ 8

gr_line_len = 580
dlist01	:3	dta b($70)
		:1	dta b($80)
vram_ptr equ *+1
.rept line_count #*line_len
		dta b($74),a(vram + :1)
.endr
.rept line_count #*line_len
		dta b($74),a(vram + :1)
.endr
		dta b($54),a(vram)
		:3  dta b($70)
		:1	dta b($80)
gs equ *+1		
		:1	dta b($5f),a(d00+(0*gr_line_len))
		:1	dta b($5f),a(d00+(1*gr_line_len))
		:1	dta b($5f),a(d00+(2*gr_line_len))
		:1	dta b($5f),a(d00+(3*gr_line_len))
		:1	dta b($5f),a(d00+(4*gr_line_len))
		:1	dta b($5f),a(d00+(5*gr_line_len))
		:1	dta b($5f),a(d00+(6*gr_line_len))		
		:1	dta b($5f),a(d01+(0*gr_line_len))
		:1	dta b($5f),a(d01+(1*gr_line_len))
		:1	dta b($5f),a(d01+(2*gr_line_len))
		:1	dta b($5f),a(d01+(3*gr_line_len))
		:1	dta b($5f),a(d01+(4*gr_line_len))
		:1	dta b($5f),a(d01+(5*gr_line_len))
		:1	dta b($5f),a(d01+(6*gr_line_len))				
		:1	dta b($5f),a(d02+(0*gr_line_len))
		:1	dta b($5f),a(d02+(1*gr_line_len))
		:1	dta b($5f),a(d02+(2*gr_line_len))
		:1	dta b($5f),a(d02+(3*gr_line_len))
		:1	dta b($5f),a(d02+(4*gr_line_len))
		:1	dta b($5f),a(d02+(5*gr_line_len))
		:1	dta b($5f),a(d02+(6*gr_line_len))		
		:1	dta b($5f),a(d03+(0*gr_line_len))
		:1	dta b($5f),a(d03+(1*gr_line_len))
		:1	dta b($5f),a(d03+(2*gr_line_len))
		:1	dta b($5f),a(d03+(3*gr_line_len))
		:1	dta b($5f),a(d03+(4*gr_line_len))
		:1	dta b($5f),a(d03+(5*gr_line_len))
		:1	dta b($5f),a(d03+(6*gr_line_len))
		:1	dta b($5f),a(d04+(0*gr_line_len))
		:1	dta b($5f),a(d04+(1*gr_line_len))
		:1	dta b($5f),a(d04+(2*gr_line_len))
		:1	dta b($5f),a(d04+(3*gr_line_len))
		:1	dta b($5f),a(d04+(4*gr_line_len))
		:1	dta b($5f),a(d04+(5*gr_line_len))
		:1	dta b($41),a(dlist01)


main	.local

.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
w0	cpw frmcnt #$3d80-32
	bne w0	
.endif
	jsr wait_one_frame
	jsr prepare_vram_and_clean_fnt
	jsr save_color
	
	jsr wait_one_frame

	mva #@dmactl(standard|dma) dmactl
	lda #>(fnt1)
	sta chbase
	mwa #dlist01 dlptr
	mva #0 colbak
	sta colpf0
	sta colpf1
	sta colpf2
	sta colpf3
	set_vbl vblk
	jsr draw_font
l1	jsr draw_font
	lda endpart
	beq l1
	
	jsr wait_one_frame
	restore_nmi
	mva #0 dmactl

.if PGENE = 0
	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif	

.endl

endpart dta b(0)
fadeou	dta b(0)

/////////////////////////////////////////////////////////////////////////////

vblk	.local
	phr
	set_turbo_dli dli02
	jsr fadeout
	jsr scroll_v
	jsr color_move
	jsr gr_scroll

	plr
	rti
.endl

/////////////////////////////////////////////////////////////////////////////

fadeout	.local
	lda fadeou
	bne gg0
	rts
gg0
	ldx #0
	ldy #0
k0	lda col,x
	and #$f0
q0	ora tc0+24
	sta col0,y
	sta col0+16,y
	sta col0+32,y	
	lda col+1,x
	and #$f0
q1	ora tc1+24
	sta col1,y
	sta col1+16,y
	sta col1+32,y		
	lda col+2,x
	and #$f0
q2	ora tc2+24
	sta col2,y
	sta col2+16,y
	sta col2+32,y		
	iny
	inx
	inx
	inx
	cpx #48
	bne k0
	dew q0+1
	dew q1+1
	dew q2+1
i0	ldy #0
	cpy #23
	beq eend
	inc i0+1
	rts
eend
	lda #{rts}
	sta fadeout
	sta endpart
	rts

.endl


fadein	.local
	ldx #0
	ldy #0
k0	lda col,x
	and #$f0
q0	ora tc0
	sta col0,y
	sta col0+16,y
	sta col0+32,y	
	lda col+1,x
	and #$f0
q1	ora tc1
	sta col1,y
	sta col1+16,y
	sta col1+32,y		
	lda col+2,x
	and #$f0
q2	ora tc2
	sta col2,y
	sta col2+16,y
	sta col2+32,y		
	iny
	inx
	inx
	inx
	cpx #48
	bne k0
	inw q0+1
	inw q1+1
	inw q2+1
i0	ldy #0
	cpy #23
	beq eend
	inc i0+1
	rts
eend
	lda #{rts}
	sta fadein
	sta gr_scroll+1
	rts
	
	
.endl

tc0	dta b(0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5)
tc1	dta b(0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,7,7,8,8,9,9)
tc2 dta b(1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,$a,$a,$b,$c,$d,$e)

save_color	.local
	ldx #0
	ldy #0
.rept 48 # 
	lda	dli02.c:1+1
	sta col,x+
	sty dli02.c:1+1
.endr
	rts
.endl

color_move	.local
l2	lda #2
	bne ll
	mva #2 l2+1
	jmp l00
ll	dec l2+1
	rts
l00	jsr fadein
l0	ldx #16
.rept 16 #*3 (#*3)+1 (#*3)+2
	lda col0,x
	sta dli02.c:1+1
	lda col1,x
	sta dli02.c:2+1
	lda col2,x
	sta dli02.c:3+1
	inx
.endr
	ldx l0+1
	dex
	bmi l1
	dec l0+1
	rts
l1	lda #16
	sta l0+1
	rts	
.endl

col		:48	dta b(0)
col0	:48	dta b(0)
col1	:48	dta b(0)
col2	:48	dta b(0)
/////////////////////////////////////////////////////////////////////////////

gr_scroll	.local
	lda #0
	bne o0
	rts
o0	lda #15
	cmp #15
	beq ad
	cmp #13
	beq ab
	dec o0+1
	dec o0+1
	sta dli_gr.hs+1
	rts
ab	sta dli_gr.hs+1
	mva #15 o0+1
	rts
ad
	sta dli_gr.hs+1
	dec o0+1
	dec o0+1
.rept 34 #*3
	inw gs+:1
.endr
	cpw gs #(d00+((d00_end-d00)/7))-42
	bne end
	lda #{rts}
	sta gr_scroll
	sta fadeou
end	
	rts
.endl


/////////////////////////////////////////////////////////////////////////////
.align $100

SINUS_VS
      .byte 124,123,121,119,117,115
      .byte 113,110,108,105,102,99
      .byte 97,94,91,88,85,83
      .byte 80,78,75,73,71,69
      .byte 67,66,65,64,63,62
      .byte 61,61,61,60,60,61
      .byte 61,61,62,62,63,63
      .byte 64,65,65,66,66,66
      .byte 66,67,67,66,66,66
      .byte 65,64,63,62,60,59
      .byte 57,55,53,51,48,46
      .byte 43,40,38,35,32,29
      .byte 26,23,21,18,15,13
      .byte 11,9,7,5,4,2
      .byte 1,1,0,0,0,1
      .byte 1,2,3,5,7,9
      .byte 11,13,16,19,22,25
      .byte 28,32,35,39,42,46
      .byte 49,53,56,59,62,65
      .byte 68,71,73,75,77,79
      .byte 81,82,83,84,84,84
      .byte 84,84,84,83,82,81
      .byte 79,78,76,75,73,71
      .byte 69,67,65,63,61,59
      .byte 58,56,54,53,51,50
      .byte 49,48,48,47,47,47
      .byte 47,48,48,49,50,51
      .byte 52,53,55,56,58,60
      .byte 61,63,65,67,68,70
      .byte 72,73,74,76,77,78
      .byte 78,79,80,80,80,80
      .byte 79,79,78,77,76,75
      .byte 74,72,70,69,67,65
      .byte 63,61,59,57,55,53
      .byte 51,50,48,47,46,45
      .byte 44,43,43,43,43,43
      .byte 44,45,46,47,49,51
      .byte 53,55,57,60,63,66
      .byte 69,73,76,80,83,87
      .byte 90,94,97,100,104,107
      .byte 110,112,115,117,119,121
      .byte 123,124,125,126,127,127
      .byte 127,127,126,125

vram_h
.rept line_count #*line_len
	dta h(vram+:1)
.endr
.rept line_count #*line_len
	dta h(vram+:1)
.endr
vram_l
.rept line_count #*line_len
	dta l(vram+:1)
.endr
.rept line_count #*line_len
	dta l(vram+:1)
.endr

scroll_v	.local
c0	ldx #0
	lda SINUS_VS,x
	tay
	and #$7
	sta vscrol
	tya
	lsr
	lsr
	lsr
	tax
.rept 17 #*3
	lda vram_h,x
	sta vram_ptr+1+:1
	lda vram_l,x
	sta vram_ptr+:1
	inx
	txa
	and #$f
	tax
.endr	
	dec c0+1
	rts
.endl

////////////////////////////////////////////////////////////////////////////
.align $100
sin_y .local
 .byte 11,11,11,11,10,10
      .byte 10,9,9,9,8,8
      .byte 7,7,7,6,6,6
      .byte 5,5,5,4,4,4
      .byte 4,3,3,3,3,3
      .byte 3,3,3,3,3,3
      .byte 3,3,4,4,4,4
      .byte 4,4,5,5,5,5
      .byte 5,5,5,5,5,6
      .byte 6,6,5,5,5,5
      .byte 5,5,5,5,4,4
      .byte 4,4,3,3,3,2
      .byte 2,2,2,1,1,1
      .byte 1,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 1,1,1,1,2,2
      .byte 3,3,4,4,5,5
      .byte 6,6,7,7,8,9
      .byte 9,10,10,11,11,12
      .byte 12,13,13,13,14,14
      .byte 14,14,15,15,15,15
      .byte 15,15,15,15,15,15
      .byte 14,14,14,14,14,13
      .byte 13,13,12,12,12,12
      .byte 11,11,11,11,10,10
      .byte 10,10,10,10,10,10
      .byte 9,9,9,10,10,10
      .byte 10,10,10,10,10,10
      .byte 11,11,11,11,11,11
      .byte 12,12,12,12,12,12
      .byte 12,12,12,12,12,12
      .byte 11,11,11,11,11,10
      .byte 10,10,9,9,9,8
      .byte 8,7,7,7,6,6
      .byte 5,5,5,4,4,4
      .byte 4,4,3,3,3,3
      .byte 3,3,3,3,3,3
      .byte 4,4,4,4,5,5
      .byte 5,6,6,7,7,7
      .byte 8,8,9,9,9,10
      .byte 10,10,11,11,11,11
      .byte 12,12,12,12,12,12
      .byte 12,12,12,12
      .byte 11,11,11,11,11,11
      .byte 11,11,11,11,11,11
      .byte 11,10,10,10,10,10
      .byte 10,9,9,9,9,9
      .byte 8,8,8,8,7,7
      .byte 7,7,6,6,6,6
      .byte 5,5,5,5,4,4
      .byte 4,4,3,3,3,3
      .byte 2,2,2,2,2,1
      .byte 1,1,1,1,1,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,1
      .byte 1,1,1,1,1,2
      .byte 2,2,2,2,3,3
      .byte 3,3,4,4,4,4
      .byte 5,5,5,5,6,6
      .byte 6,6,7,7,7,7
      .byte 8,8,8,8,9,9
      .byte 9,9,9,10,10,10
      .byte 10,10,10,11,11,11
      .byte 11,11
      .byte 11,11,11,11,11,11
      .byte 11,11,11,11,11,11
      .byte 11,10,10,10,10,10
      .byte 10,9,9,9,9,9
      .byte 8,8,8,8,7,7
      .byte 7,7,6,6,6,6
      .byte 5,5,5,5,4,4
      .byte 4,4,3,3,3,3
      .byte 2,2,2,2,2,1
      .byte 1,1,1,1,1,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,1
      .byte 1,1,1,1,1,2
      .byte 2,2,2,2,3,3
      .byte 3,3,4,4,4,4
      .byte 5,5,5,5,6,6
      .byte 6,6,7,7,7,7
      .byte 8,8,8,8,9,9
      .byte 9,9,9,10,10,10
      .byte 10,10,10,11,11,11
      .byte 11,11
.endl
dli02 .local
	phr
r0	ldx #0
c0	mvy #$15 colpf0
c1	mvy #$29 colpf1
c2	mvy #$3e colpf2
	lda sin_y,x
	sta wsync
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
c3	mvy #$25 colpf0
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
c4	mvy #$39 colpf1
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
c5	mvy #$4e colpf2	
	sta hscrol
	inx	
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	
	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx			

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c6	mvy #$35 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c7	mvy #$49 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c8	mvy #$5e colpf2	
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c9	mvy #$45 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c10	mvy #$59 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c11	mvy #$6e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c12	mvy #$55 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c13	mvy #$69 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c14	mvy #$7e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c15	mvy #$65 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c16	mvy #$79 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c17	mvy #$8e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c18	mvy #$75 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c19	mvy #$89 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c20	mvy #$9e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c21	mvy #$85 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c22	mvy #$99 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c23	mvy #$ae colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c24	mvy #$95 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c25	mvy #$a9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c26	mvy #$be colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c27	mvy #$a5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c28	mvy #$b9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c29	mvy #$ce colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c30	mvy #$b5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c31	mvy #$c9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c32	mvy #$de colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c33	mvy #$c5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c34	mvy #$d9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c35	mvy #$ee colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c36	mvy #$d5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c37	mvy #$e9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c38	mvy #$fe colpf2	
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c39	mvy #$e5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c40	mvy #$f9 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c41	mvy #$1e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c42	mvy #$f5 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c43	mvy #$19 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c44	mvy #$2e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c45	mvy #$15 colpf0
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c46	mvy #$29 colpf1
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
c47	mvy #$3e colpf2
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx

	lda sin_y,x
	sta wsync
	nop
	nop
	nop
	sta hscrol
	inx
	restore_normal_nmi
	dec r0+1
	set_dli dli_gr
	plr
	rti
.endl

dli_gr	.local
	sta regA
	lda #$6a
	sta colpf1
	lda #0
	sta colpf2
hs	lda #15
	sta hscrol
	set_dli dli02
	lda regA
	rti
.endl

////////////////////////////////////////////////////////////////////////////
sin_offset equ 8
siny 	equ siny1
siny2	equ siny1+2


draw_font	.local
m0	lda #0
	sta i0+1
	inc m0+1
	inc m0+1

i0	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0+1
	clc
	adc #sin_offset
	sta i01+1

.rept 64
	lda pattern+$000+#,x
	ora pattern+$100+#,y
	sta fnt1+000+#
.endr

i01	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i01+1
	clc
	adc #sin_offset
	sta i02+1


.rept 64
	lda pattern+$200+#,x
	ora pattern+$300+#,y
	sta fnt1+064+#
.endr

i02	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i02+1
	clc
	adc #sin_offset
	sta i03+1

.rept 64
	lda pattern+$400+#,x
	ora pattern+$500+#,y
	sta fnt1+128+#
.endr

i03	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i03+1
	clc
	adc #sin_offset
	sta i04+1

.rept 64
	lda pattern+$600+#,x
	ora pattern+$700+#,y
	sta fnt1+192+#
.endr


i04	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i04+1
	clc
	adc #sin_offset
	sta i05+1

.rept 64
	lda pattern+$800+#,x
	ora pattern+$900+#,y
	sta fnt1+256+#
.endr

i05	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i05+1
	clc
	adc #sin_offset
	sta i06+1

.rept 64
	lda pattern+$a00+#,x
	ora pattern+$b00+#,y
	sta fnt1+64+256+#
.endr
	
i06	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i06+1
	clc
	adc #sin_offset
	sta i07+1

.rept 64
	lda pattern+$c00+#,x
	ora pattern+$d00+#,y
	sta fnt1+128+256+#
.endr

i07	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i07+1
	clc
	adc #sin_offset
	sta i08+1
	
.rept 64
	lda pattern+$e00+#,x
	ora pattern+$f00+#,y
	sta fnt1+192+256+#
.endr

i08	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i08+1
	clc
	adc #sin_offset
	sta i09+1

.rept 64
	lda pattern+$1000+#,x
	ora pattern+$1100+#,y
	sta fnt1+000+512+#
.endr

i09	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i09+1
	clc
	adc #sin_offset
	sta i0a+1

.rept 64
	lda pattern+$1200+#,x
	ora pattern+$1300+#,y
	sta fnt1+64+512+#
.endr

i0a	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0a+1
	clc
	adc #sin_offset
	sta i0b+1

.rept 64
	lda pattern+$1400+#,x
	ora pattern+$1500+#,y
	sta fnt1+128+512+#
.endr

i0b	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0b+1
	clc
	adc #sin_offset
	sta i0c+1

.rept 64
	lda pattern+$1600+#,x
	ora pattern+$1700+#,y
	sta fnt1+192+512+#
.endr

i0c	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0c+1
	clc
	adc #sin_offset
	sta i0d+1

.rept 64
	lda pattern+$1800+#,x
	ora pattern+$1900+#,y
	sta fnt1+000+256+512+#
.endr

i0d	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0d+1
	clc
	adc #sin_offset
	sta i0e+1

.rept 64
	lda pattern+$1a00+#,x
	ora pattern+$1b00+#,y
	sta fnt1+64+256+512+#
.endr

i0e	ldx #0
	ldy siny2,x
	lda siny,x
	tax
	lda i0e+1
	clc
	adc #sin_offset
	sta i0f+1

.rept 64
	lda pattern+$1c00+#,x
	ora pattern+$1d00+#,y
	sta fnt1+128+256+512+#
.endr

i0f	ldx #0
	ldy siny2,x
	lda siny,x
	tax
.rept 64
	lda pattern+$1e00+#,x
	ora pattern+$1f00+#,y
	sta fnt1+192+256+512+#
.endr

	rts


.endl


////////////////////////////////////////////////////////////////////////////
prepare_vram_and_clean_fnt	.local

//fill vram
		ldy #0
		tya
l0		
.rept	line_count	#*line_len
		sta vram + :1,y
		clc
		adc #1
		and #$7f
.endr
		iny
		cpy #line_len
		bne l0

//clear fnt
		lda #0
		tay
l1		sta fnt1+$000,y
		sta fnt1+$100,y
		sta fnt1+$200,y
		sta fnt1+$300,y
		iny
		bne l1
		rts
.endl


.align $100
siny1
	dta b(10,95,11,96,12,97,13,98,14,99,15,100,16,16,101,17)
	dta b(17,102,18,18,103,19,19,19,19,104,20,20,20,20,20,20)
	dta b(20,20,20,20,20,20,190,19,19,19,19,189,18,18,188,17)
	dta b(17,187,16,16,186,15,185,14,184,13,183,12,182,11,181,10)
	dta b(10,180,9,179,8,178,7,177,6,176,5,175,4,4,174,3)
	dta b(3,173,2,2,172,1,1,1,1,171,0,0,0,0,0,0)
	dta b(0,0,0,0,0,0,85,1,1,1,1,86,2,2,87,3)
	dta b(3,88,4,4,89,5,90,6,91,7,92,8,93,9,94,10)
	dta b(10,95,11,96,12,97,13,98,14,99,15,100,16,16,101,17,17,102,18,18,103,19,19,19,19,104,20,20,20,20,20,20,20,20,20,20,20,20,190,19,19,19,19,189,18,18,188,17,17,187,16,16,186,15,185,14,184,13,183,12,182,11,181,10,10,180,9,179,8,178,7,177,6,176,5,175,4,4,174,3,3,173,2,2,172,1,1,1,1,171,0,0,0,0,0,0,0,0,0,0,0,0,85,1,1,1,1,86,2,2,87,3,3,88,4,4,89,5,90,6,91,7,92,8,93,9,94,10)
	dta b(10,95,11,96,12,97,13,98,14,99,15,100,16,16,101,17,17,102,18,18,103,19,19,19,19,104,20,20,20,20,20,20,20,20,20,20,20,20,190,19,19,19,19,189,18,18,188,17,17,187,16,16,186,15,185,14,184,13,183,12,182,11,181,10,10,180,9,179,8,178,7,177,6,176,5,175,4,4,174,3,3,173,2,2,172,1,1,1,1,171,0,0,0,0,0,0,0,0,0,0,0,0,85,1,1,1,1,86,2,2,87,3,3,88,4,4,89,5,90,6,91,7,92,8,93,9,94,10)
end_siny

.align $100
pattern ins 'data\t01_data'

.align $1000
d00	ins "data\gr_data__0"
d00_end
.align $1000
d01	ins "data\gr_data__1"
.align $1000
d02	ins "data\gr_data__2"
.align $1000
d03	ins "data\gr_data__3"
.align $1000
d04	ins "data\gr_data__4"
trans ins "22_go_to_skull.obx.bc"
end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	
