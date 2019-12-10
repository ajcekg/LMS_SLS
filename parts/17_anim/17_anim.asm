PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$2000-3
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
	org LOAD_ADDRESS-400
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
.align $1000
.endif
//////////////////////////////////////////////////////////////////////////////////////
fnt		ins "data\moon.fnt"
.align $1000
scr		ins "data\moon.scr" 
ant	dta $44,a(scr)
	dta $04,$04,$04,$04,$84,$04,$04,$84,$04,$84,$04,$04,$84,$84,$84,$04
	dta $04,$84,$04,$04,$04,$04,$84,$84,$04,$04,$04,$04,$04
	dta $41,a(ant)

init_scr	.local
	jsr wait_one_frame
	mva >pmg pmbase
	mva #$03 pmcntl
	set_vbl VBL
	rts
.endl

cc0	dta b(0,$0e,$0e,$0d,$0d,$0c,$0c,$0e,$0e,$0c,$0c,$0e,$0e,$0c,$0c,$0a,$0a)	//c14,c3
cc1	dta b(0,$88,$88,$87,$87,$88,$88,$89,$89,$88,$88,$88,$88,$87,$87,$86,$86)	//c8,c13,c2
cc2 dta b(0,$8a,$8a,$89,$89,$8a,$8a,$8b,$8b,$8a,$8a,$8a,$8a,$89,$89,$88,$88)	//c5,c6

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


VBL	.local
	sta regA
	stx regX
	sty regY
/////////////////////////////
w0	lda #0
	beq t0
	dec w0+1
	jmp t2
t0	lda #0
	and #$f
	beq wait1
	tax
	lda cc0,x
	sta c3+1
	sta dli_start.c14+1
	lda cc1,x
	sta c2+1
	sta dli_start.c8+1
	sta dli_start.c13+1
	lda cc2,x
	sta c5+1
	sta c6+1
	inc t0+1
	jmp t2
wait1
	lda random
	and #7
	sta w0+1
	lda #1
	sta t0+1
	
//////////////////////////////	
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

.ALIGN $0800
pmg	.ds $0300
	SPRITES


//////////////////////////////////////////////////////////////////////////////////////



	utils_wait_one_frame
	utils_wait_end_frame
	utils_wait_x_frame

wait_time	equ 15

main	.local

.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
	mva #1 vscrol
	jsr init_scr_2
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_3
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_4
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_5
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_6
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_7
	lda #wait_time
	jsr wait_x_frame
	jsr init_scr_8
	lda #(wait_time*2)
	jsr wait_x_frame
	jsr save_color
a0	jsr wait_one_frame
	jsr fade_to_0
	inc a1+1
a1	lda #0
	cmp #16
	bne a0
	restore_nmi
	mva #0 dmactl
	jsr init_scr
	
.if PGENE = 0
	jsr OS_PREP_NEXT_PART
.else
	jmp *
.endif	
.endl
////////////////////////////////////////////////////////////////////////////////////////
.align $1000
.print "pic 8 fnt start: ",*
fnt8	ins "data\eclipse8.fnt"
.print "pic 8 scr start: ",*	
scr8	ins "data\eclipse8.scr"
.print "pic 8 dl start: ",*	
ant8	dta $42,a(scr8)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$82,$02,$02,$02
		dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant8)
.print "pic 8 code start: ",*

init_scr_8	.local
	jsr wait_end_frame
	set_vbl VBL8
	rts
.endl


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

tcol
.rept 8 #
	dta t(VBL8.c:1)
.endr
	dta t(dli_start8.c8,dli_start8.c9,dli_start8.c10,dli_start8.c11)
	dta t(0)
tcolend

dli_start8		.local

dli5
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c8	lda #$86
	sta wsync		;line=20
	sta colpm2
	set_dli dli6
	lda regA
	rti

dli6
	sta regA

c9	lda #$26
	sta wsync		;line=32
	sta colpm2
	set_dli dli7
	lda regA
	rti

