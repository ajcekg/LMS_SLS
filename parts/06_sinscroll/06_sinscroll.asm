PPD = 0	//0-demo build, 1-standalone part

color0	equ colpf0
color1	equ colpf1
color2	equ colpf2
color3	equ colpf3


scrollptr		equ		first_free_zp	//2b
sinpos			equ		scrollptr+2		//1
tsinpos			equ		sinpos+1		//1
tscrollptr		equ		tsinpos+1		//2b
tmp1			equ		tscrollptr+2	//2b
abar			equ		tmp1+2			//1b
tmp2			equ		abar+1			//2b
sinxpos			equ		tmp2+2			//1b


vram01		equ	$c800
vram02		equ $cc00
vlinelen	equ	48

RUN_ADDRESS		equ		main

.if PPD = 0
LOAD_ADDRESS	equ		$a00
		icl 'sls.hea'
		icl 'pd_macro.hea'
		part_header
.else
LOAD_ADDRESS	equ		$a00
		org LOAD_ADDRESS
		icl 'atari.hea'
		icl '..\..\lib\stdlib.asm'

.endif

//////////////////////////////////////////////////////
	utils_wait_one_frame
	utils_wait_end_frame
	utils_wait_x_frame

//////////////////////////////////////////////////////

dlist01
		:5	dta b($70)
		:1	dta b($80)
		:3	dta b(0)
.rept 15 #*vlinelen
		:+1	dta b($d4-$80),a(vram01+:1)
.endr
		:1	dta b($d4-$80),a(vram01+(15*vlinelen))
		:1	dta b($41),a(dlist01)		

dlist02
		:5	dta b($70)
		:1	dta b($80)
		:3	dta b(0)		
.rept 15 #*vlinelen		
		:+1	dta b($d4-$80),a(vram02+:1)
.endr
		:1	dta b($d4-$80),a(vram02+(15*vlinelen))
		:1	dta b($41),a(dlist02)
		
///////////////////////////////////////////////////////		
main	.local

.if PPD = 1
		jsr rom_off
		mwa #0 frmcnt
.else
str		lda end_eff
		beq str
		ldy #0
		sty sinxpos
		tya
qq		sta vram01,y
		sta vram01+$100,y
		sta vram01+$200,y
		sta vram01+$300,y
		sta vram02,y
		sta vram02+$100,y
		sta vram02+$200,y
		sta vram02+$300,y		
		iny
		bne qq
s0		cpw frmcnt #((11*64*6)-(32*6)-(48*6))+(16*6)
		bne s0		
.endif
		lda #0
		sta pmcntl		
		sta hscrol
		sta colpf0
		mwa #dlist01 dlptr
		mva #@dmactl(standard|dma) dmactl
		set_dli dl002	//dli01
		set_vbl vblk
		jsr scroll_init
loop	
		jsr wait_end_frame
		mwa #dlist02 dlptr
		jsr prepare_sinx_3
		jsr scroll_1

		jsr wait_end_frame
		inw scrollptr	
		mwa #dlist01 dlptr
		jsr prepare_sinx_1
		jsr scroll_2

		cpw scrollptr #scroll_end
		bne loop
		restore_vbl
eend
.if PPD = 1		
		jmp *
.else
		jmp $303		
.endif
.endl
////////////////////////////////////////////////////////////////

vblk	.local
	phr
	mva #0 colbak
	mva #$8e colpf1
	plr
	rti
.endl


////////////////////////////////////////////////////////////////

dl002	.local
	sta regA
	stx regX
	sty regY
	sta wsync
	nop
	mva #$60 colbak
	sta wsync
	nop
	mva #$00 colbak
	sta wsync
	nop
	mva #$60 colbak	
//line 0
sx_0_0
	ldy #0
	ldx #>fnt_addr+00
	sta wsync
	stx chbase
	nop
	sty hscrol

//line 1
sx_0_1	ldy #0
	sta wsync
	nop
	mva #$12 colpf2
	sty hscrol

//line 2
sx_0_2	ldy #0
	sta wsync
	nop
	mva #$10 colpf2
	sty hscrol

//line 3
sx_0_3	ldy #0
	sta wsync
	nop
	mva #$12 colpf2
	sty hscrol

//line 4
sx_0_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol

