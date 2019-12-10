PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400-3
RUN_ADDRESS		equ	main

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
.endif
.align $400
fnt	ins 'data\moon.fnt'	//,0,$a30
.align $1000
scr ins 'data\moon.scr'

ant	dta $44,a(scr)
	dta $04,$04,$04,$04,$84,$04,$04,$84,$04,$84,$04,$04,$84,$84,$84,$04
	dta $04,$84,$04,$04,$04,$04,$84,$84,$04,$04,$04,$04,$04
	dta $41,a(ant)

	utils_wait_one_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif

	mva #1 end_eff
	set_vbl vbl
	jsr wait_one_frame
	jsr wait_one_frame
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

cc0	dta b($0e,$0d,$0c,$0e,$0c,$0e,$0c,$0a)	//c14,c3
cc1	dta b($88,$87,$88,$89,$88,$88,$87,$86)	//c8,c13,c2
cc2 dta b($8a,$89,$8a,$8b,$8a,$8a,$89,$88)	//c5,c6

mryg	.local 
t0	lda #0
	and #$7
	tax
	lda cc0,x
	sta VBL.c3+1
	sta dli_start.c14+1
	lda cc1,x
	sta VBL.c2+1
	sta dli_start.c8+1
	sta dli_start.c13+1
	lda cc2,x
	sta VBL.c5+1
	sta VBL.c6+1
	inc t0+1
	rts
.endl

VBL	.local
	sta regA
	stx regX
	sty regY
	jsr mryg
	mva >pmg pmbase
	mva #$03 pmcntl	
	set_dli dli_start
t2	mwa #ant dlptr		;ANTIC address program
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl	;set new screen width
	set_dli dli_start
	lda >fnt+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
c1	lda #$64
	sta color0
c2	lda #$88
	sta color1
c3	lda #$0E
	sta color2
c4	lda #$62
	sta color3
	lda #$02
	sta chrctl
	sta gtictl
s0	lda #$03
	sta sizep3
x0	lda #$7B
	sta hposp3
c5	lda #$8A
	sta colpm3
s1	lda #$03
	sta sizep2
x1	lda #$5C
	sta hposp2
c6	lda #$8A
	sta colpm2
s2	lda #$00
	sta sizep1
x2	lda #$5D
	sta hposp1
c7	lda #$64
	sta colpm1
s3	lda #$40
	sta sizem
x3	lda #$60
	sta hposm3
x4	lda #$8F
	sta hposm2
x5	lda #$00
	sta hposp0
	sta hposm0
	sta hposm1
	sta sizep0
	sta colpm0
	lda regA
	ldx regX
	ldy regY
	rti
.endl

dli_start	.local

dli9
	sta regA

	sta wsync		;line=48
x6	lda #$83
	sta wsync		;line=49
	sta hposp3
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=72
	sta chbase
	set_dli dli10
	lda regA
	rti

dli10
	sta regA
	stx regX

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
	sta wsync		;line=92
	sta wsync		;line=93
c8	lda #$88
	sta wsync		;line=94
	sta colpm3
	sta wsync		;line=95
	sta wsync		;line=96
	sta wsync		;line=97
	sta wsync		;line=98
	sta wsync		;line=99
s4	lda #$00
x7	ldx #$A1
	sta wsync		;line=100
	sta sizep3
	stx hposp3
	sta wsync		;line=101
s5	lda #$00
x8	ldx #$A0
	sta wsync		;line=102
	sta sizep2
	stx hposp2
c9	lda #$1A
c10	ldx #$64
	sta wsync		;line=103
	sta color1
	stx colpm2
	lda >fnt+$400*$00
c11	ldx #$16
	sta wsync		;line=104
	sta chbase
	stx color0
	set_dli dli3
	lda regA
	ldx regX
	rti

dli3
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=112
	sta chbase
	set_dli dli11
	lda regA
	rti

dli11
	sta regA
	stx regX

c12	lda #$64
	sta wsync		;line=120
	sta color0
c13	lda #$88
c14	ldx #$0E
	sta wsync		;line=121
	sta color1
	stx colpm2
	set_dli dli12
	lda regA
	ldx regX
	rti

dli12
	sta regA

	sta wsync		;line=128
	sta wsync		;line=129
	sta wsync		;line=130
	sta wsync		;line=131
	sta wsync		;line=132
	sta wsync		;line=133
	sta wsync		;line=134
x9	lda #$66
	sta wsync		;line=135
	sta hposp2
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=152
	sta chbase
	sta wsync		;line=153
	sta wsync		;line=154
	sta wsync		;line=155
	sta wsync		;line=156
	sta wsync		;line=157
x10	lda #$6E
	sta wsync		;line=158
	sta hposp2
s6	lda #$01
	sta wsync		;line=159
	sta sizep2
	sta wsync		;line=160
	sta wsync		;line=161
	sta wsync		;line=162
	sta wsync		;line=163
	sta wsync		;line=164
	sta wsync		;line=165
	sta wsync		;line=166
s7	lda #$10
	sta wsync		;line=167
	sta sizem
	sta wsync		;line=168
x11	lda #$8C
	sta wsync		;line=169
	sta hposm2
	set_dli dli5
	lda regA
	rti

dli5
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=192
	sta chbase
	set_dli dli6
	lda regA
	rti

dli6
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=200
	sta chbase

	lda regA
	rti
.endl


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
	.he 00 00 00 00 00 00 00 00 00 00 00 00 C0 C0 C0 C0
	.he C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0 C0
	.he C0 C0 C0 C0 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30
	.he 30 30 30 30 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.ds $100
player1
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 D0 40 F0 68 B9
	.he 7D 39 11 98 35 68 30 58 A8 58 34 19 38 55 39 19
	.he 39 18 30 98 30 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 03 0F 0F 1F 1F 1F BF BF FF AB FF
	.he FF FE FC FC FC FC F8 FC F8 F8 F8 F8 F8 F8 F8 FF
	.he F8 FF FF FF F8 F8 F8 FF F8 F8 F0 F8 F0 F8 F8 F8
	.he F8 E8 E8 E0 C0 E0 C0 E0 C0 C0 40 40 40 40 00 BD
	.he DA FF DD 4E D4 4A 5D 5E 4E 5D 56 EC 56 FD DC FA
	.he B4 F0 F8 F4 FE FD FA FF FB FF 00 00 00 00 00 80
	.he 80 80 C0 C0 C0 C0 E0 E0 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 80 00 80 80 C0 C0 C0 E0 60 30
	.he 70 F8 FC 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 F0 F0 F8
	.he F8 FC FC FC FC FE FE FC FE FC F8 F8 F8 78 7C 7E
	.he 7C 3C 3E 0C 0C 0E 0E 06 07 06 07 06 06 06 02 FF
	.he 02 1F FF 0F 03 03 02 C3 00 01 01 01 01 01 00 00
	.he 00 01 01 01 01 01 01 00 00 00 00 00 F8 FA FC FA
	.he F4 FE FE FC F8 F4 FA FC FC FA FC F8 FC FA F8 F0
	.he E8 E0 F0 E8 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM


end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	