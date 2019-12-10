PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$1000
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

	    
scr_h_size=32 // bytes
scr_v_size=96
data_size = 16

bg_col=$00

msx_loop_len = 192
fx_end = msx_loop_len*3+msx_loop_len/4

first_free = $30
frm_cnt = first_free+$0
data_idx = first_free+$2
spr_anim_idx0 = first_free+$3
spr_anim_idx1 = first_free+$4
spr_anim_idx2 = first_free+$5
spr_anim_idx3 = first_free+$6
spr_anim_idx4 = first_free+$7
spr_anim_idx5 = first_free+$8

dir_chg_done = first_free+$a
dli_idx = first_free+$b
fade_in_done = first_free+$c


main
init_all    
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif

init_fx
	set_vbl vblMain
	set_dli dliMain
    mva #%00000000 dmactl
    jsr clear_screen
    jsr wait_one_frame

    lda #$cf
    sta dl_adr_start+3*(35)
    sta dl_adr_start+3*(65)
    sta dl_adr_start+3*(95)
    sta dl_adr_start+3*(125)
    sta dl_adr_start+3*(155)

    mwa #dl dlptr	
    mva #bg_col colbak

    jsr init_sprites
    
    mva #%00111101 dmactl
    mva #%00000011 pmcntl
    mva #%01100001 gtiactl
    
    mva #0 data_idx
    mva #0 dir_chg_done
    mva #0 fade_in_done

.if PGENE = 0
waitSyncBox
    cpw frmcnt #54*msx_loop_len
    bne waitSyncBox
.endif
    mwa #0 frm_cnt
    
// MAIN
fx_main_loop
    
    // data anim
    ldx data_idx
data_inc_dec = *
    inx
    bmi _minus_reset_data_idx
    cpx #data_size
    bne _no_reset_data_idx
    ldx #0
    jmp _no_reset_data_idx
_minus_reset_data_idx 
    ldx #data_size-1
_no_reset_data_idx    
    stx data_idx
    
    icl 'boxes_inner.asm'
    
    cpw frm_cnt #fx_end
    bcs _quit
    jmp fx_main_loop

_quit
    jsr wait_one_frame
    mva #%00000000 pmcntl
    sta dmactl
    sta colbak
    jsr clear_screen
.if PGENE = 0
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif

clear_screen
    mwa #screen clear_screen_tmp_ptr
    
    ldx #scr_v_size
clear_lines_loop
    ldy #0
    lda #0
clear_px_loop    
clear_screen_tmp_ptr=*+1
    sta $abcd,y

    iny
    cpy #scr_h_size
    bne clear_px_loop
    adw clear_screen_tmp_ptr #scr_h_size 
   
    dex
    bne clear_lines_loop   
    rts    


dliMain
        pha
        txa
        pha
        set_spr_colors_anim
        pla
        tax
        pla
        rti
 
vblMain // VBL!!!
        phr
        fade_in_box 0*msx_loop_len/8 5
        fade_in_box 1*msx_loop_len/8 4
        fade_in_box 2*msx_loop_len/8 3
        fade_in_box 3*msx_loop_len/8 2
        fade_in_box 4*msx_loop_len/8 1
        fade_in_box 5*msx_loop_len/8 0  

	    copy_data 6*msx_loop_len/8 2
	    copy_data 7*msx_loop_len/8 1
 
 	    copy_data fx_end-8*msx_loop_len/8 2
 	    clear_data fx_end-7*msx_loop_len/8
 	
        fade_out_box fx_end-6*msx_loop_len/8 0
        fade_out_box fx_end-5*msx_loop_len/8 1
        fade_out_box fx_end-4*msx_loop_len/8 2
        fade_out_box fx_end-3*msx_loop_len/8 3
        fade_out_box fx_end-2*msx_loop_len/8 4
        fade_out_box fx_end-1*msx_loop_len/8 5        

        mva #0 dli_idx
        set_spr_colors_anim
        
        cpw frm_cnt #7*msx_loop_len/8
        bcs _no_rest_spr_anim
        setup_anim_idxs
_no_rest_spr_anim
        
        inw frm_cnt
        plr
ret     rti

.macro fade_out_box
    cpw frm_cnt #%%1
    bne _no_fade_in_box
    lda #bg_col
    sta spr_colors_tab1+%%2
    sta spr_colors_tab2+%%2    
_no_fade_in_box    
.endm

.macro fade_in_box
    cpw frm_cnt #%%1
    bne _no_fade_in_box
    lda spr_colors_tab_src1+%%2
    sta spr_colors_tab1+%%2
    lda spr_colors_tab_src2+%%2
    sta spr_colors_tab2+%%2    
_no_fade_in_box    
.endm

.macro clear_data
	cpw frm_cnt #%%1
	bne _no_clean_data
	lda #0
	ldx #32-1
_clean_data_loop
	sta data1,x
	sta data2,x
	dex
	bpl _clean_data_loop
_no_clean_data		
.endm

.macro copy_data
	cpw frm_cnt #%%1
	bne _no_copy_data
	ldx #32-1
_cpy_data_loop
	lda data%%2_1,x
	sta data1,x
	lda data%%2_2,x
	sta data2,x
	dex
	bpl _cpy_data_loop
_no_copy_data		
.endm

data1
	:32 dta b($0)
data2
	:32 dta b($0)

spr_colors_tab_src1
        dta b($38,$58,$78,$98,$b8,$d8)
spr_colors_tab_src2        
        dta b($14,$34,$54,$84,$94,$B4)        
        
spr_colors_tab1
        :6 dta b(bg_col)
spr_colors_tab2
        :6 dta b(bg_col)

trans ins '14_go_to_twist.obx.bc'
        
// DL
.align $400
.print "Start of DL: ",*
dl  
    dta b($70,$70,$70)
dl_adr_start    
    .rept scr_v_size, #
    :2  dta b($4f),a(screen+:1*scr_h_size)
    .endr

    dta b($41),a(dl)
.print "End of DL: ",*

// DANE
    icl 'boxes_data.asm'

    icl 'boxes_sprites.asm'


.align 2048
screen
.print 'screen address: ', screen

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
