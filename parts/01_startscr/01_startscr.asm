PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000
RUN_ADDRESS		equ	main

zpSin equ first_free_zp

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

	utils_wait_one_frame
	utils_wait_end_frame
	utils_wait_x_frame

dl_p01
		:+1	dta b($ce),a(p01_00+000)
		:+1	dta b($4e),a(p01_00+040)
		:+1	dta b($4e),a(p01_00+080)
		:+1	dta b($4e),a(p01_00+120)
		:+1	dta b($4e),a(p01_00+160)
		:+1	dta b($4e),a(p01_00+200)
		:+1	dta b($4e),a(p01_00+240)
		:+1	dta b($ce),a(p01_00+280)	
.rept 11 (#+1)*40*8
		:+1	dta b($4e),a(p01_00+:1+000)
		:+1	dta b($4e),a(p01_00+:1+040)
		:+1	dta b($4e),a(p01_00+:1+080)
		:+1	dta b($4e),a(p01_00+:1+120)
		:+1	dta b($4e),a(p01_00+:1+160)
		:+1	dta b($4e),a(p01_00+:1+200)
		:+1	dta b($4e),a(p01_00+:1+240)
		:+1	dta b($ce),a(p01_00+:1+280)										
.endr

.rept 12 #*40*8
		:+1	dta b($4e),a(p01_01+:1+000)
		:+1	dta b($4e),a(p01_01+:1+040)
		:+1	dta b($4e),a(p01_01+:1+080)
		:+1	dta b($4e),a(p01_01+:1+120)
		:+1	dta b($4e),a(p01_01+:1+160)
		:+1	dta b($4e),a(p01_01+:1+200)
		:+1	dta b($4e),a(p01_01+:1+240)
		:+1	dta b($ce),a(p01_01+:1+280)										
.endr

.rept 5 #*40*8
		:+1	dta b($4e),a(p01_02+:1+000)
		:+1	dta b($4e),a(p01_02+:1+040)
		:+1	dta b($4e),a(p01_02+:1+080)
		:+1	dta b($4e),a(p01_02+:1+120)
		:+1	dta b($4e),a(p01_02+:1+160)
		:+1	dta b($4e),a(p01_02+:1+200)
		:+1	dta b($4e),a(p01_02+:1+240)
		:+1	dta b($ce),a(p01_02+:1+280)										
.endr
		:+1	dta b($4e),a(p01_02+1600+000)
		:+1	dta b($4e),a(p01_02+1600+040)
		:+1	dta b($4e),a(p01_02+1600+080)
		:+1	dta b($4e),a(p01_02+1600+120)
		:+1	dta b($4e),a(p01_02+1600+160)
		:+1	dta b($4e),a(p01_02+1600+200)
		:+1	dta b($4e),a(p01_02+1600+240)
		:+1	dta b($4e),a(p01_02+1600+280)	
dl_p01_end
		:1	dta b($41),a(dl_p01)



main	.local

.if PGENE = 1
	jsr rom_off
.else
	lda #<RMTPLAY
	ldx #>RMTPLAY
	jsr OS_SET_PLAYER
.endif	
	jsr wait_one_frame
	mwa #0 frmcnt
	mva #$62 colbak
	sta colpf0
	sta colpf1
	sta colpf2
	jsr fade_in
	mwa #dl_p01 dlptr
	set_vbl vblk_first
	mva #$C0 nmien
	mva #34 dmactl

//synchro
.if PGENE = 1
	lda #128
	jsr wait_x_frame
.else
sh0	cpw frmcnt #(32*6)
	bne sh0
.endif
	restore_nmi

///////////////////////////////
// show screen 1
	jsr wait_one_frame
	mva #>pmg1 pmbase
	mva #$03 pmcntl
	lda >fnt1+$400*$00
	sta chbase
	mwa #ant1 dlptr
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl
	set_vbl vblk1
	set_dli dli_start1.dli2

//synchro
.if PGENE = 1
	lda #128
	jsr wait_x_frame
.else
sh1	cpw frmcnt #(48*6)
	bne sh1
.endif
	jsr wait_end_frame

	mva #>pmg2 pmbase
	lda >fnt2+$400*$00
	sta chbase
	mwa #ant2 dlptr
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl
	set_vbl vblk2
	set_dli dli_start2.dli2

//synchro
.if PGENE = 1
	lda #128
	jsr wait_x_frame
.else
sh2	cpw frmcnt #(72*6)
	bne sh2
.endif
	
	lda #0
	sta syndrom_fade_in_col2+1
	lda #17
	jsr wait_x_frame
	lda #0
	sta fade_out_col2+1
	lda #20
	jsr wait_x_frame
	
.if PGENE = 0	
	lda #<out_part
	ldy #>out_part
	jsr OS_DECRUNCH
	jmp $400	
.else
	jmp *
.endif
 
.endl

vblk_first	.local
	sta regA
	stx regX
	sty regY
	mwa #dl_p01 dlptr
	lda #28
	sta dli_first_1.dr0+1
	jsr fade_in
	
	set_turbo_dli dli_first	
l0_0	lda #0
l0_1	ldx #0
l0_2	ldy #0
	sta colpf0
	stx colpf1
	sty colpf2	
	lda regA
	ldx regX
	ldy regY
	rti
.endl


l0_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$74,$74)
l1_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$62,$74)
l2_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$74,$74)
l3_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$62,$74)
l4_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$74,$74)
l5_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$62,$74)
l6_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$74,$74)
l7_col0 dta b($62,$62,$62,$62,$62,$62,$62,$62,$62,$74)
                                                  
