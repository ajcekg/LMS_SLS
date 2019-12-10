PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000
RUN_ADDRESS		equ	main

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

fcnt	equ first_free_zp
fadr	equ first_free_zp+2


.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

dl01	.local
	:5	 dta b($60)
	:1 	 dta b($4e),a(up1)
	:101 dta b($0e)
	:1	 dta b($4e),a(up2)
	:1	 dta b($0e)
	dta b($41),a(dl01)
.endl

dl02	.local
	:5	 dta b($60)
	:1 	 dta b($4e),a(updown1)
	:101 dta b($0e)
	:1	 dta b($4e),a(updown2)
	:69	 dta b($0e)
	dta b($41),a(dl02)
.endl

ant	dta $44,a(scr)
	dta $04,$84,$04,$84,$84,$04,$84,$04,$84,$04,$04,$84,$04,$04,$84,$84
	dta $04,$04,$84,$84,$84,$84,$84,$04,$84,$04,$84,$04,$04
	dta $41,a(ant)

scr	ins "data\endworksyndrom.scr"
end_scr
	utils_wait_one_frame
	utils_wait_x_frame

main	.local

.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
w0	cpw frmcnt #(14*64*6)-(32*6)-(48*6)+22
	bne w0

.endif
	restore_nmi
	jsr wait_one_frame
	lda #0
	sta colpf0
	sta colpf1
	sta colpf2
	sta colbak
	lda #%10000
	sta gtictl
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	mwa #dl01 dlptr

	jsr fade_to_up
	lda #8
	jsr wait_x_frame
	jsr fade_to_down

.if PGENE = 0
w1	cpw frmcnt #(14*64*6)-(32*6)-(48*6)+(16*6)
	bne w1
.else
	lda #100
	jsr wait_x_frame
.endif
	
	jsr fade_to_up2
	mwa #dl02 dlptr
	lda #8
	jsr wait_x_frame	
	jsr fade_to_down2
		
.if PGENE = 0
w2	cpw frmcnt #(14*64*6)-(32*6)-(48*6)+(32*6)
	bne w2
.else
	lda #100
	jsr wait_x_frame	
.endif

	jsr fade_to_up2
	lda #8
	jsr wait_x_frame


//full color
qqq	jsr save_color
	jsr wait_one_frame
	mva >pmg pmbase
	mva #$03 pmcntl
	set_vbl vblk

// ile jest na ekranie 1 - tu mo¿na zmieniæ by dostosowaæ kolejny part
l0	lda #180
	beq l0b1
	jsr wait_one_frame
	jsr fade_in
	dec l0+1
	jmp l0

l0b1
	jsr fade_flash_in
	jsr wait_one_frame

l0f lda #16
	beq ll0
	jsr wait_one_frame
	jsr wait_one_frame
	jsr fade_flash_out
	dec l0f+1
	jmp l0f
ll0
	lda #60
	jsr wait_x_frame
	
	jsr fade_flash_in
	jsr wait_one_frame	

l5f lda #16
	beq l0b
	jsr wait_one_frame
	jsr wait_one_frame
	jsr fade_flash_out
	dec l5f+1
	jmp l5f

// ile jest na ekranie 2 - tu mo¿na zmieniæ by dostosowaæ kolejny part
l0b lda #90
    beq l1
    jsr wait_one_frame
    dec l0b+1
    jmp l0b
	
l1	lda #16
	beq l2
	jsr wait_one_frame
	jsr fade_to_0
	dec l1+1
	jmp l1
	
l2	
.if PGENE = 0
	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif

.endl
////////////////////////////////////////////////////////////////////////
.local	save_color
		mwa #tcol fcnt
loop	ldy	#0
		lda	(fcnt),y
		sta	fadr
		iny
		lda	(fcnt),y
		bne *+3
		rts
		sta fadr+1
		lda	(fadr),y
		iny
		sta	(fcnt),y
		dey
		mva	#15	(fadr),y
		adw	fcnt #3
		jmp	loop
.end

.local fade_to_0
		mwa #tcol fcnt
