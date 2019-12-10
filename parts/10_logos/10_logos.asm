PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$4000
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
	jmp main
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

	utils_wait_one_frame
	utils_wait_x_frame

ant	dta $44,a(scr)
	dta $04,$04,$04,$04,$04,$84,$04,$04,$04,$04,$84,$04,$84,$04,$04,$04
	dta $84,$04,$04,$04,$84,$84,$04,$84,$04,$04,$04,$84,$04
	dta $41,a(ant)

scr	ins "data\logos18.scr"

.ALIGN $0400
fnt	ins "data\logos18.fnt"

.ALIGN $0800
pmg	.ds $0300
	SPRITES

.local main
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2		
.endif
	mva #0 dmactl
	jsr save_color_set_0
	jsr wait_one_frame
	restore_nmi
	mva >pmg pmbase
	mva #$03 pmcntl
	set_vbl VBL

l0	ldx #32
	beq l1
	dec l0+1
	jsr wait_one_frame
	jsr wait_one_frame
	jsr fade_in_to_color
	jmp l0
	
l1	lda #200
	jsr wait_x_frame
.if PGENE = 0	
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
.endif	
l2	ldx #16
	beq l3
	dec l2+1
	jsr wait_one_frame
	jsr fade_to_0
	jmp l2
	
l3	
.if PGENE = 0
	jsr wait_one_frame
	restore_nmi
	mva #0 dmactl
	jmp $400
.else
q1	//lda random
	//sta colbak
	jmp q1
.endif
.endl
/////////////////////////////////////////////////////////////////////

.local	save_color_set_0
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
		mva	#0	(fadr),y
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


.local fade_in_to_color
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
		clc
		adc #1
n0		sta n1+1

		txa
		and #$f0
l1		cmp #0
		beq n1
		clc
		adc #$10

n1		ora #0
		sta	(fadr),y
next	adw	fcnt #3		
		jmp loop		
.endl


tcol
.rept 9 #
	dta t(vbl.c:1)
.endr
.rept 58-9 #+9
	dta t(dli_start.c:1)
.endr
	dta t(0)
tcolend


/////////////////////////////////////////////////////////////////////

dli_start .local

dli8
	sta regA
	stx regX

	sta wsync		;line=56
	sta wsync		;line=57
	sta wsync		;line=58
	sta wsync		;line=59
	sta wsync		;line=60
	sta wsync		;line=61
	sta wsync		;line=62
c9	lda #$08
s5	ldx #$00
	sta wsync		;line=63
	sta color2
	stx sizep0
c10	lda #$8A
	sta wsync		;line=64
	sta colpm0
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$36
	sta wsync		;line=68
	sta colpm0
	sta wsync		;line=69
c12	lda #$32
	sta wsync		;line=70
	sta color0
c13	lda #$30
	sta wsync		;line=71
	sta color0
	sta wsync		;line=72
c14	lda #$32
	sta wsync		;line=73
	sta color0
c15	lda #$30
	sta wsync		;line=74
	sta color0
c16	lda #$32
	sta wsync		;line=75
	sta color0
c17	lda #$30
	sta wsync		;line=76
	sta color0
c18	lda #$32
c19	ldx #$8A
	sta wsync		;line=77
	sta color0
	stx color3
c20	lda #$30
	sta wsync		;line=78
	sta color0
c21	lda #$32
	sta wsync		;line=79
	sta color0
	lda >fnt+$400*$01
c22	ldx #$30
	sta wsync		;line=80
	sta chbase
	stx color0
c23	lda #$32
	sta wsync		;line=81
	sta color0
	sta wsync		;line=82
c24	lda #$30
	sta wsync		;line=83
	sta color0
c25	lda #$32
	sta wsync		;line=84
	sta color0
	set_dli dli9
	lda regA
	ldx regX
	rti

dli9
	sta regA
	stx regX
	sty regY

x8	lda #$4C
	sta wsync		;line=96
	sta hposp2
	sta wsync		;line=97
	sta wsync		;line=98
x9	lda #$4B
	sta wsync		;line=99
	sta hposp2
	sta wsync		;line=100
	sta wsync		;line=101
	sta wsync		;line=102
x10	lda #$4A
	sta wsync		;line=103
	sta hposp2
	sta wsync		;line=104
	sta wsync		;line=105
