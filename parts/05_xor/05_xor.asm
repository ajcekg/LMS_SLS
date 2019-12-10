PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$4000
RUN_ADDRESS		equ	start

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
   utils_wait_end_frame
   
first_free = $30
frm_cnt = first_free+$0
pattern1_offset_ptr = first_free+$02
pattern1_offset_idx = first_free+$04
pattern2_offset_ptr = first_free+$06
pattern2_offset_idx = first_free+$08
anim_loop_step = first_free+$0a
dl_color_idx = first_free+$0c
dl_color_prev = first_free+$0d
fx_v_size = first_free+$0e
split_line_idx = first_free+$0f
split_line_val = first_free+$10
split_line_dli_cnt = first_free+$11
split_line_col1 = first_free+$12
split_line_col2 = first_free+$13
tmp_color = first_free+$14

msx_loop_len = 192
show_2 = msx_loop_len/4
show_3 = msx_loop_len/2
split_color_start = msx_loop_len
split_zoom_start = 3*msx_loop_len
xor_end = 5*msx_loop_len+msx_loop_len/2
xor_end_fade_out = xor_end-msx_loop_len

screen_h_size = 16
screen_h_size_full = 16
screen_v_size = 66
screen_add_v_before = 2
screen_add_v_after = 1
split_bar_size = screen_v_size/2
flash_len = 4
bottom_start = 182
bottom_width = 40
bottom_size = 54
xor_vcount_scr_width = 84

pattern_h_size = 24
additional_shift1 = 0
additional_shift2 = 8
pattern2_offset_idx_val = 100

spr_y=40
spr_x=148
spr_h=140
spr_int_max=116

spr_col=$06		// sprite -> po pojawieniu
spr_col_flash=$04	// flash sprite

xor_bottom_col=$06     // bottom -> po pojawieniu
xor_bottom_col_flash=$04   // flash bottom

xor_color_bg_end=$0
xor_color_bg=$0F // tlo + sprite start/end
xor_color0_1=$7C // part 1 -> pojawianie sie z rozjasnieniem step 1
xor_color0_2=$7A // step 2
xor_color0_3=$78 // step 3
xor_color_flash=$06 // flash efektu
xor_color1=$6C // part 2 -> kolor gora
xor_color2=$8A // part 2 -> kolor dol
xor_color3=$78 // part 3 -> kolor gora/dol
xor_color4=$7C // part 3 -> kolor srodek
xor_color5=$16 // part 4 -> kolor srodek
 
start
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2	
	pm_out_of_screen
.endif

    mwa #196 dl_color_idx
    mwa #0 dl_color_prev
    mwa #0 fx_v_size
    mwa #0 split_line_idx
    mva #xor_color3 split_line_col1
    mva #xor_color4 split_line_col2  
    mva #xor_color_bg_end tmp_color
    
    jsr clear_screens  
    jsr spr_xor.clear_sprites
    jsr spr_xor.copy_sprites

    ldx <screen1     
    ldy >screen1     
    stx screen_ptr        
    sty screen_ptr+1

.if PGENE = 0
waitSyncXor
    cpw frmcnt #13*msx_loop_len+msx_loop_len/2-2 // 1 intro + 12 party + 0.5 przejscie 
    bne waitSyncXor
.endif

	jsr wait_end_frame
    jsr spr_xor.setup_sprites
    set_vbl vblk
    set_dli dli

    mwa #dl dlptr
    mva #%10111001 dmactl

    mva #xor_color0_1 colpf0
    lda #xor_color_bg
    sta colbak
    sta colpf1    
    sta colpf2
    sta tmp_color
 
    mwa #0 pattern1_offset_idx
    mwa #pattern2_offset_idx_val pattern2_offset_idx

    mva #xor_color0_1 colpf0
    mva #screen_v_size/3 fx_v_size    
    ldy #%00000011 // sprites on
    sty pmcntl
    mwa #0 frm_cnt
    mwa #0 anim_loop_step

// MAIN
fx_main_loop
    jsr wait_one_frame
    mva #%10111001 dmactl
  
    mva #0 split_line_dli_cnt

    mwa screen_ptr screen_tmp_ptr
    adw screen_tmp_ptr #screen_h_size_full*screen_add_v_before

    lda screen_ptr+1 
    eor #>screen1 ^ >screen2
    sta screen_ptr+1        

    cpw frm_cnt #show_2
    bne _fadeIn2
    mva #xor_color0_2 colpf0
    mva #screen_v_size/3*2 fx_v_size    
_fadeIn2    
    cpw frm_cnt #show_3
    bne _fadeIn3
    mva #screen_v_size fx_v_size    
    mva #xor_color0_3 colpf0
_fadeIn3
    cpw frm_cnt #split_color_start-flash_len/2
    bne _fadeIn4
    mva #xor_color_flash colpf0
    mva #xor_bottom_col_flash colpf1
    lda #spr_col_flash
    jsr spr_xor.setup_sprites_color