loop	ldy #0
		lda	(fcnt),y
		sta	fadr
		iny
		lda	(fcnt),y
		bne *+3
		rts
		sta fadr+1
		lda	(fadr),y
		beq next
		tax
		
		and #$0f
		beq n0
		sec
		sbc #1
n0		sta l0+1
		txa
		and #$f0
		beq l0
		sec
		sbc #$10

l0		ora #0		
		sta	(fadr),y
next	adw	fcnt #3		
		jmp loop		
.endl

.local fade_in
		mwa #tcol fcnt
loop	ldy #0
		lda	(fcnt),y
		sta	fadr
		iny
		lda	(fcnt),y
		bne *+3
		rts
		sta fadr+1
		lda	(fadr),y
		iny
		tax
		eor (fcnt),y
		beq next
		lda (fcnt),y
		and #$0f
		sta l0+1
		lda (fcnt),y
		and #$f0
		sta l1+1
		dey
		txa

		and #$0f
l0		cmp #0
		beq n0
		sec
		sbc #1
n0		sta n1+1

		txa
		and #$f0
l1		cmp #0
		beq n1
		sec
		sbc #$10

n1		ora #0
		sta	(fadr),y
next	adw	fcnt #3		
		jmp loop		
.endl

.local fade_flash_in
		mwa #tcol fcnt
loop	ldy #0
		lda	(fcnt),y
		sta	fadr
		iny
		lda	(fcnt),y
		bne *+3
		rts
		sta fadr+1
		lda	(fadr),y
		beq next
		cmp #$b4
		beq next
		lda #15
		sta (fadr),y
next	adw	fcnt #3		
		jmp loop		
.endl

.local fade_flash_out
		mwa #tcol fcnt
loop	ldy #0
		lda	(fcnt),y
		sta	fadr
		iny
		lda	(fcnt),y
		bne *+3
		rts
		sta fadr+1
		iny
		lda (fcnt),y
		dey
		cmp #$b4
		beq next		
		lda	(fadr),y
		beq next
		iny
		tax
		eor (fcnt),y
		beq next
		lda (fcnt),y
		and #$0f
		sta l0+1
		lda (fcnt),y
		and #$f0
		sta l1+1
		dey
		txa

		and #$0f
l0		cmp #0
		beq n0
		sec
		sbc #1
n0		sta n1+1

		txa
		and #$f0
l1		cmp #0
		beq n1
		sec
		sbc #$10

n1		ora #0
		sta	(fadr),y
next	adw	fcnt #3		
		jmp loop		
.endl


tcol
.rept 9 #
	dta t(vblk.c:1)
.endr
.rept 76-9 #+9
	dta t(dli_start.c:1)
.endr
	dta t(0)
tcolend


vblk	.local 
	phr
	mwa #ant dlptr
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl
	lda >fnt+$400*$00
	sta chbase
c0	lda #$00		//00
	sta colbak
c1	lda #$04
	sta color0
c2	lda #$b4		//B4
	sta color1
c3	lda #$0C
	sta color2
c4	lda #$44
	sta color3
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
s0	lda #$03
	sta sizep1
x0	lda #$2C
	sta hposp1
c5	lda #$b4		//B4
	sta colpm1
s1	lda #$03
	sta sizep0
x1	lda #$B0
	sta hposp0
c6	lda #$b4		//B4
	sta colpm0
s2	lda #$01
	sta sizep3
x2	lda #$AA
	sta hposp3
c7	lda #$36
	sta colpm3
s3	lda #$01
	sta sizep2
x3	lda #$69
	sta hposp2
c8	lda #$2C
	sta colpm2
x4	lda #$BE
	sta hposm0
x5	lda #$00
	sta hposm1
	sta hposm2
	sta hposm3
	sta sizem
	set_dli dli_start.dli11
	plr
	rti
.endl
dli_start .local

dli11
	sta regA

	sta wsync		;line=24
	sta wsync		;line=25
	sta wsync		;line=26
	sta wsync		;line=27
