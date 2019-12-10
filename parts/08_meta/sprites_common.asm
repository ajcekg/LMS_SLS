
copy_sprites1
  copy_sprites 1

copy_sprites2
  copy_sprites 2

 .macro copy_sprites
    mwa sprite_ptr sprite0_tmp_ptr
    mwa sprite0_tmp_ptr sprite1_tmp_ptr
    adw sprite1_tmp_ptr sprite_h
    mwa sprite1_tmp_ptr sprite2_tmp_ptr
    adw sprite2_tmp_ptr sprite_h
    mwa sprite2_tmp_ptr sprite3_tmp_ptr
    adw sprite3_tmp_ptr sprite_h
    mwa sprite3_tmp_ptr sprite4_tmp_ptr
    adw sprite4_tmp_ptr sprite_h

    mwa #sprites%%1+1024/sprite_size sprite0_target_ptr
    mwa #sprites%%1+1280/sprite_size sprite1_target_ptr
    mwa #sprites%%1+1536/sprite_size sprite2_target_ptr
    mwa #sprites%%1+1792/sprite_size sprite3_target_ptr
    mwa #sprites%%1+768/sprite_size sprite4_target_ptr
    adw sprite0_target_ptr sprite_y
    adw sprite1_target_ptr sprite_y
    adw sprite2_target_ptr sprite_y
    adw sprite3_target_ptr sprite_y
    adw sprite4_target_ptr sprite_y
    
    ldx #0
spr_copy_loop
sprite0_tmp_ptr=*+1
    lda $ffff,x
sprite0_target_ptr=*+1
    sta $ffff,x
sprite1_tmp_ptr=*+1
    lda $ffff,x
sprite1_target_ptr=*+1
    sta $ffff,x
sprite2_tmp_ptr=*+1
    lda $ffff,x
sprite2_target_ptr=*+1
    sta $ffff,x
sprite3_tmp_ptr=*+1    
    lda $ffff,x
sprite3_target_ptr=*+1
    sta $ffff,x
sprite4_tmp_ptr=*+1    
    lda $ffff,x
sprite4_target_ptr=*+1
    sta $ffff,x                      
    inx
    cpx sprite_h
    bne spr_copy_loop
    rts
.endm

sprites_on
    ldy #%00000011
    sty pmcntl
    rts

sprites_off
    ldy #%00000000
    sty pmcntl
    rts

clear_sprites
    ldx #0
clr_sprites_loop
    lda #0
    sta sprites1,x
    sta sprites1+256,x
    sta sprites1+512,x
    sta sprites1+768,x
    sta sprites1+1024,x
    sta sprites1+1280,x
    sta sprites1+1536,x
    sta sprites1+1792,x
    sta sprites2,x
    sta sprites2+256,x
    sta sprites2+512,x
    sta sprites2+768,x
    sta sprites2+1024,x
    sta sprites2+1280,x
    sta sprites2+1536,x
    sta sprites2+1792,x
    dex
    bne clr_sprites_loop

    lda #0
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
    sta hposp0
    sta hposp1
    sta hposp2
    sta hposp3

    rts

.macro setup_sprites_pos
    clc
    sta hposp0
    adc #8
    sta hposp1
    adc #8
    sta hposp2
    adc #8
    sta hposp3    
    adc #8
    sta hposm3
    adc #2
    sta hposm2
    adc #2
    sta hposm1
    adc #2
    sta hposm0
.endm

.macro setup_sprites_base
    lda >sprites%%1
    sta pmbase
.endm

setup_sprites
    // setup sprites
    ldy #%00000000
    sty pmcntl
    //ldy #%00001000
    ldy #%00000001
    sty gtictl
    ldy #%00000000
    sty sizep0
    sty sizep1
    sty sizep2
    sty sizep3
    //ldy #%11111111
    sty sizem

    setup_sprites_base 1
    
    lda sprite_x
    setup_sprites_pos

    lda sprite_col
setup_sprites_color
    setup_sprites_color_m
    rts

.macro setup_sprites_color_m
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
.endm    