l0_col1 dta b($62,$62,$62,$62,$62,$74,$74,$86,$86,$86)
l1_col1 dta b($62,$62,$62,$62,$62,$62,$74,$74,$86,$86)
l2_col1 dta b($62,$62,$62,$62,$62,$74,$74,$74,$86,$86)
l3_col1 dta b($62,$62,$62,$62,$62,$62,$74,$74,$86,$86)
l4_col1 dta b($62,$62,$62,$62,$62,$74,$74,$86,$86,$86)
l5_col1 dta b($62,$62,$62,$62,$62,$62,$74,$74,$86,$86)
l6_col1 dta b($62,$62,$62,$62,$62,$74,$74,$74,$86,$86)
l7_col1 dta b($62,$62,$62,$62,$62,$62,$74,$74,$86,$86)
                                                  
l0_col2 dta b($62,$74,$74,$74,$86,$86,$98,$98,$98,$98)
l1_col2 dta b($62,$62,$62,$74,$74,$86,$86,$86,$98,$98)
l2_col2 dta b($62,$62,$74,$74,$74,$86,$86,$98,$98,$98)
l3_col2 dta b($62,$62,$62,$74,$74,$86,$86,$86,$98,$98)
l4_col2 dta b($62,$74,$74,$74,$86,$86,$98,$98,$98,$98)
l5_col2 dta b($62,$62,$62,$74,$74,$86,$86,$86,$98,$98)
l6_col2 dta b($62,$62,$74,$74,$74,$86,$86,$98,$98,$98)
l7_col2 dta b($62,$62,$62,$74,$74,$86,$86,$86,$98,$98)

fade_in	.local
c1	ldx #0
	beq c0
	dec c1+1
	rts