c9	lda #$0E
	sta wsync		;line=28
	sta color2
c10	lda #$0C
	sta wsync		;line=29
	sta color2
c11	lda #$0E
	sta wsync		;line=30
	sta color2
c12	lda #$0C
	sta wsync		;line=31
	sta color2
c13	lda #$0E
	sta wsync		;line=32
	sta color2
c14	lda #$88
	sta wsync		;line=33
	sta color1
	set_dli dli_start.dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=40
	sta chbase
	set_dli dli_start.dli12
	lda regA
	rti

dli12
	sta regA
	stx regX

	sta wsync		;line=48
	sta wsync		;line=49
	sta wsync		;line=50
	sta wsync		;line=51
x6	lda #$93
c15	ldx #$FC
	sta wsync		;line=52
	sta hposp3
	stx colpm3
s4	lda #$00
	sta wsync		;line=53
	sta sizep3
	set_dli dli_start.dli3
	lda regA
	ldx regX
	rti

dli3
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=64
	sta chbase
	set_dli dli_start.dli13
	lda regA
	rti

dli13
	sta regA

	sta wsync		;line=80
	sta wsync		;line=81
	sta wsync		;line=82
	sta wsync		;line=83
c16	lda #$12
	sta wsync		;line=84
	sta color0
c17	lda #$04
	sta wsync		;line=85
	sta color0
c18	lda #$12
	sta wsync		;line=86
	sta color0
c19	lda #$98
	sta wsync		;line=87
	sta color1
	lda >fnt+$400*$03
	sta wsync		;line=88
	sta chbase
c20	lda #$9E
	sta wsync		;line=89
	sta color2
c21	lda #$0E
	sta wsync		;line=90
	sta color2
c22	lda #$9E
	sta wsync		;line=91
	sta color2
c23	lda #$0E
	sta wsync		;line=92
	sta color2
c24	lda #$9E
	sta wsync		;line=93
	sta color2
c25	lda #$0E
	sta wsync		;line=94
	sta color2
c26	lda #$9E
	sta wsync		;line=95
	sta color2
c27	lda #$0E
	sta wsync		;line=96
	sta color2
c28	lda #$9E
	sta wsync		;line=97
	sta color2
	set_dli dli_start.dli14
	lda regA
	rti

dli14
	sta regA
	stx regX

	sta wsync		;line=104
	sta wsync		;line=105
	sta wsync		;line=106
	sta wsync		;line=107
	sta wsync		;line=108
c29	lda #$AC
	sta wsync		;line=109
	sta color2
c30	lda #$9E
	sta wsync		;line=110
	sta color2
c31	lda #$AC
	sta wsync		;line=111
	sta color2
	lda >fnt+$400*$04
c32	ldx #$9E
	sta wsync		;line=112
	sta chbase
	stx color2
c33	lda #$AC
	sta wsync		;line=113
	sta color2
	sta wsync		;line=114
	sta wsync		;line=115
c34	lda #$CC
	sta wsync		;line=116
	sta color2
c35	lda #$AC
	sta wsync		;line=117
	sta color2
c36	lda #$CC
	sta wsync		;line=118
	sta color2
c37	lda #$68
c38	ldx #$AC
	sta wsync		;line=119
	sta color1
	stx color2
c39	lda #$98
c40	ldx #$CC
	sta wsync		;line=120
	sta color1
	stx color2
c41	lda #$68
	sta wsync		;line=121
	sta color1
	sta wsync		;line=122
	sta wsync		;line=123
c42	lda #$1E
	sta wsync		;line=124
	sta color2
	set_dli dli_start.dli15
	lda regA
	ldx regX
	rti

dli15
	sta regA
	stx regX

	sta wsync		;line=128
c43	lda #$04
	sta wsync		;line=129
	sta color0
c44	lda #$12
	sta wsync		;line=130
	sta color0
c45	lda #$04
c46	ldx #$38
	sta wsync		;line=131
	sta color0
	stx color1
	set_dli dli_start.dli4
	lda regA
	ldx regX
	rti


