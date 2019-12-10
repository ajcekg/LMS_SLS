PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$4000
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

start

first_free = $30
frm_cnt = first_free
dl_ptr = first_free+$2

cur_size_1 = first_free+$4
cur_size_idx_1 = first_free+$5
start_x_1 = first_free+$6
cur_x_1 = first_free+$7
start_col_x_1 = first_free+$8
cur_col_x_1 = first_free+$9
start_y_1 = first_free+$a
cur_y_1 = first_free+$b
start_col_y_1 = first_free+$c
cur_col_y_1 = first_free+$d
x_step_1 = first_free+$e
y_step_1 = first_free+$f

cur_size_2 = first_free+$10
cur_size_idx_2 = first_free+$11
start_x_2 = first_free+$12
cur_x_2 = first_free+$13
start_col_x_2 = first_free+$14
cur_col_x_2 = first_free+$15
start_y_2 = first_free+$16
cur_y_2 = first_free+$17
start_col_y_2 = first_free+$18
cur_col_y_2 = first_free+$19
x_step_2 = first_free+$1a
y_step_2 = first_free+$1b
tmp_color_1 = first_free+$1c
tmp_color_2 = first_free+$1d
xchg_col =  first_free+$1f

dbl_buffer_switch = first_free+$20

sprite_x_idx = first_free+$22
sprite_y = first_free+$24
sprite_h = first_free+$26
sprite_col = first_free+$28
sprite_target_col = first_free+$2a
sprite_ptr = first_free+$2c
spr_idx = first_free+$2e

sprite_size=1
spr_x=0
spr_h=240
spr_y=8

spr_col1_1=$7c
spr_col2_1=$7a
spr_col3_1=$0a
spr_col4_1=$3a
spr_col5_1=$3c

spr_col1_2=$0e
spr_col2_2=$0e
spr_col3_2=$0c
spr_col4_2=$3c
spr_col5_2=$3e

spr_col1_3=$7e
spr_col2_3=$7c
spr_col3_3=$0c
spr_col4_3=$0e
spr_col5_3=$0e

color_bg = $50
color_1 = $34
color_2 = $12

v_size = 120
h_size = 40
dl_ptr_offset = 2//+1+1//+1
size_idx_init_1 = 100
size_idx_init_2 = size_idx_init_1+64-16
max_fade_time = msx_loop_len/16

msx_loop_len = 192
chess_slide_duration = msx_loop_len/2
chess_show_2 = msx_loop_len/2
zoom_start_1 = msx_loop_len*1
zoom_start_2 = msx_loop_len*2
chess_hide_1 = chess_fx_end-max_fade_time * 5
chess_hide_2 = chess_fx_end-max_fade_time * 3

no_sprite_flip = chess_fx_end-msx_loop_len/3
chess_fx_end = msx_loop_len*4

	utils_wait_one_frame

vblk	.local
	inw frm_cnt
	rti
.endl

	
main

init_all    
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
	jsr wait_one_frame
	mva #$61 colbak
	jsr wait_one_frame
    jsr wait_one_frame	
	mva #$60 colbak
	jsr wait_one_frame
    jsr wait_one_frame
.endif

init_fx
    mva #color_bg colbak
    mva #color_bg colpf0
    mva #color_bg colpf1        
    mva #color_bg colpf2

    jsr wait_one_frame
    set_vbl vblk
    mva #%00111110 dmactl
    
    mva #0 dbl_buffer_switch

    mva #size_idx_init_1 cur_size_idx_1
    mva #0 start_col_x_1
    mva #0 start_col_y_1
    mva #0 start_x_1
    mva #0 start_y_1
    mva #color_bg tmp_color_1

    mva #size_idx_init_2 cur_size_idx_2
    mva #0 start_col_x_2
    mva #0 start_col_y_2
    mva #0 start_x_2
    mva #0 start_y_2
    mva #color_bg tmp_color_2
    
    jsr clear_sprites
    mwa #spr_y sprite_y 
    mwa #spr_h sprite_h
    
    mwa #sprite1 sprite_ptr
    jsr copy_sprites1
    mwa #sprite2 sprite_ptr
    jsr copy_sprites2
    mwa #sprite3 sprite_ptr
    jsr copy_sprites3

    jsr wait_one_frame

    lda #108
    setup_sprites_pos0
    lda #116
    setup_sprites_pos1
    lda #124
    setup_sprites_pos2
    lda #132
    setup_sprites_pos3
    lda #140
    setup_sprites_pos4

    mva #%00010001 gtictl

    mva #color_bg colbak
    use_sprites 1
    mva #1 spr_idx
   
    mwa #dl2 dlptr
    
    mva #0 xchg_col
    lda frm_cnt
    sta sprite_x_idx

    mva #color_1 tmp_color_2 // szachownica widoczna od razu

