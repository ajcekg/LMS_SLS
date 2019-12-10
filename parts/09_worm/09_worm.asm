PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$4000
RUN_ADDRESS		equ	start

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
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif
trans ins "09_go_to_logos.obx.bc"
	utils_wait_one_frame
	utils_wait_end_frame
first_free = $30
frm_cnt = first_free+$0
tun_step = first_free+$02
tun_inc = first_free+$04
tun_incidx = first_free+$06
tun_texidx = first_free+$07
anim_loop_step = first_free+$08
vscroll_step = first_free+$0a
vscroll_tmp= first_free+$0c
texture_copy_idx = first_free+$0f
texture_copy_done = first_free+$10
vscroll_out_step_idx = first_free+$12

scr_h_size = 80
scr_v_size = 60

msx_loop_len = 192
direction_change_frame_count = msx_loop_len
vscroll_steps = msx_loop_len/2
vscroll_out_start = msx_loop_len*5
vscroll_out_end = vscroll_out_start + vscroll_steps
worm_fx_end = vscroll_out_end+1

start
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
    mwa #0 tun_step
    mwa #0 tun_inc
    mva #0 tun_incidx
    mva #0 tun_texidx
    mwa #0 texture_copy_idx
    mwa #0 texture_copy_done
    mwa #0 vscroll_out_step_idx
    
    jsr wait_one_frame
    mva #0 dmactl
    lda #$00\ sta colpf0
    lda #$00\ sta colpf1
    lda #$00\ sta colpf2
    lda #$00\ sta colbak
    
    jsr clear_texture
    jsr clear_screens
    jsr copy_bg
    jsr wait_one_frame
    mva #%10000001 gtiactl
    jsr colors2

.if PGENE = 0
waitSyncWorm
    cpw frmcnt #34*msx_loop_len
    bne waitSyncWorm
.endif

    mwa #dl dlptr
    mva #%10110010 dmactl
    
    mwa #0 frm_cnt
    mwa #0 anim_loop_step
    mwa #0 vscroll_step    
	set_vbl vblMain
// MAIN
fx_main_loop
    
    // wait for fx  
    cpw frm_cnt #vscroll_steps*2
    bcc fx_main_loop

    // fx
    lda texture_copy_done
    bne _texture_copy_done1
    jsr copy_texture_part
_texture_copy_done1    

    ldx tun_incidx
    lda anim_loop_step
    cmp #direction_change_frame_count-1
    bcc _notun_incChange
    
    lda tun_texidx
    bne tun_texidx2
 
    lda texture_copy_done
    beq _texture_copy_done2	    
    jsr copy_texture1
_texture_copy_done2    
    jsr colors2
    mva #1 tun_texidx
    jmp tun_texidx_done    
tun_texidx2   
    jsr copy_texture2
    mva #1 texture_copy_done
    jsr colors1
    mva #0 tun_texidx
tun_texidx_done
    
    mwa #0 anim_loop_step
    inx
    cpx #3
    bne _notun_incIdxChange
    ldx #0
_notun_incIdxChange    
    stx tun_incidx
_notun_incChange    
    
    lda tun_inc_table,x
    sta tun_inc
    
    lda tun_step
    clc
    adc tun_inc
    sta tun_step
    tax
    
    icl 'worm9k_inner.asm'

    cpw frm_cnt #worm_fx_end
    bcs end_part

    jmp fx_main_loop

end_part
.if PGENE = 0
	restore_nmi
	jsr wait_one_frame
	lda #0
	sta colbak
	sta colpf0
	sta colpf1
	sta colpf2
	sta colpf3
	sta gtictl
	sta dmactl
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif

// procedures
colors1
    icl 'worm9k_bg_colors.asm'
    rts
    
colors2
    icl 'worm9k_bg2_colors.asm'
    rts

copy_texture_part
    ldy texture_copy_idx
    ldx #4
copy_texture_part_loop    
    lda texture1_1,y
    sta texture0_1,y
    sta texture0_1_duplicate,y
    lda texture1_2,y
    sta texture0_2,y    
    sta texture0_2_duplicate,y    
    iny
    dex
    bne copy_texture_part_loop    
    sty texture_copy_idx    
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