dli4
	sta regA
	stx regX
	lda >fnt+$400*$05
	sta wsync		;line=136
	sta chbase
	sta wsync		;line=137
	sta wsync		;line=138
	sta wsync		;line=139
c47	lda #$12
	sta wsync		;line=140
	sta color0
c48	lda #$04
	sta wsync		;line=141
	sta color0
c49	lda #$12
	sta wsync		;line=142
	sta color0
	sta wsync		;line=143
c50	lda #$78
c51	ldx #$0E
	sta wsync		;line=144
	sta color1
	stx color2
c52	lda #$38
c53	ldx #$1E
	sta wsync		;line=145
	sta color1
	stx color2
c54	lda #$78
c55	ldx #$0E
	sta wsync		;line=146
	sta color1
	stx color2
c56	lda #$38
c57	ldx #$1E
	sta wsync		;line=147
	sta color1
	stx color2
c58	lda #$78
c59	ldx #$0E
	sta wsync		;line=148
	sta color1
	stx color2
	set_dli dli_start.dli5
	lda regA
	ldx regX
	rti


dli5
	sta regA
	stx regX
	lda >fnt+$400*$06
c60	ldx #$98
	sta wsync		;line=160
	sta chbase
	stx color1
	set_dli dli_start.dli16
	lda regA
	ldx regX
	rti


dli16
	sta regA

	sta wsync		;line=168
	sta wsync		;line=169
	sta wsync		;line=170
	sta wsync		;line=171
	sta wsync		;line=172
c61	lda #$A8
	sta wsync		;line=173
	sta color1
	set_dli dli_start.dli17
	lda regA
	rti


dli17
	sta regA

	sta wsync		;line=176
c62	lda #$04
	sta wsync		;line=177
	sta color0
c63	lda #$12
	sta wsync		;line=178
	sta color0
c64	lda #$04
	sta wsync		;line=179
	sta color0
	set_dli dli_start.dli6
	lda regA
	rti


dli6
	sta regA
	stx regX
	lda >fnt+$400*$07
c65	ldx #$EE
	sta wsync		;line=184
	sta chbase
	stx color2
c66	lda #$0E
	sta wsync		;line=185
	sta color2
c67	lda #$EE
	sta wsync		;line=186
	sta color2
c68	lda #$0E
	sta wsync		;line=187
	sta color2
c69	lda #$EE
	sta wsync		;line=188
	sta color2
	set_dli dli_start.dli18
	lda regA
	ldx regX
	rti


dli18
	sta regA

	sta wsync		;line=192
	sta wsync		;line=193
c70	lda #$EC
	sta wsync		;line=194
	sta color2
c71	lda #$EE
	sta wsync		;line=195
	sta color2
c72	lda #$EC
	sta wsync		;line=196
	sta color2
c73	lda #$EE
	sta wsync		;line=197
	sta color2
c74	lda #$EC
	sta wsync		;line=198
	sta color2
c75	lda #$b4		//B4
	sta wsync		;line=199
	sta color1
	set_dli dli_start.dli7
	lda regA
	rti


dli7
	sta regA
	lda >fnt+$400*$08
	sta wsync		;line=208
	sta chbase
	set_dli dli_start.dli8
	lda regA
	rti


dli8
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=224
	sta chbase

	lda regA
	rti

.endl



////////////////////////////////////////////////////////////////////////
fade_to_up	.local
	mva #0 l1+1
	ldx #15
l0	jsr wait_one_frame
l1	ldy #0
	sty colpf0
	sty colpf1
	sty colpf2
	inc l1+1
	dex
	bpl l0
	rts
.endl

fade_to_up2	.local
	adb t0+1 #$10
	adb t1+1 #$10
	adb t2+1 #$10		
	mva #0 l1+1
	ldx #15
l0	jsr wait_one_frame
l1	ldy #0
	cpy #15
	beq end
	sty colbak
	tya
t0	ora #$70
	tay
	sty colpf0
	tya
t1	ora #$80
	tay	
	sty colpf1
	tya
