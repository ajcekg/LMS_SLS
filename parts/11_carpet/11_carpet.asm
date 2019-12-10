PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$2000
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

	utils_wait_one_frame

msx_loop_len = 192
carpet_fx_end = msx_loop_len*4
vertical_move_start = msx_loop_len
carpet_fade_out = carpet_fx_end-6
flash_time = 4

col_br=$00
col_bg=$00
col_px=$06
flash_col_px=$9a
col_pmg1=$26
flash_col_pmg1=$2a

v_size = 239
scr_mode = $5f
offset_tab_size=128

first_free = $30
frm_cnt = first_free+$0
zoom_level = first_free+$2
v_offset = first_free+$4
v_offset_idx = first_free+$6
tmp_color1 = first_free+$8
fade_in_done = first_free+$9
h_offset_b = first_free+$a
h_offset_idx = first_free+$b
spr_anim_idx = first_free+$c
tmp_pmg_color1 = first_free+$d

main
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
    mva #%00000000 dmactl
    jsr wait_one_frame
    set_vbl vblMain

    mva #col_br colbak
    mva #col_bg colpf2
    mva #col_px colpf1

    mwa #dl dlptr	
    mva #%00111110 dmactl
    mva #%00000011 pmcntl
    mva #%00000001 gtictl
    
    mva #0 zoom_level
    mwa #0 v_offset
    mva #0 v_offset_idx
    mva #col_bg tmp_color1
    mva #0 fade_in_done
    mva #0 h_offset_b
    mva #0 h_offset_idx
    mva #col_pmg1&$f0 tmp_pmg_color1
    
.if PGENE = 0
waitSyncCarpet
    cpw frmcnt #42*msx_loop_len
    bne waitSyncCarpet
.endif    

    jsr init_sprites
    mwa #0 frm_cnt

// MAIN
fx_main_loop
    jsr wait_one_frame

    mwa #dl dlptr

    choose_sprites

    flash_carpet_combo 0*msx_loop_len+msx_loop_len/2
    flash_carpet_combo 1*msx_loop_len
    flash_carpet_combo 1*msx_loop_len+msx_loop_len/2
    flash_carpet_combo 2*msx_loop_len
    flash_carpet_combo 2*msx_loop_len+msx_loop_len/2
    flash_carpet_combo 3*msx_loop_len
    flash_carpet_combo 3*msx_loop_len+msx_loop_len/2
    
    cpw frm_cnt #carpet_fade_out
    bcc _no_fade_out
    fade_out 1 col_bg color1
    fade_out_pmg
_no_fade_out
       
    lda fade_in_done
    bne _fade_in_done
    fade_in 1 col_px color1
    fade_in_pmg
_fade_in_done    
    
    mwa #dl_adr_start _v_update_adrL1
    mwa #dl_adr_start+1 _v_update_adrM1    

    ldx h_offset_idx
    inx
    cpx #H_SCR_SIZE
    bne _no_reset_h_scroll
    ldx #0
_no_reset_h_scroll
    stx h_offset_idx   
   
    lda cs_tab,x
    sta h_offset_b
    lda hs_tab,x
    sta HSCROL

    mva h_offset_b _h_offset_b1
    mva h_offset_b _h_offset_b2

    ldx zoom_level
    inx
    cpx #ZOOM_LEVELS
    bne _no_reset_zoom_levels
    ldx #0
_no_reset_zoom_levels    
    stx zoom_level
   
    clc
    lda zoom_levels_lookupLL,x
    sta _v_lookup_L1
    sta _v_lookup_L2
    lda zoom_levels_lookupLM,x
    sta _v_lookup_L1+1
    sta _v_lookup_L2+1    
    lda zoom_levels_lookupML,x
    sta _v_lookup_M1
    sta _v_lookup_M2    
    lda zoom_levels_lookupMM,x
    sta _v_lookup_M1+1
    sta _v_lookup_M2+1

    ldx v_offset_idx
    inx
    cpx #offset_tab_size
    bne _no_reset_offset_tab_idx
    ldx #0	
_no_reset_offset_tab_idx
    stx v_offset_idx    
    lda v_offsets_tab,x
    sta v_offset

    // loop1 
    tay