c0	ldx #0
	mva #5 c1+1
	lda l0_col0,x
	sta vblk_first.l0_0+1
	sta dli_first_1.l0_0+1
	lda l1_col0,x
	sta dli_first.l1_0+1		
	sta dli_first_1.l1_0+1
	lda l2_col0,x
	sta dli_first.l2_0+1		
	sta dli_first_1.l2_0+1
	lda l3_col0,x
	sta dli_first.l3_0+1		
	sta dli_first_1.l3_0+1
	lda l4_col0,x
	sta dli_first.l4_0+1		
	sta dli_first_1.l4_0+1
	lda l5_col0,x
	sta dli_first.l5_0+1		
	sta dli_first_1.l5_0+1
	lda l6_col0,x
	sta dli_first.l6_0+1		
	sta dli_first_1.l6_0+1
	lda l7_col0,x
	sta dli_first.l7_0+1		
	sta dli_first_1.l7_0+1
	
	lda l0_col1,x
	sta vblk_first.l0_1+1
	sta dli_first_1.l0_1+1
	lda l1_col1,x
	sta dli_first.l1_1+1		
	sta dli_first_1.l1_1+1
	lda l2_col1,x
	sta dli_first.l2_1+1		
	sta dli_first_1.l2_1+1
	lda l3_col1,x
	sta dli_first.l3_1+1		
	sta dli_first_1.l3_1+1
	lda l4_col1,x
	sta dli_first.l4_1+1		
	sta dli_first_1.l4_1+1
	lda l5_col1,x
	sta dli_first.l5_1+1		
	sta dli_first_1.l5_1+1
	lda l6_col1,x
	sta dli_first.l6_1+1		
	sta dli_first_1.l6_1+1
	lda l7_col1,x
	sta dli_first.l7_1+1		
	sta dli_first_1.l7_1+1
	
	lda l0_col2,x
	sta vblk_first.l0_2+1
	sta dli_first_1.l0_2+1
	lda l1_col2,x
	sta dli_first.l1_2+1		
	sta dli_first_1.l1_2+1
	lda l2_col2,x
	sta dli_first.l2_2+1		
	sta dli_first_1.l2_2+1
	lda l3_col2,x
	sta dli_first.l3_2+1		
	sta dli_first_1.l3_2+1
	lda l4_col2,x
	sta dli_first.l4_2+1		
	sta dli_first_1.l4_2+1
	lda l5_col2,x
	sta dli_first.l5_2+1		
	sta dli_first_1.l5_2+1
	lda l6_col2,x
	sta dli_first.l6_2+1		
	sta dli_first_1.l6_2+1
	lda l7_col2,x
	sta dli_first.l7_2+1		
	sta dli_first_1.l7_2+1
	inx
	cpx #10
	beq e0
	inc c0+1
e0	rts
.endl

.align $100
dli_first	.local
	sta regA
	stx regX
	sty regY
l1_0	lda #0
l1_1	ldx #0
l1_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l2_0	lda #0
l2_1	ldx #0
l2_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l3_0	lda #0
l3_1	ldx #0
l3_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l4_0	lda #0
l4_1	ldx #0
l4_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l5_0	lda #0
l5_1	ldx #0
l5_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l6_0	lda #0
l6_1	ldx #0
l6_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l7_0	lda #0
l7_1	ldx #0
l7_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
	set_turbo_dli_lo <dli_first_1
	lda regA
	ldx regX
	ldy regY
	rti
.endl

dli_first_1	.local
	sta regA
	stx regX
	sty regY
l0_0	lda #00
l0_1	ldx #00
l0_2	ldy #00
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2	
l1_0	lda #00
l1_1	ldx #00
l1_2	ldy #00
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l2_0	lda #0
l2_1	ldx #0
l2_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l3_0	lda #0
l3_1	ldx #0
l3_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l4_0	lda #0
l4_1	ldx #0
l4_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l5_0	lda #0
l5_1	ldx #0
l5_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l6_0	lda #0
l6_1	ldx #0
l6_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
l7_0	lda #0
l7_1	ldx #0
l7_2	ldy #0
	sta wsync
	sta colpf0
	stx colpf1
	sty colpf2
dr0	ldx #28
	bne g0
	restore_normal_nmi
g0	dec dr0+1
	lda regA
	ldx regX
	ldy regY
	rti
.endl



vblk1	.local
	sta regA
	stx regX
	sty regY
	mwa #ant1 dlptr
	lda >fnt1+$400*$00
	sta chbase
c0	lda #$62
	sta colbak
c1	lda #$74
	sta color0
c2	lda #$86
	sta color1
c3	lda #$98
	sta color2
c4	lda #$1E
	sta color3
	lda #$02
	sta chrctl
	sta gtictl
s0	lda #$03
	sta sizep2
x0	lda #$84
	sta hposp2
c5	lda #$2C
	sta colpm2
s1	lda #$03
	sta sizep3
s2	lda #$C0
	sta sizem
x1	lda #$5C
	sta hposp3