copy_bg
    mwa #screen copy_screen_tmp_ptr
    mwa #bg copy_bg_tmp_ptr
    
    ldx #scr_v_size
copy_lines_loop
    ldy #0
copy_px_loop    
copy_bg_tmp_ptr=*+1
    lda $abcd,y
copy_screen_tmp_ptr=*+1
    sta $abcd,y
    iny
    cpy #scr_h_size/2
    bne copy_px_loop
    adw copy_screen_tmp_ptr #scr_h_size/2
    adw copy_bg_tmp_ptr #scr_h_size/2 
   
    dex
    bne copy_lines_loop   
    rts    

clear_screens
    mwa #screen_after clear_screen_tmp_ptr2
    
    ldx #scr_v_size
clear_lines_loop
    ldy #0
    lda #0
clear_px_loop    
clear_screen_tmp_ptr2=*+1
    sta $abcd,y

    iny
    cpy #scr_h_size/2
    bne clear_px_loop
    adw clear_screen_tmp_ptr2 #scr_h_size/2 
   
    dex
    bne clear_lines_loop   
    rts    

scroll_out    
    sec
    lda #vscroll_steps
    sbc vscroll_out_step_idx
    asl
    tax
    jmp scroll_fx

scroll_in
    lda frm_cnt
    asl
    tax

scroll_fx    
    mwa vscroll_offsets1,x vscroll_step
    mwa #screen_after vscroll_tmp
    sbw vscroll_tmp vscroll_step
   
    .rept scr_v_size-1 #
    mwa vscroll_tmp dl+1+0*3+:1*12
    mwa vscroll_tmp dl+1+1*3+:1*12
    mwa vscroll_tmp dl+1+2*3+:1*12
    mwa vscroll_tmp dl+1+3*3+:1*12
    adw vscroll_tmp #scr_h_size/2   
    .endr     
    mwa vscroll_tmp dl+1+0*3+(scr_v_size-1)*12
    mwa vscroll_tmp dl+1+1*3+(scr_v_size-1)*12
    mwa vscroll_tmp dl+1+2*3+(scr_v_size-1)*12

    rts

clear_texture
    ldy #0
    lda #0
_clear_texture_loop    
    sta texture0_1,y
    sta texture0_1_duplicate,y
    sta texture0_2,y    
    sta texture0_2_duplicate,y    
    iny
    bne _clear_texture_loop    
    rts

vblMain
    phr
    // vscroll in
    cpw frm_cnt #vscroll_steps
    bcs _no_vscroll_in
    jsr scroll_in
_no_vscroll_in

    // vscroll out
    cpw frm_cnt #vscroll_out_start
    bcc _no_vscroll_out
    cpw frm_cnt #vscroll_out_end
    bcs _no_vscroll_out
    inc vscroll_out_step_idx
    jsr scroll_out
_no_vscroll_out

    inw frm_cnt
    inw anim_loop_step

    plr
    rti

// DL
.align $400
.print "Start of DL: ",*
dl
    .rept scr_v_size-1, #
    :4  dta b($4f),a(blankLine)
    .endr
    :3  dta b($4f),a(blankLine)
    dta b($41),a(dl) 
.print "End of DL: ",*

blankLine :40 dta b(0)

// dane  
tun_inc_table dta b(17,-17,1)
	icl 'worm_vscroll_offsets.asm'

bg
    ins 'data\worm9k_bg.bg'

texture0_1
    org *+256
texture0_1_duplicate    
    org *+256
texture0_2
    org *+256
texture0_2_duplicate
    org *+256

texture1_1
    ins 'data\worm9k1_1.tex'
texture1_2
    ins 'data\worm9k1_2.tex'
texture2_1
    ins 'data\worm9k2_1.tex'
texture2_2
    ins 'data\worm9k2_2.tex'
.print "after textures: ",*

    org *+1024 // guarantess free space before
.align 1024
    org *+scr_h_size/2*scr_v_size
.print "screen: ",*
screen
    org *+scr_h_size/2*scr_v_size
.print "screen_after: ",*
screen_after

end_part_hand_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	