x11	lda #$84
x12	ldx #$49
x13	ldy #$81
	sta wsync		;line=106
	sta hposp0
	stx hposp2
	sty hposm0
	sta wsync		;line=107
	sta wsync		;line=108
c26	lda #$02
s6	ldx #$D0
x14	ldy #$8C
	sta wsync		;line=109
	sta color0
	stx sizem
	sty hposp2
c27	lda #$22
	sta colpm2
	set_dli dli2
	lda regA
	ldx regX
	ldy regY
	rti

dli2
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=112
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt+$400*$03
	sta wsync		;line=144
	sta chbase
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt+$400*$04
	sta wsync		;line=176
	sta chbase
	set_dli dli10
	lda regA
	rti

dli10
	sta regA

	sta wsync		;line=184
	sta wsync		;line=185
	sta wsync		;line=186
c28	lda #$18
	sta wsync		;line=187
	sta color2
c29	lda #$08
	sta wsync		;line=188
	sta color2
c30	lda #$18
	sta wsync		;line=189
	sta color2
c31	lda #$08
	sta wsync		;line=190
	sta color2
c32	lda #$18
	sta wsync		;line=191
	sta color2
c33	lda #$08
	sta wsync		;line=192
	sta color2
c34	lda #$18
	sta wsync		;line=193
	sta color2
c35	lda #$08
	sta wsync		;line=194
	sta color2
c36	lda #$18
	sta wsync		;line=195
	sta color2
c37	lda #$08
	sta wsync		;line=196
	sta color2
c38	lda #$18
	sta wsync		;line=197
	sta color2
	set_dli dli11
	lda regA
	rti

dli11
	sta regA
	stx regX

	sta wsync		;line=200
	sta wsync		;line=201
	sta wsync		;line=202
	sta wsync		;line=203
	sta wsync		;line=204
	sta wsync		;line=205
	sta wsync		;line=206
c39	lda #$36
	sta wsync		;line=207
	sta color2
	lda >fnt+$400*$03
c40	ldx #$18
	sta wsync		;line=208
	sta chbase
	stx color2
c41	lda #$36
	sta wsync		;line=209
	sta color2
c42	lda #$18
	sta wsync		;line=210
	sta color2
c43	lda #$36
	sta wsync		;line=211
	sta color2
c44	lda #$18
	sta wsync		;line=212
	sta color2
c45	lda #$36
	sta wsync		;line=213
	sta color2
c46	lda #$18
	sta wsync		;line=214
	sta color2
c47	lda #$36
	sta wsync		;line=215
	sta color2
	lda >fnt+$400*$04
c48	ldx #$18
	sta wsync		;line=216
	sta chbase
	stx color2
c49	lda #$36
	sta wsync		;line=217
	sta color2
c50	lda #$18
	sta wsync		;line=218
	sta color2
c51	lda #$36
	sta wsync		;line=219
	sta color2
c52	lda #$18
	sta wsync		;line=220
	sta color2
c53	lda #$36
	sta wsync		;line=221
	sta color2
c54	lda #$18
	sta wsync		;line=222
	sta color2
c55	lda #$36
	sta wsync		;line=223
	sta color2
	lda >fnt+$400*$00
c56	ldx #$18
	sta wsync		;line=224
	sta chbase
	stx color2
c57	lda #$36
	sta wsync		;line=225
	sta color2
	set_dli dli5
	lda regA
	ldx regX
	rti

dli5
	sta regA
	lda >fnt+$400*$05
	sta wsync		;line=232
	sta chbase
	lda regA
	rti

.endl

VBL	.local
	sta regA
	stx regX
	sty regY
	set_dli dli_start
	mwa #ant dlptr		;ANTIC address program
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl	;set new screen width

	lda >fnt+$400*$00
	sta chbase
c0	lda #$04
	sta colbak
c1	lda #$30
	sta color0
c2	lda #$00
	sta color1
c3	lda #$88
	sta color2
c4	lda #$24
	sta color3
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
s0	lda #$03
	sta sizep0
s1	lda #$01
	sta sizep1
s2	lda #$03
	sta sizep3
s3	lda #$C0
	sta sizem
x0	lda #$80
	sta hposp0
