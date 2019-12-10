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

////////////////////////////////////////////////////////////////////////////////////////
pmposx	equ	108

	utils_wait_one_frame
mainend	.local
.if PGENE = 1
	jsr rom_off
.else
//synchro
sh2	cpw frmcnt #(((32*6)+(64*4*6))-128)
	bne sh2
.endif

	jsr wait_one_frame
	lda #@dmactl(players|missiles|lineX1)
	sta dmactl
	pm_set_all_color $6f
	lda #pmposx
	sta hposm3
	lda #pmposx+2
	sta hposm2
	lda #pmposx+4
	sta hposm1
	lda #pmposx+6
	sta hposm0
	lda #pmposx+8
	sta hposp0
	lda #pmposx+16
	sta hposp1
	lda #pmposx+24
	sta hposp2
	lda #pmposx+32
	sta hposp3
	pm_set_size 0
	lda #>spr
	sta pmbase
	lda #1
	sta gtictl
	lda #0
	sta end_eff
	lda #3
	sta pmcntl
	set_vbl vblkend
.if PGENE = 0	
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblkend	.local
	phr
l0	lda #43
	beq ee
	jsr move_up
	dec l0+1
	jmp evblk
ee	restore_nmi
	mva #1 end_eff
evblk
	plr
	rti
.endl

move_up	.local
	ldx #90
l1	ldy #114
l0	lda spr+$300,y
	sta spr+$300-1,y
	lda spr+$400,y
	sta spr+$400-1,y
	lda spr+$500,y
	sta spr+$500-1,y
	lda spr+$600,y
	sta spr+$600-1,y
	lda spr+$700,y
	sta spr+$700-1,y
	iny
	dex
	bne l0
	dec l1+1
	rts			
.endl

	org $800
spr	ins 'data\emb.spr'

/////////////////////////////////////////////////////////////////////////////////////////////
.if PGENE = 1
	run RUN_ADDRESS
.endif	