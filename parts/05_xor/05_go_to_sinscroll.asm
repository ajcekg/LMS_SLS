PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$300
RUN_ADDRESS		equ	mainend

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

dlist01
		:5	dta b($70)
		:1	dta b($80)
		:3	dta b(0)
.rept 15 #*vlinelen
		:+1	dta b($70)
.endr
		:1	dta b($70)
		:1	dta b($41),a(dlist01)	

	utils_wait_one_frame

.local main
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	lda #0
	sta colbak
	sta colpf0
	sta colpf1
	sta colpf2
	sta colpf3
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
	pm_set_size 3
	mva #0 dmactl
	mva #@dmactl(standard|dma) dmactl
	mva #0 pmcntl
	mwa #dlist01 dlptr
	set_dli dl002
	lda #255
	sta grafm
	sta grafp0
	sta grafp1
	sta grafp2	
	sta grafp3
	lda #%10000
	sta gtictl
	set_vbl vblk1

	
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

.local vblk1
	phr
l0	lda #0
	beq s0
	dec l0+1
	jmp end1

s0	lda #0
	beq a1
	cmp #1
	beq a2
	cmp #2
	beq a3
	cmp #3
	beq a4
	cmp #4
	beq a5
	cmp #5
	beq a6
	jmp end
a1	lda #32
	sta hposp0
	lda #24
	sta l0+1
	jmp end
a2	lda #64
	sta hposp1
	lda #18
	sta l0+1	
	jmp end
a3	lda #96
	sta hposp2
	lda #18
	sta l0+1	
	jmp end
a4	lda #128
	sta hposp3
	lda #12
	sta l0+1	
	jmp end
a5	lda #128+32
	sta hposm0
	lda #128+32+8
	sta hposm1
	lda #128+32+16
	sta hposm2
	lda #128+32+24
	sta hposm3
	lda #6
	sta l0+1	
	jmp end
a6	
	mva #0 dmactl
	mva #1 end_eff
	restore_vbl		
	jmp end
end	
	inc s0+1
end1	
	plr
	rti
.endl
	
////////////////////////////////////////////////////////////////////////////////////	
	
mainend	.local
.if PGENE = 1
	jsr rom_off
.else
s0	cpw frmcnt #((10*64*6)-(32*6)-(48*6))+(48*6)+2
	bne s0
.endif
	jsr wait_one_frame
	lda #0
	sta colbak
	sta colpf0
	sta colpf1
	sta colpf2
	sta colpf3
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
	sta dmactl
	sta pmcntl	
	pm_set_size 3
	mwa #dlist01 dlptr
	set_dli dl002
	lda #255
	sta grafm
	sta grafp0
	sta grafp1
	sta grafp2	
	sta grafp3
	lda #%10000
	sta gtictl
	
	lda #32
	sta hposp0
	lda #32+32
	sta hposp1
	lda #32+32+32
	sta hposp2
	lda #32+32+32+32
	sta hposp3			
	lda #32+32+32+32+32
	sta hposm0
	lda #32+32+32+32+32+8
	sta hposm1
	lda #32+32+32+32+32+16
	sta hposm2
	lda #32+32+32+32+32+24
	sta hposm3
	set_vbl vblk
	
	
	
	
	
.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
l0	lda #0
	beq s0
	dec l0+1
	jmp end1
	
s0	lda #0
	beq a1
	cmp #1
	beq a2
	cmp #2
	beq a3
	cmp #3
	beq a4
	cmp #4
	beq a5
	cmp #5
	beq a6
	cmp #6
	beq a7		
	jmp end
a1	mva #@dmactl(standard|dma) dmactl
	lda #24
	sta l0+1
	jmp end
a2	lda #255 	
	sta hposm0
	sta hposm1
	sta hposm2
	sta hposm3
	lda #18
	sta l0+1	
	jmp end
a3	lda #255
	sta hposp3
	lda #18
	sta l0+1		
	jmp end
a4	lda #255
	sta hposp2
	lda #12
	sta l0+1		
	jmp end
a5	lda #255
	sta hposp1
	lda #12
	sta l0+1		
	jmp end
a6	lda #255
	sta hposp0
	lda #6
	sta l0+1		
	jmp end