//line 5
sx_0_5	ldy #0
	sta wsync
	nop
	mva #$62 colbak	
	sty hscrol	

//line 6
sx_0_6	ldy #0
	sta wsync
	nop
	mva #$60 colbak	
	sty hscrol

//line 7
sx_0_7	ldy #0
	sta wsync
	nop
	mva #$62 colbak	
	sty hscrol

//line 8
sx_1_0	ldy #0
	ldx #>fnt_addr+04
	sta wsync
	stx chbase
	nop
	sty hscrol

//line 9
sx_1_1	ldy #0
	sta wsync
	nop
	mva #$12 colpf2
	sty hscrol
	
//line 10
sx_1_2	ldy #0
	sta wsync
	nop
	mva #$24 colpf2
	sty hscrol	
	
//line 11
sx_1_3	ldy #0
	sta wsync
	nop
	mva #$22 colpf2
	sty hscrol
	
//line 12
sx_1_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
		
//line 13
sx_1_5	ldy #0
	sta wsync
	nop
	mva #$64 colbak	
	sty hscrol
	
//line 14
sx_1_6	ldy #0
	sta wsync
	nop
	mva #$62 colbak	
	sty hscrol
	
//line 15
sx_1_7	ldy #0
	sta wsync
	nop
	mva #$64 colbak	
	sty hscrol	

//line 16
sx_2_0	ldy #0
	ldx #>fnt_addr+08
	sta wsync
	stx chbase
	nop
	sty hscrol

//line 17
sx_2_1	ldy #0
	sta wsync
	nop
	mva #$24 colpf2
	sty hscrol	
//line 18

sx_2_2	ldy #0
	sta wsync
	nop
	mva #$36 colpf2
	sty hscrol	
	
//line 19
sx_2_3	ldy #0
	sta wsync
	nop
	mva #$34 colpf2
	sty hscrol	
//line 20
sx_2_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
		
//line 21
sx_2_5	ldy #0
	sta wsync
	nop
	mva #$66 colbak	
	sty hscrol
	
//line 22
sx_2_6	ldy #0
	sta wsync
	nop
	mva #$64 colbak	
	sty hscrol
	
//line 23
sx_2_7	ldy #0
	sta wsync
	nop
	mva #$66 colbak	
	sty hscrol

//line 24
sx_3_0	ldy #0
	ldx #>fnt_addr+12
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 25
sx_3_1	ldy #0
	sta wsync
	nop
	mva #$36 colpf2
	sty hscrol
	
//line 26
sx_3_2	ldy #0
	sta wsync
	nop
	mva #$48 colpf2
	sty hscrol
	
//line 27
sx_3_3	ldy #0
	sta wsync
	nop
	mva #$46 colpf2
	sty hscrol
	
//line 28
sx_3_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 29
sx_3_5	ldy #0
	sta wsync
	nop
	mva #$78 colbak	
	sty hscrol
	
//line 30
sx_3_6	ldy #0
	sta wsync
	nop
	mva #$66 colbak	
	sty hscrol
	
//line 31
sx_3_7	ldy #0
	sta wsync
	nop
	mva #$78 colbak	
	sty hscrol
	
//line 32
sx_4_0	ldy #0
	ldx #>fnt_addr+16
	sta wsync
	stx chbase
	nop
	sty hscrol	
	
//line 33
sx_4_1	ldy #0
	sta wsync
	nop
	mva #$48 colpf2
	sty hscrol
	
//line 34
sx_4_2	ldy #0
	sta wsync
	nop
	mva #$5a colpf2
	sty hscrol
	
//line 35
sx_4_3	ldy #0
	sta wsync
	nop
	mva #$58 colpf2
	sty hscrol
	
//line 36
sx_4_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 37
sx_4_5	ldy #0
	sta wsync
	nop
	mva #$7a colbak	
	sty hscrol
	
//line 38
sx_4_6	ldy #0
	sta wsync
	nop
	mva #$78 colbak	
	sty hscrol
	
//line 39
sx_4_7	ldy #0
	sta wsync
	nop
	mva #$7a colbak	
	sty hscrol

//line 40
sx_5_0	ldy #0
	ldx #>fnt_addr+20
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 41
sx_5_1	ldy #0
	sta wsync
	nop
	mva #$5a colpf2
	sty hscrol