.if PGENE = 0
waitSyncChess
    cpw frmcnt #9*msx_loop_len-1
    bne waitSyncChess
.endif
    mwa #0 frm_cnt


// MAIN
fx_main_loop
    mva #color_bg colbak
    jsr wait_one_frame
    lda dbl_buffer_switch
    bne _dbl1
    jsr chessA
    jmp _dbl2
_dbl1
    jsr chessB
_dbl2

    cpw frm_cnt #chess_show_2
    bne _no_reset_sprite_x_idx
    mva #0 sprite_x_idx
_no_reset_sprite_x_idx    
    set_sprite_pos chess_fx_end-msx_loop_len/2 c

    lda dbl_buffer_switch
    eor #$ff
    sta dbl_buffer_switch

    cpw frm_cnt #chess_fx_end
    beq _fx_end
    jmp fx_main_loop

_fx_end
    jsr wait_one_frame
    lda #0
    sta colbak
    sta colpf0
    sta colpf1        
    sta colpf2
    sta colpf3
    jsr setup_sprites_color	

_quit
	restore_nmi
	
.if PGENE = 0
	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $1000
.else
	jmp *
.endif	

.macro set_sprite_pos
    cpw frm_cnt #%%1
    bc%%2 _no_sprite_scroll
    ldx sprite_x_idx
    lda sprites_pos0%%2,x
    setup_sprites_pos0
    lda sprites_pos1%%2,x
    setup_sprites_pos1
    lda sprites_pos2%%2,x
    setup_sprites_pos2
    lda sprites_pos3%%2,x
    setup_sprites_pos3
    lda sprites_pos4%%2,x
    setup_sprites_pos4
    inc sprite_x_idx
_no_sprite_scroll    
.endm

.macro handle_sprites_chess_colors
    cpb xchg_col #0
    bne _chess_sort_1
    mva tmp_color_1 colpf1
    mva tmp_color_2 colpf2
    jmp _chess_sort_2
_chess_sort_1
    mva tmp_color_2 colpf1
    mva tmp_color_1 colpf2
_chess_sort_2

    // update size
    update_zoom 1 2 1
    update_zoom 2 1 1    

    // update x,y,col
    update_x_y_col x 1
    update_x_y_col y 1
    update_x_y_col x 2
    update_x_y_col y 2

    cpb cur_size_1 cur_size_2
    bcc _chess_sort_3
    start_to_cur x 1 1
    start_to_cur y 1 1
    start_to_cur x 2 2
    start_to_cur y 2 2
    mva #0 xchg_col
    jmp _chess_sort_4
_chess_sort_3    
    start_to_cur x 1 2
    start_to_cur y 1 2
    start_to_cur x 2 1
    start_to_cur y 2 1
    xchg cur_size_1 cur_size_2
    mva #1 xchg_col
_chess_sort_4

    set_chess_color chess_show_2 color_2 tmp_color_1
    set_chess_color chess_hide_2 color_bg tmp_color_1
    set_chess_color chess_hide_1 color_bg tmp_color_2        

    // flip sprite
    cpw frm_cnt #zoom_start_2
    bcc _noSprFlip
    cpw frm_cnt #no_sprite_flip
    bcs  _noSprFlip
    
    ldx spr_idx
    lda spr_idx_tab,x
    cmp #1
    bne _fsNot1
    use_sprites 1
    jmp _fsEnd
_fsNot1    
    cmp #2
    bne _fsNot2
    use_sprites 2
    jmp _fsEnd
_fsNot2    
    use_sprites 3
_fsEnd    
    inc spr_idx
_noSprFlip