a7	mva #1 end_eff
	restore_vbl	
end	
	inc s0+1
end1	
	plr
	rti
.endl


dl002	.local
	sta regA
	stx regX
	sty regY
	lda #$60
	sta wsync
	nop
	nop
	sta colbak
	sta wsync
	nop
	mva #$00 colbak
	sta wsync
	nop
	mva #$60 colbak	
//line 0
sx_0_0
	sta wsync

//line 1
sx_0_1
	sta wsync

//line 2
sx_0_2
	sta wsync

//line 3
sx_0_3
	sta wsync

//line 4
sx_0_4
	sta wsync

//line 5
sx_0_5
	sta wsync
	nop
	mva #$62 colbak	

//line 6
sx_0_6
	sta wsync
	nop
	mva #$60 colbak	

//line 7
sx_0_7
	sta wsync
	nop
	mva #$62 colbak	

//line 8
sx_1_0
	sta wsync

//line 9
sx_1_1
	sta wsync
	
//line 10
sx_1_2
	sta wsync
	
//line 11
sx_1_3
	sta wsync
	
//line 12
sx_1_4
	sta wsync
		
//line 13
sx_1_5
	sta wsync
	nop
	mva #$64 colbak	
	
//line 14
sx_1_6
	sta wsync
	nop
	mva #$62 colbak	
	
//line 15
sx_1_7
	sta wsync
	nop
	mva #$64 colbak	

//line 16
sx_2_0
	sta wsync

//line 17
sx_2_1
	sta wsync

//line 18

sx_2_2
	sta wsync
	
//line 19
sx_2_3
	sta wsync

//line 20
sx_2_4
	sta wsync
		
//line 21
sx_2_5
	sta wsync
	nop
	mva #$66 colbak	
	
//line 22
sx_2_6
	sta wsync
	nop
	mva #$64 colbak	
	
//line 23
sx_2_7
	sta wsync
	nop
	mva #$66 colbak	

//line 24
sx_3_0
	sta wsync
	
//line 25
sx_3_1
	sta wsync
	
//line 26
sx_3_2
	sta wsync
	
//line 27
sx_3_3
	sta wsync
	
//line 28
sx_3_4
	sta wsync
	
//line 29
sx_3_5
	sta wsync
	nop
	mva #$78 colbak	
	
//line 30
sx_3_6
	sta wsync
	nop
	mva #$66 colbak	
	
//line 31
sx_3_7
	sta wsync
	nop
	mva #$78 colbak	
	
//line 32
sx_4_0
	sta wsync
	
//line 33
sx_4_1
	sta wsync
	
//line 34
sx_4_2
	sta wsync
	
//line 35
sx_4_3
	sta wsync
	
//line 36
sx_4_4
	sta wsync
	
//line 37
sx_4_5
	sta wsync
	nop
	mva #$7a colbak	
	
//line 38
sx_4_6
	sta wsync
	nop
	mva #$78 colbak	
	
//line 39
sx_4_7
	sta wsync
	nop
	mva #$7a colbak	

//line 40
sx_5_0
	sta wsync
	
//line 41
sx_5_1
	sta wsync

//line 42
sx_5_2
	sta wsync
	
//line 43
sx_5_3
	sta wsync
	
//line 44
sx_5_4
	sta wsync
	
//line 45
sx_5_5
	sta wsync
	
//line 46
sx_5_6
	sta wsync
	
//line 47
sx_5_7
	sta wsync
	
//line 48
sx_6_0
	sta wsync
	
//line 49
sx_6_1
	sta wsync
	
//line 50
sx_6_2
	sta wsync
	
//line 51
sx_6_3
	sta wsync
	
//line 52
sx_6_4
	sta wsync
	
//line 53
sx_6_5
	sta wsync
	
//line 54
sx_6_6
	sta wsync
	
//line 55
sx_6_7
	sta wsync
	
//line 56
sx_7_0
	sta wsync
	
//line 57
sx_7_1
	sta wsync
	
//line 58
sx_7_2
	sta wsync
	
//line 59
sx_7_3
	sta wsync
	
//line 60
sx_7_4
	sta wsync
	
//line 61
sx_7_5
	sta wsync
	