//line 42
sx_5_2	ldy #0
	sta wsync
	nop
	mva #$6c colpf2
	sty hscrol
	
//line 43
sx_5_3	ldy #0
	sta wsync
	nop
	mva #$6a colpf2
	sty hscrol
	
//line 44
sx_5_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 45
sx_5_5	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 46
sx_5_6	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 47
sx_5_7	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 48
sx_6_0	ldy #0
	ldx #>fnt_addr+24
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 49
sx_6_1	ldy #0
	sta wsync
	nop
	mva #$6c colpf2
	sty hscrol
	
//line 50
sx_6_2	ldy #0
	sta wsync
	nop
	mva #$7e colpf2
	sty hscrol
	
//line 51
sx_6_3	ldy #0
	sta wsync
	nop
	mva #$7c colpf2
	sty hscrol
	
//line 52
sx_6_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 53
sx_6_5	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 54
sx_6_6	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 55
sx_6_7	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 56
sx_7_0	ldy #0
	ldx #>fnt_addr+28
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 57
sx_7_1	ldy #0
	sta wsync
	nop
	mva #$7e colpf2
	sty hscrol
	
//line 58
sx_7_2	ldy #0
	sta wsync
	nop
	mva #$8e colpf2
	sty hscrol
	
//line 59
sx_7_3	ldy #0
	sta wsync
	nop
	mva #$7c colpf2
	sty hscrol
	
//line 60
sx_7_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 61
sx_7_5	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 62
sx_7_6	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 63
sx_7_7	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 64
sx_8_0	ldy #0
	ldx #>fnt_addr+32
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 65
sx_8_1	ldy #0
	sta wsync
	mva #$8e colpf1
	mva #$9e colpf2
	sty hscrol
	
//line 66
sx_8_2	ldy #0
	sta wsync
	nop
	mva #$8e colpf2
	sty hscrol
	
//line 67
sx_8_3	ldy #0
	sta wsync
	nop
	mva #$9e colpf2
	sty hscrol
	
//line 68
sx_8_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 69
sx_8_5	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 70
sx_8_6	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 71
sx_8_7	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 72
sx_9_0	ldy #0
	ldx #>fnt_addr+36
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 73
sx_9_1	ldy #0
	sta wsync
	nop
	mva #$9c colpf1
	sty hscrol
	
//line 74
sx_9_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
//line 75
sx_9_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 76
sx_9_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 77
sx_9_5	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
//line 78
sx_9_6	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 79
sx_9_7	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 80
sx_10_0	ldy #0
	ldx #>fnt_addr+40
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 81
sx_10_1	ldy #0
	sta wsync
	nop
	mva #$aa colpf1
	sty hscrol
	
//line 82
sx_10_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 83
sx_10_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol	
//line 84
sx_10_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 85
sx_10_5	ldy #0
	sta wsync
	nop
	mva #$78 colbak
	sty hscrol
	
//line 86
sx_10_6	ldy #0
	sta wsync
	nop
	mva #$7a colbak
	sty hscrol
	
//line 87
sx_10_7	ldy #0
	sta wsync
	nop
	mva #$78 colbak
	sty hscrol
	
//line 88
sx_11_0	ldy #0
	ldx #>fnt_addr+44
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 89
sx_11_1	ldy #0
	sta wsync
	nop
	mva #$b8 colpf1
	sty hscrol
	
//line 90
sx_11_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 91
sx_11_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 92
sx_11_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 93
sx_11_5	ldy #0
	sta wsync
	nop
	mva #$66 colbak
	sty hscrol
	
//line 94
sx_11_6	ldy #0
	sta wsync
	nop
	mva #$78 colbak
	sty hscrol
	
//line 95
sx_11_7	ldy #0
	sta wsync
	nop
	mva #$66 colbak
	sty hscrol
	
//line 96
sx_12_0	ldy #0
	ldx #>fnt_addr+48
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 97
sx_12_1	ldy #0
	sta wsync
	nop
	mva #$c6 colpf1
	sty hscrol
	
//line 98
sx_12_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 99
sx_12_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 100
sx_12_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 101
sx_12_5	ldy #0
	sta wsync
	nop
	mva #$64 colbak
	sty hscrol
	