_fadeIn4    
    cpw frm_cnt #split_color_start+flash_len/2
    bne _fadeIn5
    mva #xor_bottom_col colpf1
    lda #spr_col
    jsr spr_xor.setup_sprites_color
_fadeIn5    

    mwa #pattern1 pattern1_tmp_ptr
    mwa #pattern1 pattern2_tmp_ptr

    // ---- setup pattern 1 ----
    mwa #pattern1_offsets pattern1_offset_ptr
    adw pattern1_offset_ptr pattern1_offset_idx
    ldy #0 
    adw pattern1_tmp_ptr (pattern1_offset_ptr),y
    adw pattern1_tmp_ptr #additional_shift1

    adw pattern1_offset_idx #2
    cpw pattern1_offset_idx #pattern1_offset_max
    sne
    mwa #0 pattern1_offset_idx

    // ---- setup pattern 2 ----
    mwa #pattern1_offsets pattern2_offset_ptr
    adw pattern2_offset_ptr pattern2_offset_idx
    ldy #0 
    adw pattern2_tmp_ptr (pattern2_offset_ptr),y
    adw pattern2_tmp_ptr #additional_shift2
    
    adw pattern2_offset_idx #2
    cpw pattern2_offset_idx #pattern1_offset_max
    sne
    mwa #0 pattern2_offset_idx

    cpw frm_cnt #split_zoom_start
    bcs _do_split_zoom

    // dl color changes
    cpw frm_cnt #split_color_start
    bcc _after_dl_color_changes

    ldx dl_color_prev
    lda #$b
    sta dl_lines_start,x

    mva #xor_color1 colpf0
    cpw frm_cnt #split_zoom_start-flash_len/2
    bcc _colorChg1
    mva #xor_color_flash colpf0
    mva #xor_bottom_col_flash colpf1
    lda #spr_col_flash
    jsr spr_xor.setup_sprites_color
    spr_xor.sprites_above
    
_colorChg1

    inc dl_color_idx   
    ldx dl_color_idx
    lda dl_color_offsets,x      
    sta dl_color_prev
    tax
    lda #$8b
    sta dl_lines_start,x    
_after_dl_color_changes    

    ldx fx_v_size
    jsr render_xor
    jmp fx_main_loop    

    // split zoom
_do_split_zoom

    cpw frm_cnt #split_zoom_start+flash_len/2
    bne _colorChg2
    mva #xor_bottom_col colpf1
    lda #spr_col
    jsr spr_xor.setup_sprites_color
_colorChg2

    spr_xor.sprites_above

    cpw frm_cnt #xor_end-flash_len*2
    bcc _not_end_fade
    dec split_line_col2
_not_end_fade     


    cpw frm_cnt #xor_end
    bcc _not_end
    mva #xor_color_bg_end colpf0
    mva #xor_color_bg_end colbak
    mva #xor_color_bg_end colpf2
    mva #xor_color_bg_end colpf1
    lda #xor_color_bg_end
    jsr spr_xor.setup_sprites_color
    ldy #%00000000 // sprites off yet
    sty pmcntl
    sta dmactl      
.if PGENE = 0
	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $300
.else
	jmp *
.endif	
_not_end     
   
    cpw frm_cnt #xor_end_fade_out-flash_len*2
    bcc _no_bg_fade_out
    lda tmp_color
    cmp #xor_color_bg_end
    beq _no_bg_fade_out
    sec
    sbc #1
    sta colbak
    sta colpf1
    sta colpf2
    sta tmp_color
_no_bg_fade_out   
   
    cpw frm_cnt #xor_end_fade_out
    bne _not_end_fade_out
    lda #1
    sta _split_adc1
    lda #split_bar_size-2
    sta _split_adc2
    sta _split_adc3    
    mva #xor_color_bg_end colbak
    mva #xor_color_bg_end colpf1
    mva #xor_color_bg_end colpf2
    mva #xor_color_bg_end split_line_col1
    mva #xor_color5 split_line_col2
    lda #xor_color_bg_end
    jsr spr_xor.setup_sprites_color
    spr_xor.switch_sprites
    spr_xor.sprites_above    
_not_end_fade_out   
  
    mva split_line_col1 colpf0

    // handle dli updates
    ldx dl_color_prev
    lda #$b
    sta dl_lines_start,x
    
    cpw frm_cnt #split_zoom_start
    beq _no_second_dli_update
    clc
    txa
_split_adc2 = * + 1    
    adc #split_bar_size-0 // 2 
    tax
    lda #$b
    sta dl_lines_start,x
_no_second_dli_update

    inc split_line_idx
    ldx split_line_idx
    lda split_color_offsets,x
    sta split_line_val
    clc
_split_adc1 = * + 1
    adc #0 // 1
    sta dl_color_prev
    tax
    lda #$8b
    sta dl_lines_start,x
    clc
    txa