//line 62
sx_7_6
	sta wsync
	
//line 63
sx_7_7
	sta wsync
	
//line 64
sx_8_0
	sta wsync
	
//line 65
sx_8_1
	sta wsync
	
//line 66
sx_8_2
	sta wsync
	
//line 67
sx_8_3
	sta wsync
	
//line 68
sx_8_4
	sta wsync
	
//line 69
sx_8_5
	sta wsync
	
//line 70
sx_8_6
	sta wsync
	
//line 71
sx_8_7
	sta wsync
	
//line 72
sx_9_0
	sta wsync
	
//line 73
sx_9_1
	sta wsync
	
//line 74
sx_9_2
	sta wsync

//line 75
sx_9_3
	sta wsync
	
//line 76
sx_9_4
	sta wsync
	
//line 77
sx_9_5
	sta wsync

//line 78
sx_9_6
	sta wsync
	
//line 79
sx_9_7
	sta wsync
	
//line 80
sx_10_0
	sta wsync
	
//line 81
sx_10_1
	sta wsync
	
//line 82
sx_10_2
	sta wsync
	
//line 83
sx_10_3
	sta wsync

//line 84
sx_10_4
	sta wsync
	
//line 85
sx_10_5
	sta wsync
	nop
	mva #$78 colbak
	
//line 86
sx_10_6
	sta wsync
	nop
	mva #$7a colbak
	
//line 87
sx_10_7
	sta wsync
	nop
	mva #$78 colbak
	
//line 88
sx_11_0
	sta wsync
	
//line 89
sx_11_1
	sta wsync
	
//line 90
sx_11_2
	sta wsync
	
//line 91
sx_11_3
	sta wsync
	
//line 92
sx_11_4
	sta wsync
	
//line 93
sx_11_5
	sta wsync
	nop
	mva #$66 colbak
	
//line 94
sx_11_6
	sta wsync
	nop
	mva #$78 colbak
	
//line 95
sx_11_7
	sta wsync
	nop
	mva #$66 colbak
	
//line 96
sx_12_0
	sta wsync
	
//line 97
sx_12_1
	sta wsync
	
//line 98
sx_12_2
	sta wsync
	
//line 99
sx_12_3
	sta wsync
	
//line 100
sx_12_4
	sta wsync
	
//line 101
sx_12_5
	sta wsync
	nop
	mva #$64 colbak
	
//line 102
sx_12_6
	sta wsync
	nop
	mva #$66 colbak
	
//line 103
sx_12_7
	sta wsync
	nop
	mva #$64 colbak
	
//line 104
sx_13_0
	sta wsync
	
//line 105
sx_13_1
	sta wsync
	
//line 106
sx_13_2
	sta wsync

//line 107
sx_13_3
	sta wsync
	
//line 108
sx_13_4
	sta wsync

//line 109
sx_13_5
	sta wsync
	nop
	mva #$62 colbak

//line 110
sx_13_6
	sta wsync
	nop
	mva #$64 colbak
	
//line 111
sx_13_7
	sta wsync
	nop
	mva #$62 colbak
	
//line 112
sx_14_0
	sta wsync
	
//line 113
sx_14_1
	sta wsync
	
//line 114
sx_14_2
	sta wsync
	
//line 115
sx_14_3
	sta wsync
	
//line 116
sx_14_4
	sta wsync
	
//line 117
sx_14_5
	sta wsync
	nop
	mva #$60 colbak
	
//line 118
sx_14_6
	sta wsync
	nop
	mva #$62 colbak
	
//line 119
sx_14_7
	sta wsync
	nop
	mva #$60 colbak
	
//line 120
sx_15_0
	sta wsync
	
//line 121
sx_15_1
	sta wsync
	
//line 122
sx_15_2
	sta wsync
	
//line 123
sx_15_3
	sta wsync
	
//line 124
sx_15_4
	sta wsync
	
//line 125
sx_15_5
	sta wsync
	nop
	mva #$00 colbak	
	
//line 126
sx_15_6
	sta wsync
	nop
	mva #$60 colbak	
	
//line 127
sx_15_7
	sta wsync
	nop
	mva #$00 colbak	
	lda regA
	ldx regX
	ldy regY
	rti
.endl


end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	