x1	lda #$20
	sta hposp1
x2	lda #$A2
	sta hposp3
x3	lda #$C1
	sta hposm3
c5	lda #$02
	sta colpm0
c6	lda #$00
	sta colpm1
c7	lda #$02
	sta colpm3
x4	lda #$7E
	sta hposm0
s4	lda #$00
	sta sizep2
x5	lda #$4D
	sta hposp2
c8	lda #$02
	sta colpm2
x6	lda #$5D
	sta hposm2
x7	lda #$00
	sta hposm1
	lda regA
	ldx regX
	ldy regY
	rti
.endl

///////////////////////////////////////////////////////////////////////

trans ins "10_go_to_carpet.obx.bc"
end_part_memory

.MACRO	SPRITES
missiles
	.he 00 00 00 00 00 00 00 00 C0 C0 80 80 80 80 00 00
	.he 00 00 80 80 80 80 C0 C0 C0 00 00 00 00 C0 C0 C0
	.he C0 C0 C0 00 00 00 00 C0 C0 C0 80 80 80 80 00 00
	.he 00 00 80 80 80 80 C0 C0 C0 80 80 80 80 C0 C0 C0
	.he C0 C0 80 80 80 80 C0 C0 C0 80 80 80 80 80 80 80
	.he 80 80 80 80 80 C0 C0 C3 83 80 83 81 C3 C0 C0 C0
	.he C0 C0 C0 80 80 80 80 C0 C0 C0 80 80 80 80 80 80
	.he 80 80 80 80 80 B1 F1 F1 F1 B3 B3 B3 B2 F3 F2 F2
	.he C2 C3 C2 82 83 82 83 C1 C1 C2 82 83 83 81 83 83
	.he 80 80 80 80 80 80 C0 C0 C0 80 80 80 80 C0 C0 C0
	.he C0 C0 80 80 80 80 C0 C0 C0 80 80 80 80 80 80 80
	.he 80 80 80 80 80 C0 C0 C0 80 80 80 80 C0 C0 C0 C0
	.he C0 C0 C0 80 80 80 80 C0 C0 C0 80 80 80 80 00 00
	.he 00 00 80 80 80 80 C0 C0 C0 00 00 00 00 C0 C0 C0
	.he C0 C0 C0 00 00 00 00 C0 C0 C0 80 80 80 80 00 00
	.he 00 00 80 80 80 80 C0 C0 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF 3F 3F 3F
	.he 3F 3F 3F 3F 1F 1F 1F 1F 1F 1F 1F 0F 0F 0F 0F 0F
	.he 0F 0F 0F 0F 0F 0F 0F 07 07 0F 0F 0F 0F 07 07 07
	.he 07 07 07 07 07 07 07 00 AB 5F 55 A3 AF BD BF AB
	.he 9D 9D 9F FB 6F FB 5B 7C AF 7E 5B 65 64 E7 E7 E7
	.he 43 47 01 47 85 9F 9A BE BF BA B7 07 FF FA B0 DC
	.he FF BF FF FE CD 2D 1D 2D 3F 2F 3B 1A 3E 1E 3E 1C
	.he 3C 14 1C 3C 38 78 38 7E 36 76 36 7A 2A 5E 26 22
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 F8 E8 E8 FC
	.he DC DE FE BF BF FF 7F 7F FF 7F 7F FF FF 7F FF FF
	.he 7F FF FF FF FF 7F 7F FF FE FF 7C FA BC 70 10 38
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 FF FF 11 11 11 11 11 11
	.he 11 11 11 11 11 11 FF FF FF 11 11 11 11 FF FF FF
	.he FF FF FF FD FD FD FD FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF 7F 7F 7F 3F 3F 3F 3F 3F 3F 3F 3F
	.he 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F
	.he 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 1F 1F 1F
	.he 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F
	.he 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F
	.he 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F
	.he 1F 1F 1F 1F 1F 1F 1F 1F 3F 3D 3D 3D 3D 3F 7F 7F
	.he 7F 7F 7F 11 11 11 11 FF FF FF 11 11 11 11 11 11
	.he 11 11 11 11 11 11 FF FF 00 00 00 00 00 00 00 00
.ENDM

.if PGENE = 1
	run RUN_ADDRESS
.endif	
