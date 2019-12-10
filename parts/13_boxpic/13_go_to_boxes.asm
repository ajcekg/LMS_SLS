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

dlist
	:1	dta b($50)
	:1	dta b($80)		
	:1	dta b($c4),a(wait)
	:26	dta b($84)
	:1	dta b($04)
	:1   dta b($41),a(dlist)
wait ins 'data\fade_map.dta'
	utils_wait_one_frame

mainend	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	mva #$0 gtictl
	set_vbl vblk
	set_dli dli
	mwa #dlist dlptr
	mva #0 colbak
	mva #0 end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl
	lda #>fnt
	sta chbase

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

cnt	dta a(0)
vblk	.local
	phr
	lda #0
	sta dli.i0+1
	lda #2
	sta dli.i1+1
	lda #4
	sta dli.i2+1
	inw cnt
	cpw #280 cnt
	bne go
	mva #1 end_eff
	restore_nmi
	jmp end
go	lda #1
	beq g1
	dec go+1
	jmp end
g1	jsr process_screen
	inc go+1
end	plr
	rti
.endl

tcol	dta b($10,$20,$30,$40,$50,$60,$70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0,$e0)
		dta b($10,$20,$30,$40,$50,$60,$70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0,$e0)
dli	.local
	sta regA
	stx regX
i0	ldx #0
	lda tcol,x
	ora #2
	sta colpf0
	inc i0+1

i1	ldx #2
	lda tcol,x
	ora #6
	sta colpf1
	inc i1+1
	
i2	ldx #4
	lda tcol,x
	ora #12
	sta colpf2
	inc i2+1
	
	ldx regX
	lda regA
	rti
.endl

process_screen	.local
	ldx #0
l0
.rept 28 #*40
	lda wait+:1,x
	beq e:1
	dec wait+:1,x
e:1
.endr
	inx
	cpx #40
	jne l0
	rts
.endl


.align $400
fnt
	:8 dta b(0)
	ins 'data\fade.fnt',15*8,8
	ins 'data\fade.fnt',14*8,8
	ins 'data\fade.fnt',13*8,8
	ins 'data\fade.fnt',12*8,8
	ins 'data\fade.fnt',11*8,8
	ins 'data\fade.fnt',10*8,8
	ins 'data\fade.fnt',9*8,8
	ins 'data\fade.fnt',8*8,8			
	ins 'data\fade.fnt',7*8,8
	ins 'data\fade.fnt',6*8,8
	ins 'data\fade.fnt',5*8,8
	ins 'data\fade.fnt',4*8,8
	ins 'data\fade.fnt',3*8,8
	ins 'data\fade.fnt',2*8,8			
	ins 'data\fade.fnt',1*8,8
	ins 'data\fade.fnt',0*8,8		
	:8*111 dta b(0)


end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	