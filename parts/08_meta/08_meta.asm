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

	utils_wait_one_frame
 
start

bg_col=$22
char_start_end_col=$12 // taka sama jasnosc jak tlo
char_col0=$16
char_col1=$1a
char_col2=$1e
flash_char_col2=$7e

spr_col1=$3a
spr_col2=$7c


v_size = 29
h_size = 40

sprite_size=1
spr_x=250
spr_h=13
spr_y_1=52*2
spr_y_2=67*2
spr_pos_target1 = 135
spr_pos_target2 = 115

msx_loop_len = 192
meta_fx_end = msx_loop_len*4
meta_fade_out = meta_fx_end-15
flash_time = 2


first_free = $30
frm_cnt = first_free+$0

pattern1_offset_ptr = first_free+$02
pattern1_offset_idx = first_free+$04
pattern2_offset_ptr = first_free+$06
pattern2_offset_idx = first_free+$08
pattern3_offset_ptr = first_free+$0a
pattern3_offset_idx = first_free+$0c

sprite_x = first_free+$20
sprite_y = first_free+$22
sprite_h = first_free+$24
sprite_col = first_free+$26
sprite_ptr = first_free+$28

sprite_tab_idx1 = first_free+$2a

tmp_color0 = first_free+$2b
tmp_color1 = first_free+$2c
tmp_color2 = first_free+$2d
tmp_color_bg = first_free+$2e
fade_in_done = first_free+$2f

init_fx
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
    mva #%00000000 dmactl
    jsr clean_up

    mva #>my_charset chbase
    mwa #dl dlptr	

    //mva #0 colbak
    mva #char_start_end_col color0    
    mva #char_start_end_col color1
    mva #char_start_end_col color2

    jsr clear_sprites
    mwa #spr_x sprite_x
    mwa #spr_col1 sprite_col
    mwa #spr_h sprite_h

    mwa #spr_y_1 sprite_y 
    mwa #sprite1 sprite_ptr
    jsr copy_sprites1
    mwa #spr_y_2 sprite_y 
    mwa #sprite2 sprite_ptr
    jsr copy_sprites2

    jsr setup_sprites
    jsr sprites_on
    
    mva #char_start_end_col tmp_color0
    mva #char_start_end_col tmp_color1
    mva #char_start_end_col tmp_color2
    //mva #bg_col&$f0 tmp_color_bg    
    mva #0 fade_in_done

.if PGENE = 0
waitSyncMeta
    cpw frmcnt #30*msx_loop_len-msx_loop_len/2
    bne waitSyncMeta
.endif

    set_vbl vblMain
    set_dli dliMain

    mwa #0 frm_cnt
    
    ldx <screen1     
    ldy >screen1     
    stx screen_ptr        
    sty screen_ptr+1

    mva #%00111010 dmactl

    mwa #100 pattern1_offset_idx
    mwa #30 pattern2_offset_idx
    mwa #80 pattern3_offset_idx    

    mva #0 sprite_tab_idx1

// MAIN
fx_main_loop
    lda screen_ptr+1 
    eor #>screen1 ^ >screen2
    sta screen_ptr+1    

    // ---- setup pattern 1 ----
    mwa #pattern pattern1_tmp_ptr
    mwa #pattern1_offsets pattern1_offset_ptr
    adw pattern1_offset_ptr pattern1_offset_idx
    ldy #0 
    adw pattern1_tmp_ptr (pattern1_offset_ptr),y
    
    adw pattern1_offset_idx #2
    cpw pattern1_offset_idx #pattern1_offset_max
    sne
    mwa #0 pattern1_offset_idx

    // ---- setup pattern 2 ----
    
    mwa #pattern pattern2_tmp_ptr
    mwa #pattern2_offsets pattern2_offset_ptr
    adw pattern2_offset_ptr pattern2_offset_idx
    ldy #0 
    adw pattern2_tmp_ptr (pattern2_offset_ptr),y
    
    adw pattern2_offset_idx #2
    cpw pattern2_offset_idx #pattern2_offset_max
    sne
    mwa #0 pattern2_offset_idx

    // ---- setup pattern 3 ----
    
    mwa #pattern pattern3_tmp_ptr
    mwa #pattern3_offsets pattern3_offset_ptr
    adw pattern3_offset_ptr pattern3_offset_idx
    ldy #0 
    adw pattern3_tmp_ptr (pattern3_offset_ptr),y
    
    adw pattern3_offset_idx #2
    cpw pattern3_offset_idx #pattern3_offset_max
    sne
    mwa #0 pattern3_offset_idx

    // ---- setup screen ----
    mwa screen_ptr screen_tmp_ptr
    
    ldx #v_size
    jmp fx_lines_loop
    
    .align
