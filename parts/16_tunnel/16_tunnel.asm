PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$4000
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

first_free = $30
frm_cnt = first_free+$0
tun_step = first_free+$02
tun_inc = first_free+$04
tun_incidx = first_free+$06
tun_texidx = first_free+$08
anim_loop_step = first_free+$0a
fade_in_step = first_free+$0c
dli_clr_idx = first_free+$0e
texture_clear_idx = first_free+$10

msx_loop_len = 192
direction_change_frame_count = msx_loop_len/2
tunnel_bg_fade_duration = msx_loop_len/2
tunnel_fx_start = msx_loop_len/2
tunnel_fx_fade_out = tunnel_fx_end-35
tunnel_fx_end = 4*msx_loop_len

scr_h_size = 80
scr_v_size = 60
 
main
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
	set_vbl vblMain
	set_dli dliMain
    
    jsr wait_one_frame
    mva #0 dmactl
    
    jsr copy_texture1
    jsr clear_screens

.if PGENE = 0
waitSyncTunnel
    cpw frmcnt #62*msx_loop_len
    bne waitSyncTunnel
.endif

    jsr wait_one_frame
    mwa #dl dlptr
    mva #%10110010 dmactl
    mva #%10000001 gtiactl
    icl 'tunnel9k2_bg_colors.asm'
    mwa #0 frm_cnt
    mwa #0 anim_loop_step
    mwa #0 tun_step
    mwa #0 tun_inc
    mva #0 tun_incidx
    mva #0 tun_texidx
    mwa #0 fade_in_step
    mwa #0 texture_clear_idx

// MAIN
fx_main_loop
    // fade in
    cpw frm_cnt #tunnel_bg_fade_duration
    bcs _after_fade_in
    jsr fade_fx  
_after_fade_in    
  
    // wait for fx  
    cpw frm_cnt #tunnel_fx_start
    bcc fx_main_loop

    cpw frm_cnt #tunnel_fx_fade_out
    bcc _no_fx_fade_out
    jsr clear_texture_part
    jmp _no_copy
_no_fx_fade_out

    // offset anim
    ldx tun_incidx
    lda anim_loop_step
    cmp #direction_change_frame_count-1
    bcc _notun_incChange
    
    lda tun_texidx
    bne tun_texidx2
    jsr copy_texture1
    mva #1 tun_texidx
    jmp tun_texidx_done    
tun_texidx2   
    jsr copy_texture2
    mva #0 tun_texidx
tun_texidx_done
    
    mwa #0 anim_loop_step
    inx
    cpx #4
    bne _notun_incIdxChange
    ldx #0
_notun_incIdxChange    
    stx tun_incidx
_notun_incChange    
    
    lda tun_inc_table,x
    sta tun_inc

_no_copy
    
    lda tun_step
    clc
    adc tun_inc
    sta tun_step
    tax

    jsr render_t

    cpw frm_cnt #tunnel_fx_end
    bcs _quit

    jsr wait_one_frame
    jmp fx_main_loop

_quit
.if PGENE = 0
	jmp $1000-3
.else
	jmp *
.endif

render_t
    icl 'tunnel9k_inner.asm'
    rts

// procedures
clear_texture_part
    ldy texture_clear_idx
    sty _clear_inv_idx
    lda #0
    sec
_clear_inv_idx = *+1    
    sbc #0
    tax
    
    lda #0
    
    .rept 4
    sta texture0_1,y
    sta texture0_1_duplicate,y
    sta texture0_2,y    
    sta texture0_2_duplicate,y    
    sta texture0_1,x
    sta texture0_1_duplicate,x
    sta texture0_2,x   
    sta texture0_2_duplicate,x
    iny
    dex
    .endr
    sty texture_clear_idx    
    rts

copy_texture1
    ldy #0
_copy_texture1_loop    
    lda texture1_1,y
    sta texture0_1,y
    sta texture0_1_duplicate,y
    lda texture1_2,y
    sta texture0_2,y    
    sta texture0_2_duplicate,y    
    iny
    bne _copy_texture1_loop    
    rts
    
copy_texture2
    ldy #0
_copy_texture2_loop    
    lda texture2_1,y
    sta texture0_1,y
    sta texture0_1_duplicate,y
    lda texture2_2,y
    sta texture0_2,y    
    sta texture0_2_duplicate,y    
    iny
    bne _copy_texture2_loop    
    rts    

fade_fx
    icl 'tunnel_fade_9k.asm'
    rts

clear_screens
    mwa #screen clear_screen_tmp_ptr1
clear_inner    
    ldx #scr_v_size
clear_lines_loop
    ldy #0
    lda #0
clear_px_loop    
clear_screen_tmp_ptr1=*+1
    sta $abcd,y

    iny
    cpy #scr_h_size/2
    bne clear_px_loop
    adw clear_screen_tmp_ptr1 #scr_h_size/2
   
    dex
    bne clear_lines_loop   
    rts    

// DL
.align $400
.print "Start of DL: ",*
dl
    icl 'tunnel9k_dli.asm'	
    dta b($41),a(dl) 
 
.print "End of DL: ",*
.print "Len of DL: ",*-dl

dli_clr_table dta b($88,$28,$88,$28)

dliMain
        pha
        txa
        pha
    	ldx dli_clr_idx
    	lda dli_clr_table,x
    	sta WSYNC
        sta colpm2
    	inx
        stx dli_clr_idx
        pla
        tax
        pla
        rti 

vblMain
		pha
        mva #0 dli_clr_idx
        inw frm_cnt
        inw anim_loop_step
        pla
        rti

// dane  
tun_inc_table dta b(-1,-1,1,1)

bg
    ins 'data\tunnel9k2_bg.bg'

    .align $100
texture0_1
    org *+256
texture0_1_duplicate    
    org *+256
texture0_2
    org *+256
texture0_2_duplicate
    org *+256

texture1_1
    ins 'data\tunnel9k2_1_1.tex'
texture1_2
    ins 'data\tunnel9k2_1_2.tex'
texture2_1
    ins 'data\tunnel9k2_2_1.tex'
texture2_2
    ins 'data\tunnel9k2_2_2.tex'

.align 4096
.print "Start of screen: ",*
screen 
   org *+scr_h_size/2*scr_v_size
.print "End of screen: ",*
.print "Len of screen: ",*-screen


end_part_hand_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	


