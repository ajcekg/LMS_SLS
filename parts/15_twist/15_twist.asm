PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$3000
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
 
main

wait_for_line_nr=82
scr_v_size=36
scr_h_size=40 // bytes
image_h=40

msx_loop_len = 192
font_1_on = msx_loop_len/2
font_2_on = font_1_on + msx_loop_len/2
font_2_off = fx_end - msx_loop_len/2
font_1_off = font_2_off - msx_loop_len/2

fx_end = msx_loop_len*3+msx_loop_len/4+msx_loop_len/32
fade_buffor = 9
flash_time = 5
flash_pre_time = 2

col_bg = $00
col_1 = $82
col_2 = $84
col_3 = $86
col_4 = $88
col_5 = $42
col_6 = $44
col_7 = $46
col_8 = $48
font_col1 = $8a
font_col2 = $4a
font_col_flash1 = $0f
font_col_flash2 = $0f

first_free = $30
frm_cnt = first_free+$0
ang = first_free+$2
amp = first_free+$4
ang_top = first_free+$6
amp_idx = first_free+$8
dli_idx = first_free+$9
chg_dir_done = first_free+$a
tmp_col1 = first_free+$10
tmp_col2 = first_free+$11
tmp_col3 = first_free+$12
tmp_col4 = first_free+$13
tmp_col5 = first_free+$14
tmp_col6 = first_free+$15
tmp_col7 = first_free+$16
tmp_col8 = first_free+$17

init_all    

.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
	set_vbl vblMain
	set_dli dliMain
    mva #%00000000 dmactl
    jsr clear_screen
    jsr wait_one_frame

    mva #0 dli_idx

    lda #col_bg
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
    sta colpf0
    sta colpf1
    sta colpf2
    sta colpf3
    sta colbak   
    lda #col_1&$f0
    sta tmp_col1
    sta tmp_col2
    sta tmp_col3
    sta tmp_col4
    lda #col_5&$f0
    sta tmp_col5
    sta tmp_col6
    sta tmp_col7
    sta tmp_col8
    
    mva #%00100010 dmactl
    mwa #dl dlptr
    mva #%00000000 gtiactl

    mwa #0 ang
    mwa #0 ang_top
    mva #0 amp
    mva #0 amp+1
    mwa #64 amp_idx
    mva #0 chg_dir_done

.if PGENE = 0
waitSyncTwist
    cpw frmcnt #58*msx_loop_len
    bne waitSyncTwist
.endif
    mwa #0 frm_cnt
    
// MAIN
fx_main_loop

    set_font_color font_1_on-flash_pre_time font_col_flash1 _font_col1
    set_font_color font_1_on+flash_time-flash_pre_time font_col1 _font_col1 
    set_font_color font_2_on-flash_pre_time font_col_flash2 _font_col2
    set_font_color font_2_on+flash_time-flash_pre_time font_col2 _font_col2 

    flash_fonts 2*msx_loop_len-flash_pre_time
    flash_fonts 2*msx_loop_len+msx_loop_len/2-flash_pre_time

    fade_out_font_color fx_end-msx_loop_len/4 _font_col1 font_col1&$f0
    fade_out_font_color fx_end-msx_loop_len/8 _font_col2 font_col2&$f0
    
    cpw frm_cnt #fade_buffor
    bcs _no_fade_in
    fade_in 1 colpm1
    fade_in 2 colpm2
    fade_in 3 colpm3
    fade_in 4 colpf0
    fade_in_no_set 5 colpf1
    fade_in_no_set 6 colpf2
    fade_in 7 colpf3
    fade_in_no_set 8 colbak 
_no_fade_in

    cpw frm_cnt #fx_end-fade_buffor
    bcc _no_fade_out
    jsr fade_out_fx
_no_fade_out
    
    mwa ang_top ang

    // dir change
    cpb chg_dir_done #0
    bne _no_change_dir
    cpb amp #0
    bne _no_change_dir
    cpw frm_cnt #msx_loop_len*2
    bcc _no_change_dir
    mva #-1 amp+1
    
    lda amp
    eor #$ff
    clc
    adc #1
    sta amp
    
    clc
    lda amp_idx
    adc #128
    sta amp_idx
 
    lda #$C6
    sta _idx_dir_op
    sta chg_dir_done
_no_change_dir
 
 _idx_dir_op=*
    inc amp_idx
    ldx amp_idx
    lda amp_tab,x
    sta amp
     
    dec ang_top+1
 
_waitForLine
    lda VCOUNT
    cmp #wait_for_line_nr    
    bcc _waitForLine
    