dli7
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c10	lda #$86
	sta wsync		;line=68
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c11	lda #$26
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt8+$400*$01
	sta wsync		;line=112
	sta chbase

	lda regA
	rti
.endl
VBL8	.local
	sta regA
	mwa #ant8 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start8
	lda >fnt8+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$32
	sta colpm1
c2	lda #$26
	sta colpm2
c3	lda #$1A
	sta colpm3
c4	lda #$40
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 8 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 7 fnt start: ",*
fnt7	ins "data\eclipse7.fnt"
.print "pic 7 scr start: ",*	
scr7	ins "data\eclipse7.scr"
.print "pic 7 dl start: ",*	
ant7	dta $42,a(scr7)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$02,$82,$02,$82
		dta $82,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant7)
.print "pic 7 code start: ",*

init_scr_7	.local
	jsr wait_end_frame
	set_vbl VBL7
	rts
.endl
dli_start7	.local
dli7
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm3
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

c10	lda #$28
	sta wsync		;line=32
	sta colpm3
	set_dli dli9
	lda regA
	rti

dli9
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm3
	set_dli dli10
	lda regA
	rti

dli10
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c12	lda #$28
	sta wsync		;line=92
	sta colpm3
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt7+$400*$01
	sta wsync		;line=120
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt7+$400*$00
	sta wsync		;line=136
	sta chbase
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt7+$400*$01
	sta wsync		;line=144
	sta chbase

	lda regA
	rti

.endl
VBL7	.local
	sta regA
	mwa #ant7 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start7	
	lda >fnt7+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$42
	sta colpm1
c2	lda #$34
	sta colpm2
c3	lda #$28
	sta colpm3
c4	lda #$1C
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
c8	lda #$9E
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 7 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 6 fnt start: ",*
fnt6	ins "data\eclipse6.fnt"
.print "pic 6 scr start: ",*	
scr6	ins "data\eclipse6.scr"
.print "pic 6 dl start: ",*	
ant6	dta $42,a(scr6)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$02,$82,$02,$02
		dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant6)
.print "pic 6 code start: ",*

init_scr_6	.local
	jsr wait_end_frame
	set_vbl VBL6
	rts
.endl
dli_start6		.local

dli5
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c8	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli6
	lda regA
	rti

dli6
	sta regA

c9	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli7
	lda regA
	rti

dli7
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c10	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c11	lda #$28
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt6+$400*$01
	sta wsync		;line=120
	sta chbase

	lda regA
	rti

.endl
VBL6	.local
	sta regA
	mwa #ant6 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start6
	lda >fnt6+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$34
	sta colpm1
c2	lda #$28
	sta colpm2
c3	lda #$1C
	sta colpm3
c4	lda #$42
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 6 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 5 fnt start: ",*
fnt5	ins "data\eclipse5.fnt"
.print "pic 5 scr start: ",*	
scr5	ins "data\eclipse5.scr"
.print "pic 5 dl start: ",*	
ant5	dta $42,a(scr5)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$02,$82,$02,$02
		dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant5)
.print "pic 5 code start: ",*

init_scr_5	.local
	jsr wait_end_frame
	set_vbl VBL5
	rts
.endl
dli_start5	.local

dli5
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli6
	lda regA
	rti

dli6
	sta regA

c10	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli7
	lda regA
	rti

dli7
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c12	lda #$28
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt5+$400*$01
	sta wsync		;line=120
	sta chbase

	lda regA
	rti

.endl
VBL5	.local
	sta regA
	mwa #ant5 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start5
	lda >fnt5+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$34
	sta colpm1
c2	lda #$28
	sta colpm2
c3	lda #$1C
	sta colpm3
c4	lda #$42
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
c8	lda #$9E
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 5 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 4 fnt start: ",*
fnt4	ins "data\eclipse4.fnt"
.print "pic 4 scr start: ",*	
scr4	ins "data\eclipse4.scr"
.print "pic 4 dl start: ",*	
ant4	dta $42,a(scr4)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$82,$02,$02,$02
		dta $02,$02,$02,$82,$82,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant4)
.print "pic 4 code start: ",*