_split_adc3 = * + 1    
    adc #split_bar_size-0 // 2
    tax
    lda #$8b
    sta dl_lines_start,x

    ldx split_line_val
    jsr render_xor
    
    adb pattern1_tmp_ptr+1 #$20
    adb pattern2_tmp_ptr+1 #$20
    
    ldx #split_bar_size
    jsr render_xor

    sbb pattern1_tmp_ptr+1 #$20
    sbb pattern2_tmp_ptr+1 #$20

    sec
    lda #screen_v_size
    sbc split_line_val
    sbc #split_bar_size
    tax
    jsr render_xor
    
    jmp fx_main_loop

render_xor
    jmp fx_lines_loop
    .align
fx_lines_loop
    ldy #screen_h_size-1
    clc
fx_px_loop    
pattern1_tmp_ptr=*+1
    lda $aaaa,y
pattern2_tmp_ptr=*+1
    eor $aaaa,y
screen_tmp_ptr=*+1
    sta $aaaa,y

    dey
    bpl fx_px_loop
   
    adw pattern1_tmp_ptr #pattern_h_size
    adw pattern2_tmp_ptr #pattern_h_size        
    adw screen_tmp_ptr #screen_h_size_full    
   
    dex
    bne fx_lines_loop   
.if fx_px_loop/$100<>*/$100
    .error "Whole loop should fit in one page due to 'bne' speed"
.endif
    rts

clear_screens
    mwa #screen1 clear_screen_tmp_ptr1
    mwa #screen2 clear_screen_tmp_ptr2
    
    ldx #screen_v_size+screen_add_v_before+screen_add_v_after
clear_lines_loop
    ldy #0
    lda #0
clear_px_loop    
clear_screen_tmp_ptr1=*+1
    sta $abcd,y
clear_screen_tmp_ptr2=*+1
    sta $abcd,y

    iny
    cpy #screen_h_size
    bne clear_px_loop
    adw clear_screen_tmp_ptr1 #screen_h_size
    adw clear_screen_tmp_ptr2 #screen_h_size 
   
    dex
    bne clear_lines_loop   
    rts  

// DL
.align $400
.print "Start of DL: ",*
dl  dta b($70,$70,$70)
    screen_ptr equ *+1
    dta b($4b),a(0)
dl_lines_start
    :screen_v_size-1+3 dta b($b)
    dta b($70,$80)
    dta b($4f),a(bottom)
    :bottom_size-1 dta b($f)
    dta b($41),a(dl) 
.print "End of DL: ",*

dli	.local
        pha
        // handle bottom dli
        lda VCOUNT
        cmp #xor_vcount_scr_width
        bcc _fx_dli
        lda #%10111010
        sta wsync
        sta dmactl
        jmp _dli_end
        // handle fx dli
_fx_dli
        cpw frm_cnt #xor_end-flash_len        
        bcs _colorChgDli3
        cpw frm_cnt #split_zoom_start-flash_len
        bcs _colorChgDli
        lda #xor_color2
        sta wsync
        sta colpf0
        jmp _colorChgDli3       
_colorChgDli
        cpw frm_cnt #split_zoom_start
        bcc _colorChgDli3
        cpb split_line_dli_cnt #0
        bne _colorChgDli2
        lda split_line_col2
        sta wsync
        sta colpf0
        inc split_line_dli_cnt
        cpw frm_cnt #xor_end_fade_out
        bcs _colorChgDli3
        spr_xor.sprites_below      
        jmp _colorChgDli3       
_colorChgDli2
        lda split_line_col1
        sta wsync
        sta colpf0
        spr_xor.sprites_above        
_colorChgDli3
_dli_end
        pla
        rti
.endl

vblk	.local 
 		inw frm_cnt
        inw anim_loop_step
        rti
.endl


// dane    
    icl 'xor_offsets.asm'
    icl 'xor_dl_color_offsets.asm'
    icl 'xor_split_offsets.asm'

    .align $100
sprite0
    ins 'data\xor_spr.pl0'
sprite1
    ins 'data\xor_spr.pl1'
sprite2
    ins 'data\xor_spr.pl2'
sprite3
    ins 'data\xor_spr.pl3' 
sprite4
    ins 'data\xor_spr.pl4' 

.align $800
sprites=*
.print "Start of sprites: ",*
    org sprites+2048
.print "End of sprites: ",*

    icl 'xor_sprites.asm'
    
.align $1000
pattern1
.print "Start of pattern1: ",*
    ins 'data\xor.dat'
.align $1000
.print "Start of pattern2: ",*
pattern2
    ins 'data\xor2.dat'

bottom
    ins 'data\bottom.mic',bottom_start*bottom_width,bottom_width*bottom_size

.align 4096
screen1
.print "Start of screen1: ",*
    org *+2048
screen2
.print "Start of screen2: ",*
    org *+2048

trans ins '05_go_to_sinscroll.obx.bc'

.if PGENE = 1
	run RUN_ADDRESS
.endif	