x2	lda #$7C
	sta hposm3
c6	lda #$2C
	sta colpm3
x3	lda #$00
	sta hposp0
	sta hposp1
	sta hposm0
	sta hposm1
	sta hposm2
	sta sizep0
	sta sizep1
	sta colpm0
	sta colpm1
	lda regA
	ldx regX
	ldy regY
	rti	
.endl
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

col_tab2_l dta l(vblk2.c1+1,vblk2.c2+1,vblk2.c3+1,vblk2.c4+1,dli_start2.c21+1,dli_start2.c22+1,dli_start2.c23+1,dli_start2.c24+1)
col_tab2_h dta h(vblk2.c1+1,vblk2.c2+1,vblk2.c3+1,vblk2.c4+1,dli_start2.c21+1,dli_start2.c22+1,dli_start2.c23+1,dli_start2.c24+1)


syndrom_fade_in_col2 .local
	lda #1
	beq r
	rts
r	
	lda dli_start2.c21+1
	cmp #$ff
	beq c0
	clc
	adc #$11
	bne s0
c0	lda #15
s0	sta dli_start2.c21+1
	lda dli_start2.c23+1
	cmp #$ff
	beq c1
	clc
	adc #$11
	bne s1
c1	lda #15
	sta syndrom_fade_in_col2+1
s1	sta dli_start2.c23+1	
	rts
.endl

fade_out_col2	.local
	lda #1
	beq r
	rts
r	ldx #0
r0	lda col_tab2_l,x
	sta l0+1
	sta s2+1
	lda col_tab2_h,x
	sta l0+2
	sta s2+2
l0	lda $1000
	tay
	and #$0f
	cmp #2
	bne n0
	sta s0+1
	beq n1
n0	sec
	sbc #1
	sta s0+1
n1	tya
	and #$f0
	cmp #$60
	bne nn0
	sta s1+1
	beq nn1
nn0	sec
	sbc #$10
	sta s1+1
nn1	
s0	lda #0
s1	ora #0
s2	sta $1000
	inx
	cpx #(col_tab2_h-col_tab2_l)
	bne r0
	rts
.endl

vblk2	.local
	sta regA
	stx regX
	sty regY
	jsr syndrom_fade_in_col2
	jsr fade_out_col2
	mwa #ant2 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl	;set new screen width
	lda >fnt2+$400*$00
	sta chbase
c0	lda #$62
	sta colbak
c1	lda #$74
	sta color0
c2	lda #$86
	sta color1
c3	lda #$98
	sta color2
c4	lda #$1E
	sta color3
	lda #$02
	sta chrctl
	sta gtictl
s0	lda #$03
	sta sizep2
x0	lda #$84
	sta hposp2
c5	lda #$2C
	sta colpm2
s1	lda #$03
	sta sizep3
s2	lda #$C0
	sta sizem
x1	lda #$5C
	sta hposp3
x2	lda #$7C
	sta hposm3
c6	lda #$2C
	sta colpm3
x3	lda #$00
	sta hposp0
	sta hposp1
	sta hposm0
	sta hposm1
	sta hposm2
	sta sizep0
	sta sizep1
	sta colpm0
	sta colpm1
	lda regA
	ldx regX
	ldy regY
	rti
.endl

dli_start1 .local

dli2
	sta regA
	lda >fnt1+$400*$01
	sta wsync		;line=32
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt1+$400*$02
	sta wsync		;line=56
	sta chbase
	set_dli dli13
	lda regA
	rti

dli13
	sta regA

c7	lda #$1E
	sta wsync		;line=64
	sta colpm2
	sta colpm3
c8	lda #$2C
	sta wsync		;line=65
	sta colpm2
	sta colpm3
	sta wsync		;line=66
c9	lda #$1E
	sta wsync		;line=67
	sta colpm2
	sta colpm3
c10	lda #$2C
	sta wsync		;line=68
	sta colpm2
	sta colpm3
c11	lda #$1E
	sta wsync		;line=69
	sta colpm2
	sta colpm3
	sta wsync		;line=70
c12	lda #$2C
	sta wsync		;line=71
	sta colpm2
	sta colpm3
