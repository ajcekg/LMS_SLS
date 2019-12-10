PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$400
RUN_ADDRESS		equ	main

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

data ins "data\gretz.dta_0"

dlist
	:5	 dta b($70)
	:1	 dta b($80)
ee	:1	 dta b($01),a(ww)
	:40	 dta b(0)
ww	:1	 dta b($4f),a(data)
	:63	 dta b($0f)
	:1	 dta b(0)
	:1   dta b($41),a(dlist)

	utils_wait_one_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame
	mva #$0 gtictl
	sta pmcntl
	set_vbl vblk
	set_dli dli
	mwa #dlist dlptr
	mva #0 colbak
	sta colpf2
	sta colpf1
	sta end_eff
	pm_out_of_screen	
	mva #@dmactl(standard|dma) dmactl

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

frmc  dta b(0)

vblk	.local
	phr
w0	lda #40	
	beq aa
	dec w0+1
	jmp eend
aa	lda #$80
	sta dli.c1+1
a	lda #1
	beq go
	dec a+1
	jmp end
go	mva #1 a+1
b	lda #0		
	cmp #10
	beq end
	inc dli.c0+1
	inc b+1
end	inc frmc
	lda frmc
	cmp #220
	bne eend
	set_vbl evblk
eend
	plr
	rti
.endl

evblk	.local
	phr
	dew ee+1
b	ldx #23
	beq eend
	dec b+1
	lda co,x
	sta dli.c0+1
	jmp end
eend
	lda #0
	sta dli.c1+1
	restore_nmi
	mva #1 end_eff
	mva #0 dmactl			
end	plr
	rti
	
co	dta b(0,0,$80,$80,$81,$81,$82,$82,$83,$83,$84,$84,$85,$85,$86,$86,$87,$87,$88,$88,$89,$89,$8a,$8a)	
.endl


dli	.local
	sta regA
c0	lda #0
c1	ora #$00	
	sta colpf1
	lda regA
	rti
.endl



end_part_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	