fx_lines_loop
    ldy #h_size-1
    clc
fx_px_loop    
pattern1_tmp_ptr=*+1
    lda $abcd,y
pattern2_tmp_ptr=*+1
    adc $abcd,y
pattern3_tmp_ptr=*+1
    adc $abcd,y    
screen_tmp_ptr=*+1
    sta $abcd,y

    dey
    bpl fx_px_loop
    
.if fx_px_loop/$100<>*/$100
    .error "Whole loop should fit in one page due to 'bne' speed"
.endif
    
    adw pattern1_tmp_ptr #pattern_h_size
    adw pattern2_tmp_ptr #pattern_h_size
    adw pattern3_tmp_ptr #pattern_h_size            
    adw screen_tmp_ptr #h_size    
   
    dex
    bne fx_lines_loop   

    cpw frm_cnt #meta_fx_end
    bcs _quit
    jmp fx_main_loop

_quit
    lda #bg_col
    sta colbak
    sta color0
    sta color1
    sta color2
    jsr sprites_off
    
    .rept 5
    jsr wait_one_frame
    .endr
.if PGENE = 0    
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif	


clean_up
    mwa #screen1 clr_screen1_tmp_ptr
    mwa #screen2 clr_screen2_tmp_ptr    
    
    ldx #v_size
clr_lines_loop
    ldy #0
    lda #0
clr_px_loop    
clr_screen1_tmp_ptr=*+1
    sta $abcd,y
clr_screen2_tmp_ptr=*+1
    sta $abcd,y
    iny
    cpy #h_size
    bne clr_px_loop
    adw clr_screen1_tmp_ptr #h_size    
    adw clr_screen2_tmp_ptr #h_size
   
    dex
    bne clr_lines_loop   
    rts

// dane
pattern
	icl 'meta_pattern.asm'
pattern_h_size = 80

pattern1_offsets
	icl 'meta_offsets1.asm'
pattern2_offsets
	icl 'meta_offsets2.asm'
pattern3_offsets
    icl 'meta_offsets3.asm'	

.align $400
my_charset
    ins 'data\meta2.fnt', 0, 65*8

// sprites
    .align $800
sprites1=*
.print "Start of sprites1: ",*
    org sprites1+2048
.print "End of sprites1: ",*
    .align $800
sprites2=*
.print "Start of sprites2: ",*
    org sprites2+2048
.print "End of sprites2: ",*

sprite1
    ins 'data\spr1.spr'
sprite2
    ins 'data\spr2.spr'    
sprite3
    ins 'data\spr3.spr'
sprite4
    ins 'data\spr4.spr'  
sprite5
    ins 'data\spr5.spr'
sprite6
    ins 'data\spr6.spr'    
sprite7
    ins 'data\spr7.spr'
sprite8
    ins 'data\spr8.spr'  


    icl 'sprites_common.asm'

spr_time=msx_loop_len/2
spr_max=249

spr_pos_tab1
    dta b(sin(0,spr_pos_target1,4*spr_time,0,spr_time))
    :spr_time/4 dta b(spr_pos_target1)
    dta b(sin(spr_max,spr_max-spr_pos_target1,4*spr_time/2,3*spr_time/2,4*spr_time/2))
    :spr_time/4 dta b(spr_max)