_inner    
    icl 'twist_inner.asm'
    .print "inner size: ",*-_inner

    cpw frm_cnt #fx_end
    bcs _quit
    jmp fx_main_loop

_quit
	jsr wait_one_frame
    lda #col_bg
    sta dmactl
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
    sta colpf0
    sta colpf3
    sta tmp_col5
    sta tmp_col6
    sta tmp_col8
.if PGENE = 0
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif

fade_out_fx
    fade_out 1 colpm1
    fade_out 2 colpm2
    fade_out 3 colpm3
    fade_out 4 colpf0
    fade_out_no_set 5 colpf1
    fade_out_no_set 6 colpf2
    fade_out 7 colpf3
    fade_out_no_set 8 colbak 
    rts

.macro fade_out_font_color 
    cpw frm_cnt #%%1
    bcc _no_set_color
    lda %%2
    cmp #col_bg
    beq _no_set_color
    cmp #%%3
    beq _eq_lum_color
    dec %%2
    jmp _no_set_color
_eq_lum_color
    mva #col_bg %%2
_no_set_color     
.endm

.macro set_font_color 
    cpw frm_cnt #%%1
    bne _no_set_color
    mva #%%2 %%3
_no_set_color     
.endm

.macro set_font_color2 
    cpw frm_cnt #%%1
    bne _no_set_color
    lda #%%2
    sta %%3
    lda #%%4
    sta %%5
_no_set_color     
.endm

.macro flash_fonts
    set_font_color2 %%1 font_col_flash1 _font_col1 font_col_flash2 _font_col2
    set_font_color2 %%1+flash_time font_col1 _font_col1 font_col2 _font_col2
.endm

.macro fade_in 
    cpb tmp_col%%1 #col_%%1
    beq _no_fade_col
    inc tmp_col%%1
    mva tmp_col%%1 %%2
_no_fade_col 
.endm

.macro fade_in_no_set 
    cpb tmp_col%%1 #col_%%1
    beq _no_fade_col
    inc tmp_col%%1
_no_fade_col 
.endm

.macro fade_out 
    lda tmp_col%%1
    cmp #col_bg
    beq _no_fade_col
    cmp #col_%%1&$f0
    beq _last_fade_col
    dec tmp_col%%1
    mva tmp_col%%1 %%2
    jmp _no_fade_col
_last_fade_col    
    lda #col_bg
    sta tmp_col%%1
    sta %%2
_no_fade_col 
.endm

.macro fade_out_no_set
    lda tmp_col%%1
    cmp #col_bg
    beq _no_fade_col
    cmp #col_%%1&$f0
    beq _last_fade_col
    dec tmp_col%%1
    jmp _no_fade_col
_last_fade_col 
    mva #col_bg tmp_col%%1
_no_fade_col 
.endm

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
    	lda dli_idx
    	bne _dli2
    	mva #%10000000 gtiactl
    	mva tmp_col5 colpf1
    	mva tmp_col6 colpf2
    	mva tmp_col8 colbak
    	jmp _dli3
_dli2
    	txa
    	pha
_font_col2 = *+1	
    	ldx #col_bg
        lda #col_bg
        sta wsync
        sta colbak
        sta gtiactl
        sta colpf2
        stx colpf1
        tax
        pla
_dli3
    	inc dli_idx
    	pla
        rti
 
vblMain // VBL!!!
        phr
        lda #col_bg
        sta gtiactl
        sta colpf2
        sta colbak
        sta dli_idx
_font_col1 = *+1
        lda #col_bg
        sta colpf1

        inw frm_cnt
        plr
ret     rti

trans ins '15_go_to_tunnel.obx.bc'

amp_tab
    dta b(sin(127,127,256))

// data
.print "data before align: ",*
    .align 256
.print "data after align: ",*    
    icl 'twist_data.asm'
.print "data after icl: ",*

// DL
.align $400
.print "Start of DL: ",*
dl  
    :5 dta b($70)
    dta b($20)
    dta b($4f),a(image1)
    :image_h-2 dta b($0f)
    dta b($8f)
    dta b($10)
    .rept scr_v_size-1, #
    :2  dta b($4f),a(screen+(:1+1)*scr_h_size)
    .endr
    dta b($cf),a(image2)
    :image_h-1 dta b($0f)

    dta b($41),a(dl)
.print "End of DL: ",*

.print 'image1 address: ', image1
image1
	ins 'data\twist_img.mic',40*5,40*40

.align 4096
.print 'image2 address: ', image2
image2
	ins 'data\twist_img.mic',40*44,40*40

.align 4096
screen
.print 'screen address: ', screen
    org *+scr_v_size*scr_h_size
.print 'after screen address: ', *



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
 