.endm

.macro set_chess_color
    cpw frm_cnt #%%1
    bne _no_chess_color
    mva #%%2 %%3
_no_chess_color
.endm

.macro use_sprites
    setup_sprites_base %%1
    mva #spr_col1_%%1 colpm0
    mva #spr_col2_%%1 colpm1
    mva #spr_col3_%%1 colpm2
    mva #spr_col4_%%1 colpm3
    mva #spr_col5_%%1 colpf3
.endm    

.macro drawChess
    // clear
    lda #0
    ldx #h_size
_clr_loop
    .rept 8    
    sta line1%%1,x
    sta line2%%1,x
    sta line3%%1,x
    sta line4%%1,x
    dex
    .endr
    bpl _clr_loop

    // draw X lines
    ldx #h_size-1
_x_loop

    plot_line_block %%1 %00000011 %00000010
    plot_line_block %%1 %00001100 %00001000
    plot_line_block %%1 %00110000 %00100000
    plot_line_block %%1 %11000000 %10000000

    dex
    bmi _x_loop_out
    jmp _x_loop
_x_loop_out

    mwa dl_ptr tmp_dl_ptr

    // draw Y lines
    ldx #v_size
_y_loop
    // update color
    update_x_y_cur_col y 1
    update_x_y_cur_col y 2

    // plot or clear	
    lda cur_col_y_1
    bne _plot_y_line2

    ldy cur_col_y_2    
    bne _plot_y_line1a
    lda >line3%%1
    jmp _after_plot_y   
_plot_y_line1a    
    lda >line1%%1
    jmp  _after_plot_y
_plot_y_line2

    ldy cur_col_y_2
    bne _plot_y_line2a
    lda >line4%%1
    jmp _after_plot_y   
_plot_y_line2a    
    lda >line2%%1
_after_plot_y

    // update dl
tmp_dl_ptr equ *+1
    sta $1234
    adw tmp_dl_ptr #3

    dex
    bne _y_loop
.endm

.macro plot_line_block
    // plot
    lda cur_col_x_1
    bne _no_plot_x_1
    plotX %%2 1 %%1
    plotX %%2 3 %%1
    lda cur_col_x_2
    bne _no_plot_x_2a
    plotX %%3 4 %%1
    jmp _after_plot_x
_no_plot_x_2a
    plotX %%3 2 %%1
 
    jmp _after_plot_x
_no_plot_x_1
    plotX %%2 2 %%1
    plotX %%2 4 %%1
    lda cur_col_x_2
    bne _no_plot_x_2b
    plotX %%3 3 %%1
    jmp _after_plot_x
_no_plot_x_2b
    plotX %%3 1 %%1
_after_plot_x
    
    // update color
    update_x_y_cur_col x 1
    update_x_y_cur_col x 2
.endm

.macro xchg
    lda %%1 
    ldx %%2
    stx %%1
    sta %%2
.endm

.macro plotX // X = posX
    lda line%%2%%3,x
    ora #%%1
    sta line%%2%%3,x
.endm    

.macro update_zoom
    ldx cur_size_idx_%%1
    lda cur_size_table,x 
    sta cur_size_%%1

    cpw frm_cnt #zoom_start_%%1
    bcc _step_update2
    inc cur_size_idx_%%1
    lda #1
    sta x_step_%%1
    sta y_step_%%1
    jmp _step_update3
_step_update2
    lda #%%2
    sta x_step_%%1
    lda #%%3
    sta y_step_%%1
_step_update3
.endm

.macro update_x_y_col
    clc
    lda start_%%1_%%2
    adc %%1_step_%%2
    sta start_%%1_%%2
    cmp cur_size_%%2
    bcc _no_flip_%%1_%%2
    beq _no_flip_%%1_%%2
    lda #0
    sta start_%%1_%%2
    lda start_col_%%1_%%2
    eor #$FF
    sta start_col_%%1_%%2
_no_flip_%%1_%%2
.endm

.macro start_to_cur
    mva start_%%1_%%2 cur_%%1_%%3
    mva start_col_%%1_%%2 cur_col_%%1_%%3
.endm