spr_pos_tab2
    :spr_time/4 dta b(spr_max)
    dta b(sin(spr_max,spr_max-spr_pos_target2,4*spr_time,2*spr_time,3*spr_time))
    :spr_time/4 dta b(spr_pos_target2)
    dta b(sin(0,spr_pos_target2,4*spr_time/2,1*spr_time/2,2*spr_time/2))

// DL
.align $400
.print "Start of DL: ",*
dl  
    dta b($30)
    screen_ptr equ *+1
    dta b($44),a($0000)
    :(v_size-2)/2 dta b($4)
    dta b($84)
    :(v_size-1)/2 dta b($4)    
    dta b($41),a(dl) 
.print "End of DL: ",*

.align 2048
screen1
.print 'screen address: ', screen1
 org screen1+v_size*h_size

.align 2048
screen2
  org screen2+v_size*h_size
.print 'screen address: ', screen2

.macro flash_char
    cpw frm_cnt #%%1
    bne _no_flash
    mva #%%2 color2
_no_flash    
.endm

.macro animate_sprite
        lda #spr_col%%1
        setup_sprites_color_m
        setup_sprites_base %%1
        ldx sprite_tab_idx1
        lda spr_pos_tab%%1,x
        setup_sprites_pos
.endm

.macro fade_in 
    cpb tmp_color%%1 #%%2
    beq _no_fade_col
    inc tmp_color%%1
    mva tmp_color%%1 %%3
_no_fade_col   
.endm

.macro fade_out 
    cpb tmp_color%%1 #char_start_end_col
    beq _no_fade_out_col
    dec tmp_color%%1
    mva tmp_color%%1 %%3
    jmp _no_fade_out_col2   
_no_fade_out_col  
    mva #bg_col %%3
_no_fade_out_col2 
.endm

.macro copy_sprite_if %%1 %%2 %%3
        cpw frm_cnt %%1
        bne _no_copy_sprite
        mwa #spr_y_%%2 sprite_y 
        mwa #sprite%%3 sprite_ptr
        jsr copy_sprites%%2
_no_copy_sprite     
.endm

dliMain
        phr
        animate_sprite 2        
        plr
        rti
 
vblMain
        phr
       
        flash_char 2*msx_loop_len-flash_time flash_char_col2
        flash_char 2*msx_loop_len+flash_time char_col2 
        flash_char 2*msx_loop_len+msx_loop_len/2-flash_time flash_char_col2
        flash_char 2*msx_loop_len+msx_loop_len/2+flash_time char_col2 
        flash_char 3*msx_loop_len-flash_time flash_char_col2
        flash_char 3*msx_loop_len+flash_time char_col2 
        flash_char 3*msx_loop_len+msx_loop_len/2-flash_time flash_char_col2
        flash_char 3*msx_loop_len+msx_loop_len/2+flash_time char_col2 
       
        cpw frm_cnt #meta_fade_out
        bcc _no_fade_out
        fade_out 0 char_col0 color0
        fade_out 1 char_col1 color1
        fade_out 2 char_col2 color2
_no_fade_out
       
        lda fade_in_done
        bne _fade_in_done
        fade_in 0 char_col0 color0
        fade_in 1 char_col1 color1
        fade_in 2 char_col2 color2
_fade_in_done
        
        inw frm_cnt
        inc sprite_tab_idx1

    	copy_sprite_if #msx_loop_len 	1 3
    	copy_sprite_if #msx_loop_len 	2 4
    	copy_sprite_if #msx_loop_len*2 	1 5
    	copy_sprite_if #msx_loop_len*2 	2 6
    	copy_sprite_if #msx_loop_len*3 	1 7
    	copy_sprite_if #msx_loop_len*3 	2 8

        cpb sprite_tab_idx1 #msx_loop_len
        bne _not_reset_spr_idx
        mva #0 sprite_tab_idx1
        mva #1 fade_in_done
_not_reset_spr_idx        
    	
        animate_sprite 1

        plr
ret     rti


trans ins '08_go_to_worm.obx.bc'

end_part_hand_mem
.if PGENE = 1
	run RUN_ADDRESS
.endif	