//line 102
sx_12_6	ldy #0
	sta wsync
	nop
	mva #$66 colbak
	sty hscrol
	
//line 103
sx_12_7	ldy #0
	sta wsync
	nop
	mva #$64 colbak
	sty hscrol
	
//line 104
sx_13_0	ldy #0
	ldx #>fnt_addr+52
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 105
sx_13_1	ldy #0
	sta wsync
	nop
	mva #$d4 colpf1
	sty hscrol
	
//line 106
sx_13_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol

//line 107
sx_13_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 108
sx_13_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol

//line 109
sx_13_5	ldy #0
	sta wsync
	nop
	mva #$62 colbak
	sty hscrol

//line 110
sx_13_6	ldy #0
	sta wsync
	nop
	mva #$64 colbak
	sty hscrol
	
//line 111
sx_13_7	ldy #0
	sta wsync
	nop
	mva #$62 colbak
	sty hscrol
	
//line 112
sx_14_0	ldy #0
	ldx #>fnt_addr+56
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 113
sx_14_1	ldy #0
	sta wsync
	nop
	mva #$e2 colpf1
	sty hscrol
	
//line 114
sx_14_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 115
sx_14_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 116
sx_14_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 117
sx_14_5	ldy #0
	sta wsync
	nop
	mva #$60 colbak
	sty hscrol
	
//line 118
sx_14_6	ldy #0
	sta wsync
	nop
	mva #$62 colbak
	sty hscrol
	
//line 119
sx_14_7	ldy #0
	sta wsync
	nop
	mva #$60 colbak
	sty hscrol
	
//line 120
sx_15_0	ldy #0
	ldx #>fnt_addr+60
	sta wsync
	stx chbase
	nop
	sty hscrol
	
//line 121
sx_15_1	ldy #0
	sta wsync
	nop
	mva #$f0 colpf1
	sty hscrol
	
//line 122
sx_15_2	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 123
sx_15_3	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 124
sx_15_4	ldy #0
	sta wsync
	nop
	nop
	nop
	sty hscrol
	
//line 125
sx_15_5	ldy #0
	sta wsync
	nop
	mva #$00 colbak	
	sty hscrol
	
//line 126
sx_15_6	ldy #0
	sta wsync
	nop
	mva #$60 colbak	
	sty hscrol
	
//line 127
sx_15_7	ldy #0
	sta wsync
	nop
	mva #$00 colbak	
	sty hscrol
	lda regA
	ldx regX
	ldy regY
	rti
.endl

////////////////////////////////////////////////////////////////
.align
sintab1 dta b(sin(7,6,85,0,84))
		dta b(sin(7,6,85,0,84))
		dta b(sin(7,6,86,0,85))		
sintab3 dta b(sin(9,6,85,0,84))
		dta b(sin(9,6,85,0,84))
		dta b(sin(9,6,86,0,85))		

prepare_sinx_3	.local
	dec sinxpos
	dec sinxpos	
	ldx sinxpos
.rept 128 #/8 #%8
	lda sintab3,x
	sta dl002.sx_:1_:2+1
	inx
.endr
	rts
.endl

prepare_sinx_1	.local
	dec sinxpos
	dec sinxpos	
	ldx sinxpos
.rept 128 #/8 #%8
	lda sintab1,x
	sta dl002.sx_:1_:2+1
	inx
.endr
	rts
.endl

////////////////////////////////////////////////////////////////
scroll_init	.local
	mwa #scroll_text+1 scrollptr
	mva #0 sinpos
	rts
.endl
////////////////////////////////////////////////////////////////

barnum equ 44
letterline equ 16
barcnt equ 31

scroll_1	.local
		mwa scrollptr tscrollptr
		dec sinpos
		lda sinpos
		bpl q1
		mva #30 sinpos
q1		mva sinpos tsinpos
		mva #0 abar
		
loop	ldy abar
		lda (tscrollptr),y
		asl
		tax
		lda bars,x
		sta tmp1
		lda bars+1,x
		sta tmp1+1
		lda tsinpos
		asl
		tay
		lda (tmp1),y
		sta tmp2
		iny
		lda (tmp1),y
		sta tmp2+1
		ldy #0
		ldx abar
.rept letterline #*vlinelen
		lda (tmp2),y+
		sta vram01+:1,x