t2	ora #$90
	tay	
	sty colpf2
	inc l1+1
	dex
	bpl l0
	rts
end	sty colbak
	sty colpf0
	sty colpf1
	sty colpf2
	rts	
.endl

fade_to_down	.local
	mva #15 l1+1
	sta l2+1
	sta l3+1
	ldx #15
l0	jsr wait_one_frame
l1	ldy #15
	cpy #4
	beq s1
	dec l1+1
s1	tya
	ora #$60
	tay
	sty colpf0

l2	ldy #15
	cpy #8
	beq s2
	dec l2+1
s2	tya
	ora #$70
	tay
	sty colpf1

l3	ldy #15
	cpy #12
	beq s3
	dec l3+1
s3	tya
	ora #$80
	tay
	sty colpf2

	dex
	bpl l0
	rts	
.endl

fade_to_down2	.local
	mva #15 l1+1
	sta l2+1
	sta l3+1
	sta l4+1
	ldx #15
l0	jsr wait_one_frame

l1	ldy #15
	cpy #4
	beq s1
	dec l1+1
s1	tya
	ora #$80
	tay
	sty colpf0

l2	ldy #15
	cpy #8
	beq s2
	dec l2+1
s2	tya
	ora #$90
	tay	
	sty colpf1

l3	ldy #15
	cpy #12
	beq s3
	dec l3+1
s3	tya
	ora #$a0
	tay	
	sty colpf2

l4	ldy #15
	beq s4
	dec l4+1
s4	sty colbak

	dex
	bpl l0
	rts	
.endl


.align $1000
up1		ins 'data\up_cut_dta_0'
.align
up2		ins 'data\up_cut_dta_1'
updown2 ins 'data\updown_cut_dta_1'
.align $1000
updown1 ins 'data\updown_cut_dta_0'
.align $400
fnt	ins "data\endworksyndrom.fnt"

.ALIGN $0800
pmg	.ds $0300
	SPRITES

.MACRO	SPRITES
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 03 03 03 03 03 03
	.he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
	.he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
	.he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F
	.he 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F
	.he 2F 3F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 1F 1F
	.he 1F 1F 1F 1F 0F 1F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 1F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
	.he 1F 1F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 07 07 07 07
	.he 07 07 07 07 07 07 07 07 07 07 07 0F 07 07 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 7F 7F 7F 7F 7F 7F 7F 7F
	.he 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F
	.he 7F 7F 7F 7F 7F 7F 7F 7F 7F 7E 7F 7E 7F 7E 7E 7E
	.he 7E 7E 7E 7E 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C
	.he 7C 7C 7C 78 78 78 78 78 78 78 78 78 78 78 78 78
	.he 78 78 78 78 78 78 78 78 78 78 78 78 7C 7C 7C 7C
	.he 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C
	.he 7C 7C 78 78 78 78 78 78 78 78 79 79 79 79 78 78
	.he 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78
	.he 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78
	.he 78 78 78 78 78 7C 78 7C 7C 7C 7C 7C 7C 7C 7C 7C
	.he 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C 7C
	.he 7C 7C 7C 7C 7C 78 78 78 78 78 78 78 78 7C 7C 7C
	.he 7C 3C 3C 3C 3C 3C 3E 3C 3E 3E 7E 7F 7F 7F 7F 7F
	.he 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F
	.he 7F 7F 7F 7F 7F 7F 7F 7F 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 78 7C FE FF FF FF FF FF FF FF FF FF
	.he EF EF EF EF EF EF EF EF EF EF EF CF 4F 4F 4F CF
	.he CF CE CE CE CF CF CC CC DC CF D9 D9 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
	.he 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF 00 BC B2 00
	.he 01 03 07 07 0F 0F 1E 1E 1E 3E BE FD FD FD FD FD
	.he FB FB FB FB BB BB BB BB BB BB DF DF DD DF DF DF
	.he CF CE 8F 87 87 87 87 87 C7 C7 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM



trans ins '07_go_to_meta.obx.bc'

end_part_hand_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	