c13	lda #$1E
	sta wsync		;line=72
	sta colpm2
	sta colpm3
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt1+$400*$03
	sta wsync		;line=80
	sta chbase
	sta wsync		;line=81
	sta wsync		;line=82
	sta wsync		;line=83
	sta wsync		;line=84
c14	lda #$2C
	sta wsync		;line=85
	sta colpm2
	sta colpm3
c15	lda #$1E
	sta wsync		;line=86
	sta colpm2
	sta colpm3
	sta wsync		;line=87
c16	lda #$2C
	sta wsync		;line=88
	sta colpm2
	sta colpm3
c17	lda #$1E
	sta wsync		;line=89
	sta colpm2
	sta colpm3
c18	lda #$2C
	sta wsync		;line=90
	sta colpm2
	sta colpm3
c19	lda #$1E
	sta wsync		;line=91
	sta colpm2
	sta colpm3
c20	lda #$2C
	sta wsync		;line=92
	sta colpm2
	sta colpm3
	set_dli dli5
	lda regA
	rti

dli5
	sta regA
	lda >fnt1+$400*$04
	sta wsync		;line=104
	sta chbase
	set_dli dli6
	lda regA
	rti

dli6
	sta regA
	lda >fnt1+$400*$05
	sta wsync		;line=128
	sta chbase
c21	lda #$02
	sta wsync		;line=129
	sta color3
	set_dli dli7
	lda regA
	rti

dli7
	sta regA
	stx regX
	lda >fnt1+$400*$06
c22	ldx #$1E
	sta wsync		;line=152
	sta chbase
	stx color3
	set_dli dli8
	lda regA
	ldx regX
	rti

dli8
	sta regA
	lda >fnt1+$400*$07
	sta wsync		;line=176
	sta chbase
	set_dli dli9
	lda regA
	rti

dli9
	sta regA
	lda >fnt1+$400*$08
	sta wsync		;line=200
	sta chbase
	set_dli dli10
	lda regA
	rti

dli10
	sta regA
	lda >fnt1+$400*$00
	sta wsync		;line=224
	sta chbase
	set_dli dli2
	lda regA
	rti
.endl


dli_start2 .local

dli2
	sta regA
	lda >fnt2+$400*$01
	sta wsync		;line=32
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt2+$400*$02
	sta wsync		;line=56
	sta chbase
	set_dli dli13
	lda regA
	rti

dli13
	sta regA

c7	lda #$1E
	sta wsync		;line=64
	sta colpm2
	sta colpm3
c8	lda #$2C
	sta wsync		;line=65
	sta colpm2
	sta colpm3
	sta wsync		;line=66
c9	lda #$1E
	sta wsync		;line=67
	sta colpm2
	sta colpm3
c10	lda #$2C
	sta wsync		;line=68
	sta colpm2
	sta colpm3
c11	lda #$1E
	sta wsync		;line=69
	sta colpm2
	sta colpm3
	sta wsync		;line=70
c12	lda #$2C
	sta wsync		;line=71
	sta colpm2
	sta colpm3
c13	lda #$1E
	sta wsync		;line=72
	sta colpm2
	sta colpm3
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt2+$400*$03
	sta wsync		;line=80
	sta chbase
	sta wsync		;line=81
	sta wsync		;line=82
	sta wsync		;line=83
	sta wsync		;line=84
c14	lda #$2C
	sta wsync		;line=85
	sta colpm2
	sta colpm3
c15	lda #$1E
	sta wsync		;line=86
	sta colpm2
	sta colpm3
	sta wsync		;line=87
c16	lda #$2C
	sta wsync		;line=88
	sta colpm2
	sta colpm3
c17	lda #$1E
	sta wsync		;line=89
	sta colpm2
	sta colpm3
c18	lda #$2C
	sta wsync		;line=90
	sta colpm2
	sta colpm3
c19	lda #$1E
	sta wsync		;line=91
	sta colpm2
	sta colpm3
c20	lda #$2C
	sta wsync		;line=92
	sta colpm2
	sta colpm3
	set_dli dli5
	lda regA
	rti

