spr_xor .local
    //icl 'atari.hea' 

clear_sprites
    ldx #0
clr_sprites_loop
    lda #0
    sta sprites,x
    sta sprites+256,x
    sta sprites+512,x
    sta sprites+768,x
    sta sprites+1024,x
    sta sprites+1280,x
    sta sprites+1536,x
    sta sprites+1792,x  
    /*          
    sta sprites2,x
    sta sprites2+256,x
    sta sprites2+512,x
    sta sprites2+768,x
    sta sprites2+1024,x
    sta sprites2+1280,x
    sta sprites2+1536,x
    sta sprites2+1792,x
    */ 
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

copy_sprites
    ldx #0
spr_copy
    lda sprite0,x
    sta sprites+1024+spr_y,x
    lda sprite1,x
    sta sprites+1280+spr_y,x
    lda sprite2,x
    sta sprites+1536+spr_y,x
    lda sprite3,x
    sta sprites+1792+spr_y,x
    lda sprite4,x
    sta sprites+768+spr_y,x                      
    inx
    cpx #spr_h
    bne spr_copy
    rts

/*
copy_sprites2
    ldx #0
spr_copy2
    lda sprite0,x
    sta sprites2+1024+spr_y,x
    lda sprite1,x
    sta sprites2+1280+spr_y,x
    lda sprite2,x
    sta sprites2+1536+spr_y,x
    lda sprite3,x
    sta sprites2+1792+spr_y,x
    lda sprite4,x
    sta sprites2+768+spr_y,x                      
    inx
    inx
    cpx #spr_int_max
    bne spr_copy2

spr_copy2b
    lda sprite0,x
    sta sprites2+1024+spr_y,x
    lda sprite1,x
    sta sprites2+1280+spr_y,x
    lda sprite2,x
    sta sprites2+1536+spr_y,x
    lda sprite3,x
    sta sprites2+1792+spr_y,x
    lda sprite4,x
    sta sprites2+768+spr_y,x                      
    inx
    cpx #spr_h
    bne spr_copy2b
*/
    rts

.macro sprites_below
    lda #%00001000
    sta gtictl
.endm

.macro sprites_above
    lda #%00000001
    sta gtictl
.endm

/*
.macro switch_sprites2
    lda >sprites2
    sta pmbase
.endm    
*/

.macro switch_sprites
    lda >sprites
    sta pmbase
.endm    
    rts   
        
setup_sprites
    // setup sprites
    lda >sprites
    sta pmbase
    
    ldy #%00000000 // sprites off yet
    sty pmcntl
    ldy #%00000001
    //ldy #%00001000
    sty gtictl
    ldy #%00000000
    sty sizep0
    sty sizep1
    sty sizep2
    sty sizep3
    sty sizem
    
    lda #spr_x
    sta hposp0
    clc
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

    lda #xor_color_bg
setup_sprites_color
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3
    
    rts

.endl