_v_loop1
    clc
_v_lookup_L1 = * + 1    
    lda $FFFF,y
_h_offset_b1 = * +1
    adc #$FF
_v_update_adrL1 = * +1
    sta $FFFF
_v_lookup_M1 = * +1
    lda $FFFF,y
_v_update_adrM1 = * +1
    sta $FFFF
    
    adw _v_update_adrL1 #3
    adw _v_update_adrM1 #3
    
    iny
    cpy #(data_v_size/2)    
    bne _v_loop1

    mwa _v_update_adrL1 _v_update_adrL2
    mwa _v_update_adrM1 _v_update_adrM2    

    clc
    lda #v_size-(data_v_size/2)
    adc v_offset
    tax
    dey
    
    // loop2 
_v_loop2
    dey
   
    clc
_v_lookup_L2 = * + 1    
    lda $FFFF,y
_h_offset_b2 = * +1
    adc #$FF    
_v_update_adrL2 = * +1
    sta $FFFF
_v_lookup_M2 = * +1
    lda $FFFF,y
_v_update_adrM2 = * +1
    sta $FFFF
    
    adw _v_update_adrL2 #3
    adw _v_update_adrM2 #3
    
    dex
    bne _v_loop2

    cpw frm_cnt #carpet_fx_end
    beq _quit	

    jmp fx_main_loop
    
_quit  
    jsr wait_one_frame
    ldy #%00000000
    sty pmcntl
    lda #0
    sta colbak  
    sta color1 
    sta color2
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3  
.if PGENE = 0
	restore_nmi
	mva #0 dmactl
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif

.macro set_zoom_inc
    cpw frm_cnt #%%1
    bne _no_set_zoom_inc
        mva #%%2 zoom_inc
_no_set_zoom_inc    
.endm

.macro flash_carpet_combo 
    flash_carpet %%1-flash_time flash_col_px flash_col_pmg1
    flash_carpet %%1+flash_time col_px col_pmg1
.endm

.macro flash_carpet
    cpw frm_cnt #%%1
    bne _no_flash
    mva #%%2 color1
    lda #%%3
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
_no_flash    
.endm

.macro fade_in 
    cpb tmp_color%%1 #%%2
    beq _no_fade_col
    inc tmp_color%%1
    mva tmp_color%%1 %%3
    jmp _no_fade_col2
_no_fade_col 
    mva #1 fade_in_done	  
_no_fade_col2    
.endm

.macro fade_in_pmg 
    cpb tmp_pmg_color1 #col_pmg1
    beq _no_fade_col
    inc tmp_pmg_color1
    lda tmp_pmg_color1
    sta colpm0
    sta colpm1
    sta colpm2 
    sta colpm3
_no_fade_col 
.endm

.macro fade_out_pmg 
    cpb tmp_pmg_color1 #col_pmg1&$f0
    beq _no_fade_out_col
    dec tmp_pmg_color1
    lda tmp_pmg_color1
    sta colpm0
    sta colpm1
    sta colpm2 
    sta colpm3
_no_fade_out_col   
.endm

.macro fade_out 
    cpb tmp_color%%1 #%%2
    beq _no_fade_out_col
    dec tmp_color%%1
    mva tmp_color%%1 %%3
_no_fade_out_col   
.endm


vblMain // VBL!!!
        inw frm_cnt
ret     rti

	
// DL
.align $400
.print "Start of DL: ",*
dl  
dl_adr_start = *+1    
    :v_size dta b(scr_mode),a(lineBlank)
    dta b($41),a(dl) 
.print "End of DL: ",*

// dane
v_offsets_tab
   dta b(sin((data_v_size-v_size)/2,(data_v_size-v_size)/2,offset_tab_size))

   icl 'carpet_sprites.asm'
   icl 'carpet_include.asm'

trans ins "11_go_to_budda.obx.bc"

MEM_TOP=$BFFF
.print "End of program: ",*
.print "Memory left: ",MEM_TOP-*
.if *>MEM_TOP
    .error "Out of memory!"
.endif
 
end_part_hand_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	

