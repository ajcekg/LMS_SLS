PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000-3
RUN_ADDRESS		equ	main

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
fnt	ins "data\eclipse01.fnt",0,$920	
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
.ALIGN $0400
fnt	ins "data\eclipse01.fnt",0,$920
.endif

ant	dta $42,a(scr)
	dta $82,$02,$82,$02,$02,$02,$82,$02,$02,$82,$02,$82,$02,$02,$02,$02
	dta $02,$02,$02,$02,$02,$02,$02,$82,$82,$82,$02,$02,$22
	dta $41,a(ant)

scr	ins "data\eclipse01.scr"

	utils_wait_end_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_end_frame
	lda #1
	sta vscrol	
	set_vbl vblk

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	pha
	mwa #ant dlptr
	mva #@dmactl(standard|dma) dmactl
	set_dli dli_start
	lda >fnt+$400*$00
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
end	pla
	rti
.endl

dli_start .local

dli8
	sta regA
	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
c9	lda #$88
	sta wsync		;line=20
	sta colpm2
	set_dli dli9
	lda regA
	rti

dli9
	sta regA
c10	lda #$28
	sta wsync		;line=32
	sta colpm2
	set_dli dli10
	lda regA
	rti

dli10
	sta regA
	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
c11	lda #$88
	sta wsync		;line=68
	sta colpm2
	set_dli dli11
	lda regA
	rti

dli11
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
	lda >fnt+$400*$01
	sta wsync		;line=104
	sta chbase
	set_dli dli3
	lda regA
	rti

dli3
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=200
	sta chbase
	set_dli dli4
	lda regA
	rti

dli4
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=208
	sta chbase
	set_dli dli5
	lda regA
	rti

dli5
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=216
	sta chbase
	lda regA
	rti
.endl




end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	