init_scr_4	.local
	jsr wait_end_frame
	set_vbl VBL4
	rts
.endl
dli_start4	.local

dli7
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

c10	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli9
	lda regA
	rti

dli9
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli10
	lda regA
	rti

dli10
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c12	lda #$28
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt4+$400*$01
	sta wsync		;line=112
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt4+$400*$00
	sta wsync		;line=168
	sta chbase
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt4+$400*$01
	sta wsync		;line=176
	sta chbase

	lda regA
	rti

.endl
VBL4	.local
	sta regA
	mwa #ant4 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start4
	lda >fnt4+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$34
	sta colpm1
c2	lda #$28
	sta colpm2
c3	lda #$1C
	sta colpm3
c4	lda #$42
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
c8	lda #$9E
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 4 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 3 fnt start: ",*
fnt3	ins "data\eclipse3.fnt"
.print "pic 3 scr start: ",*	
scr3	ins "data\eclipse3.scr"
.print "pic 3 dl start: ",*	
ant3	dta $42,a(scr3)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$02,$82,$02,$02,$02
		dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant3)
.print "pic 3 code start: ",*

init_scr_3	.local
	jsr wait_end_frame
	set_vbl VBL3
	rts
.endl
dli_start3	.local

dli5
	sta regA

	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli6
	lda regA
	rti

dli6
	sta regA

c10	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli7
	lda regA
	rti

dli7
	sta regA

	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c12	lda #$28
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt3+$400*$01
	sta wsync		;line=112
	sta chbase

	lda regA
	rti

.endl
VBL3	.local
	sta regA
	mwa #ant3 dlptr		;ANTIC address program
	mva #@dmactl(standard|dma) dmactl	;set new screen width
	set_dli dli_start3
	lda >fnt3+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$34
	sta colpm1
c2	lda #$28
	sta colpm2
c3	lda #$1C
	sta colpm3
c4	lda #$42
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
c8	lda #$9E
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 3 end: ",*
////////////////////////////////////////////////////////////////////////////////////////
.align $400
.print "pic 2 fnt start: ",*
fnt2	ins "data\eclipse2.fnt"
.print "pic 2 scr start: ",*	
scr2	ins "data\eclipse2.scr"
.print "pic 2 dl start: ",*	
ant2	dta $42,a(scr2)
		dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$82,$02,$02,$02,$02
		dta $02,$02,$02,$02,$82,$82,$02,$02,$02,$02,$02,$02,$22
		dta $41,a(ant2)
.print "pic 2 code start: ",*	
init_scr_2	.local
	jsr wait_end_frame
	set_vbl VBL2
	rts
.endl
dli_start2	.local

dli7
	sta regA
	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli8
	lda regA
	rti

dli8
	sta regA
c10	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli9
	lda regA
	rti

dli9
	sta regA
	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli10
	lda regA
	rti

dli10
	sta regA
	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c12	lda #$28
	sta wsync		;line=92
	sta colpm2
	set_dli dli2
	lda regA
	rti

dli2
	sta regA
	lda >fnt2+$400*$01
	sta wsync		;line=104
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt2+$400*$00
	sta wsync		;line=176
	sta chbase
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt2+$400*$01
	sta wsync		;line=184
	sta chbase
	lda regA
	rti
.endl
VBL2	.local
	sta regA
	mwa #ant2 dlptr
	mva #@dmactl(standard|dma) dmactl
	set_dli dli_start2
	lda >fnt2+$400*$00
	sta chbase
c0	lda #$00
	sta colpm0
c1	lda #$34
	sta colpm1
c2	lda #$28
	sta colpm2
c3	lda #$1C
	sta colpm3
c4	lda #$42
	sta color0
c5	lda #$76
	sta color1
c6	lda #$8A
	sta color2
c7	lda #$9C
	sta color3
c8	lda #$9E
	sta colbak
	lda #$02
	sta chrctl
	lda #$81
	sta gtictl
	lda regA
	rti
.endl
.print "pic 2 end: ",*	
////////////////////////////////////////////////////////////////////////////////////////

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