.macro update_x_y_cur_col
    dec cur_%%1_%%2
    bpl _no_color_update_1
    ldy cur_size_%%2
    sty cur_%%1_%%2
    lda cur_col_%%1_%%2
    eor #$FF
    sta cur_col_%%1_%%2
_no_color_update_1
.endm

.macro copy_sprite 
    cpw frm_cnt #%%2
    bne _no_spr_cp
    mwa #sprite%%1 sprite_ptr
    jsr copy_sprites
    jmp _after_spite_flip
_no_spr_cp
.endm

chessA:
    mwa #dl2 dlptr
    mwa #dl1+dl_ptr_offset dl_ptr
    handle_sprites_chess_colors
    drawChess a
    rts

chessB:
    mwa #dl1 dlptr
    mwa #dl2+dl_ptr_offset dl_ptr
    handle_sprites_chess_colors
    drawChess b
    rts

cur_size_table
    dta b(sin(32,30,256))

spr_idx_tab
    dta b(2,2,2,2,3,3,3,3,2,2,2,2,1,1,1,1)
    :16 dta b(1)
    dta b(3,3,3,3,2,2,2,1,1,1,1,1,1,1,3,3)
    :16 dta b(1)
    :64 dta b(1)
    dta b(3,3,3,3,1,1,1,1,1,2,1,1,1,1,1,1)
    :16 dta b(1)
    dta b(2,2,2,2,1,1,2,2,2,2,1,1,3,3,1,1)
    :16 dta b(1)
    :64 dta b(1)

sprite_last_pos = 250

sprites_pos0c
    :4*max_fade_time dta (108)
    dta b(sin(sprite_last_pos,sprite_last_pos-108,4*(chess_slide_duration-4*max_fade_time),3*(chess_slide_duration-4*max_fade_time),4*(chess_slide_duration-4*max_fade_time)))
sprites_pos1c
    :3*max_fade_time dta (116)
    dta b(sin(sprite_last_pos,sprite_last_pos-116,4*(chess_slide_duration-3*max_fade_time),3*(chess_slide_duration-3*max_fade_time),4*(chess_slide_duration-3*max_fade_time)))
sprites_pos2c
    :2*max_fade_time dta (124)
    dta b(sin(sprite_last_pos,sprite_last_pos-124,4*(chess_slide_duration-2*max_fade_time),3*(chess_slide_duration-2*max_fade_time),4*(chess_slide_duration-2*max_fade_time)))
sprites_pos3c
    :max_fade_time dta (132)
    dta b(sin(sprite_last_pos,sprite_last_pos-132,4*(chess_slide_duration-1*max_fade_time),3*(chess_slide_duration-1*max_fade_time),4*(chess_slide_duration-1*max_fade_time)))
sprites_pos4c
    dta b(sin(sprite_last_pos,sprite_last_pos-140,4*chess_slide_duration,3*chess_slide_duration,4*chess_slide_duration))

// DL
.align $400
.print "Start of DL1: ",*
dl1
    :v_size dta b($4d),a(lineBlank)
    dta b($41),a(dl1) 
.print "End of DL1: ",*

.align $400
.print "Start of DL2: ",*
dl2
    :v_size dta b($4d),a(lineBlank)
    dta b($41),a(dl2) 
.print "End of DL2: ",*

// screens
.align 256
line1a
    org *+512
line2a
    org *+512
line3a
    org *+512    
line4a
    org *+512    
line1b
    org *+512
line2b
    org *+512
line3b
    org *+512    
line4b
    org *+512    
lineBlank
    :h_size dta b(0)

// sprites
    .align $800
sprites1=*
.print "Start of sprites1: ",*
    org sprites1+2048
.print "End of sprites1: ",*
sprites2=*
.print "Start of sprites2: ",*
    org sprites2+2048
.print "End of sprites2: ",*
sprites3=*
.print "Start of sprites3: ",*
    org sprites3+2048
.print "End of sprites3: ",*

sprite1
    ins 'data\spr1.spr'
sprite2
    ins 'data\spr2.spr'
sprite3
    ins 'data\spr3.spr'

    icl 'sprites_common.asm'
    
trans ins '04_go_to_xor.obx.bc'    
    
end_chess_part
.if PGENE = 1
	run RUN_ADDRESS
.endif	


 