.endr
		inc tsinpos
		ldy tsinpos
		cpy #barcnt
		bne m0
		lda #0
		sta tsinpos
m0		inc abar
		ldx abar
		cpx #barnum
		jne loop
		rts
.endl

scroll_2	.local
		mwa scrollptr tscrollptr
		//dec sinpos
		lda sinpos
		bpl q1
		mva #30 sinpos		
q1		mva sinpos tsinpos
		mva #0 abar
		
loop	ldy abar
		lda (tscrollptr),y
		asl
		tax
		lda bars,x
		sta tmp1
		lda bars+1,x
		sta tmp1+1
		lda tsinpos
		asl
		tay
		lda (tmp1),y
		sta tmp2
		iny
		lda (tmp1),y
		sta tmp2+1
		ldy #0
		ldx abar
.rept letterline #*vlinelen
		lda (tmp2),y+
		sta vram02+:1,x
.endr
		inc tsinpos
		ldy tsinpos
		cpy #barcnt
		bne m0
		lda #0
		sta tsinpos
m0		inc abar
		ldx abar
		cpx #barnum
		jne loop
		rts
.endl

////////////////////////////////////////////////////////////////

scroll_text
		:43 dta b(0)
		dta b( 1, 2, 2, 3, 4, 4, 4, 1, 2, 5, 6, 0, 7, 1, 2, 8, 9, 9, 9, 2, 2, 10, 11, 0, 12, 4, 4, 4, 1, 2, 2, 3, 4, 4, 4, 13, 0, 1, 2, 2, 14, 15, 15, 15, 1, 2, 2, 16, 0, 0, 1, 2, 2, 16, 0, 0, 1, 2, 2, 3, 4, 4, 4, 1, 2, 5, 6, 0, 0, 7, 1, 2, 8, 9, 9, 9, 17, 17, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 14, 15, 15, 15, 1, 2, 2, 16, 0, 0, 20, 2, 2, 21, 22, 22, 22, 1, 2, 5, 6, 0, 0, 1, 2, 2, 21, 22, 22, 22, 23, 23, 24, 25, 0, 0, 1, 2, 2, 21, 22, 22, 22, 23, 23, 24, 25, 0, 0, 1, 2, 2, 26, 27, 27, 27, 27, 27, 28, 0, 0, 1, 2, 2, 3, 4, 4, 4, 1, 2, 5, 6, 0, 0, 29, 30, 31, 32, 27, 27, 27, 33, 33, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0, 34, 1, 2, 35, 36, 36, 36, 2, 2, 37, 38, 0, 0, 1, 2, 2, 3, 4, 4, 4, 1, 2, 5, 6, 0, 0, 1, 2, 2, 35, 36, 36, 36, 36, 39, 0, 1, 2, 2, 26, 27, 27, 27, 27, 27, 28, 0, 0, 29, 30, 31, 32, 27, 27, 27, 33, 33, 18, 19, 0, 0, 29, 30, 31, 32, 27, 27, 27, 33, 33, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0, 29, 30, 31, 32, 27, 27, 27, 33, 33, 18, 19, 0, 0, 7, 1, 2, 8, 9, 9, 9, 2, 2, 10, 11, 0, 0, 20, 2, 2, 3, 4, 1, 2, 2, 3, 4, 1, 2, 5, 6, 0, 0, 1, 2, 2, 26, 27, 27, 27, 27, 27, 28, 0, 12, 4, 4, 4, 1, 2, 2, 3, 4, 4, 4, 13, 0, 1, 2, 2, 14, 15, 15, 15, 1, 2, 2, 16, 0, 0, 1, 2, 2, 16, 0, 0, 1, 2, 2, 3, 4, 4, 4, 1, 2, 5, 6, 0, 0, 7, 1, 2, 8, 9, 9, 9, 17, 17, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0, 20, 2, 2, 3, 4, 1, 2, 2, 3, 4, 1, 2, 5, 6, 0, 0, 7, 1, 2, 8, 9, 9, 9, 2, 2, 10, 11, 0, 0, 34, 1, 2, 35, 36, 36, 36, 2, 2, 37, 38, 0, 0, 1, 2, 2, 26, 27, 27, 27, 27, 27, 28, 0, 0, 29, 31, 31, 32, 27, 27, 27, 33, 33, 18, 19,0)
