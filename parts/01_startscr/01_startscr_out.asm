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

	utils_wait_end_frame
	utils_wait_x_frame
	utils_wait_one_frame

///////////////////////////////////////////////////////////////////////////////

dlend
	:4 dta b(0)
d0	:1 dta b($01),a(dln)
dln	:40 dta b(0)
	:01 dta b($4e),a(pic_data)
	:63 dta b($0e)
	:01	dta b($41),a(dlend)

pic_data ins "data\sl_yellow.dta_0"
	
main	.local

.if PGENE = 1
	jsr rom_off
.else
;	lda end_eff
;	bne *-2
.endif
	lda #0
	sta end_eff
	jsr wait_one_frame
	pm_out_of_screen
	mva #$2c colpf0
	mva #$1e colpf1
	restore_nmi
	mwa #dlend dlptr
	set_vbl vblk
.if PGENE = 0	
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif
.endl

vblk	.local
	phr
v0	ldx #39
	bmi end
	inc d0+1
	dec v0+1
	plr
	rti
end	restore_nmi
	mva #1 end_eff
	plr
	rti
.endl

end_mem_end
///////////////////////////////////////////////////////////////////////////////

.if PGENE = 1
	run RUN_ADDRESS
.endif	