dli5
	sta regA
	lda >fnt2+$400*$04
	sta wsync		;line=104
	sta chbase
	set_dli dli14
	lda regA
	rti

dli14
	sta regA
	stx regX

	sta wsync		;line=112
	sta wsync		;line=113
	sta wsync		;line=114
	sta wsync		;line=115
	sta wsync		;line=116
	sta wsync		;line=117
	sta wsync		;line=118
x4	lda #$7A
c21	ldx #$00
	sta wsync		;line=119
	sta hposm3
	stx colpm3
	set_dli dli6
	lda regA
	ldx regX
	rti

dli6
	sta regA
	stx regX
	sty regY
	lda >fnt2+$400*$05
	sta wsync		;line=128
	sta chbase
c22	lda #$02
	sta wsync		;line=129
	sta color3
	sta wsync		;line=130
x5	lda #$82
x6	ldx #$5A
c23	ldy #$00
	sta wsync		;line=131
	sta hposp2
	stx hposp3
	sty colpm2
	set_dli dli7
	lda regA
	ldx regX
	ldy regY
	rti

dli7
	sta regA
	stx regX
	lda >fnt2+$400*$06
c24	ldx #$1E
	sta wsync		;line=152
	sta chbase
	stx color3
	set_dli dli8
	lda regA
	ldx regX
	rti

dli8
	sta regA
	lda >fnt2+$400*$07
	sta wsync		;line=176
	sta chbase
	set_dli dli9
	lda regA
	rti

dli9
	sta regA
	lda >fnt2+$400*$08
	sta wsync		;line=200
	sta chbase
	set_dli dli10
	lda regA
	rti

dli10
	sta regA
	lda >fnt2+$400*$00
	sta wsync		;line=224
	sta chbase
	set_dli dli2
	lda regA
	rti

.endl


///////////////////////////////////////////////////////////////////////////////
ant1	dta $44,a(scr1)
	dta $04,$04,$84,$04,$04,$84,$84,$04,$84,$04,$04,$84,$04,$04,$84,$04
	dta $04,$84,$04,$04,$84,$04,$04,$84,$04,$04,$84,$04,$04
	dta $41,a(ant1)

.align $1000
scr1	ins "data\napis 1.scr"
scr1_e
scr2	ins "data\napisy 2.scr"
scr2_e
ant2	dta $44,a(scr2)
	dta $04,$04,$84,$04,$04,$84,$84,$04,$84,$04,$04,$84,$84,$04,$84,$04
	dta $04,$84,$04,$04,$84,$04,$04,$84,$04,$04,$84,$04,$04
	dta $41,a(ant2)
///////////////////////////////////////////////////////////////////////////////

.align $400 	
fnt1	ins "data\napis 1.fnt"
fnt1_end
fnt2	ins "data\napisy 2.fnt"
fnt2_end
////////////////////////////////////////////////////////////////////////////////

.align $1000
p01_00 
	ins 'data\p-01_0',0,4080-240
.align $1000
p01_01 
	ins 'data\p-01_0',4080-240,240
	ins 'data\p-01_1',0,4080-240-240
.align $1000
p01_02
	ins 'data\p-01_1',4080-240-240
	ins 'data\p-01_2'
end_first_scr

/////////////////////////////////////////////////////////////////////////////	
	

.align $800
pmg1	SPRITES1
pmg2	SPRITES2

.MACRO	SPRITES1
	:$300 dta b(0)
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.ds $100
player1
	.ds $100
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 F7 F7 F7 F7 F7 F7 F7 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 FE FE FE FE FF
	.he 7F 7F 7F 7F 7F 7F 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he BF BF BF BF BF 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO	SPRITES2
	:$300 dta b(0)
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 00 00 00 00 00 00 00 00 00 00 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.ds $100
player1
	.ds $100
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 F7 F7 F7 F7 F7 F7 F7 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6
	.he F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 F6 FE FE FE FE FF
	.he 7F 7F 7F 7F 7F 7F 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he BF BF BF BF BF 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

///////////////////////////////////////////////////////////
out_part ins '01_startscr_out.obx.bc'
	
end_part_startscr_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	