scroll_end		
		:44 dta b(0)	
bars	dta a(bar_0, bar_1, bar_2, bar_3, bar_4, bar_5, bar_6, bar_7, bar_8, bar_9, bar_10,bar_11,bar_12,bar_13,bar_14)
		dta a(bar_15,bar_16,bar_17,bar_18,bar_19,bar_20,bar_21,bar_22,bar_23,bar_24,bar_25,bar_26,bar_27,bar_28,bar_29)
		dta a(bar_30,bar_31,bar_32,bar_33,bar_34,bar_35,bar_36,bar_37,bar_38,bar_39)
	icl 'data4\data_bars'

bar_0
.rept 31 # 0
	dta a(bar_:2_:1)
.endr

bar_1
.rept 31 # 1
	dta a(bar_:2_:1)
.endr

bar_2
.rept 31 # 2
	dta a(bar_:2_:1)
.endr

bar_3
.rept 31 # 3
	dta a(bar_:2_:1)
.endr

bar_4
.rept 31 # 4
	dta a(bar_:2_:1)
.endr

bar_5
.rept 31 # 5
	dta a(bar_:2_:1)
.endr

bar_6
.rept 31 # 6
	dta a(bar_:2_:1)
.endr

bar_7
.rept 31 # 7
	dta a(bar_:2_:1)
.endr

bar_8
.rept 31 # 8
	dta a(bar_:2_:1)
.endr

bar_9
.rept 31 # 9
	dta a(bar_:2_:1)
.endr

bar_10
.rept 31 # 10
	dta a(bar_:2_:1)
.endr

bar_11
.rept 31 # 11
	dta a(bar_:2_:1)
.endr

bar_12
.rept 31 # 12
	dta a(bar_:2_:1)
.endr

bar_13
.rept 31 # 13
	dta a(bar_:2_:1)
.endr

bar_14
.rept 31 # 14
	dta a(bar_:2_:1)
.endr

bar_15
.rept 31 # 15
	dta a(bar_:2_:1)
.endr

bar_16
.rept 31 # 16
	dta a(bar_:2_:1)
.endr

bar_17
.rept 31 # 17
	dta a(bar_:2_:1)
.endr

bar_18
.rept 31 # 18
	dta a(bar_:2_:1)
.endr

bar_19
.rept 31 # 19
	dta a(bar_:2_:1)
.endr

bar_20
.rept 31 # 20
	dta a(bar_:2_:1)
.endr

bar_21
.rept 31 # 21
	dta a(bar_:2_:1)
.endr

bar_22
.rept 31 # 22
	dta a(bar_:2_:1)
.endr

bar_23
.rept 31 # 23
	dta a(bar_:2_:1)
.endr

bar_24
.rept 31 # 24
	dta a(bar_:2_:1)
.endr

bar_25
.rept 31 # 25
	dta a(bar_:2_:1)
.endr

bar_26
.rept 31 # 26
	dta a(bar_:2_:1)
.endr

bar_27
.rept 31 # 27
	dta a(bar_:2_:1)
.endr

bar_28
.rept 31 # 28
	dta a(bar_:2_:1)
.endr

bar_29
.rept 31 # 29
	dta a(bar_:2_:1)
.endr

bar_30
.rept 31 # 30
	dta a(bar_:2_:1)
.endr

bar_31
.rept 31 # 31
	dta a(bar_:2_:1)
.endr

bar_32
.rept 31 # 32
	dta a(bar_:2_:1)
.endr

bar_33
.rept 31 # 33
	dta a(bar_:2_:1)
.endr

bar_34
.rept 31 # 34
	dta a(bar_:2_:1)
.endr

bar_35
.rept 31 # 35
	dta a(bar_:2_:1)
.endr

bar_36
.rept 31 # 36
	dta a(bar_:2_:1)
.endr

bar_37
.rept 31 # 37
	dta a(bar_:2_:1)
.endr

bar_38
.rept 31 # 38
	dta a(bar_:2_:1)
.endr

bar_39
.rept 31 # 39
	dta a(bar_:2_:1)
.endr

end_bars


////////////////////////////////////////////////////////////////
.align $400
fnt_addr	ins 'data4\data_fonts'
fnt_end

end_part
.if PPD = 1
		run RUN_ADDRESS
.endif