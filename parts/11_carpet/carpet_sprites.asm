spr_anim_speed=7
spr_anim_size=4*spr_anim_speed 

spr_anim_tab
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)            

init_sprites
s0  lda #$00
    sta sizep0
    sta sizep1
    sta sizep2
    sta sizep3
    sta sizem
x0  lda #$70
    sta hposp0
x1  lda #$86
    sta hposp1
x2  lda #$7E
    sta hposp2
    sta hposp3
x3  lda #$78
    sta hposm0
x4  lda #$7A
    sta hposm1
x5  lda #$7C
    sta hposm2
x6  lda #$8E
    sta hposm3
c3  lda #col_pmg1&$f0
    sta colpm0
    sta colpm1
    sta colpm2
    sta colpm3

    mva #0 spr_anim_idx
    lda >pmg1
    sta pmbase
    rts


.macro choose_sprites
    ldx spr_anim_idx
    lda spr_anim_tab,x 
    sta pmbase
    inx
    cpx #spr_anim_size
    bne _no_reset_sprite_anim
    ldx #0
_no_reset_sprite_anim     
    stx spr_anim_idx
.endm

    .align 2048
pmg1
     .ds $0300
    SPRITES1
pmg2
     .ds $0300    
    SPRITES2
pmg3
     .ds $0300    
    SPRITES3
pmg4
     .ds $0300    
    SPRITES4

.MACRO  SPRITES1
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 10 30 34 34 3C 3D 3F 3F 3F
    .he 3F 3F 3F 3B 33 33 32 30 30 30 30 30 30 34 34 34
    .he 34 3C 3C 3C 3D 3D 3D 3D 3F 3F 3F 2F 2F 2F 0F 0F
    .he 0F 0F 0B 0B 0B 0B 03 03 03 02 02 02 02 02 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
    .he 01 03 07 0F 1F 1F 1F 1F 3E 3E 78 68 E0 A0 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01 03
    .he 03 03 03 07 07 07 07 07 0F 0F 0F 07 07 07 0F 0F
    .he 0F 0F 07 07 02 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he E0 E0 E0 F0 70 F8 F8 F8 FC FC FC FC FC FC F8 80
    .he 80 80 80 00 00 00 00 00 00 00 00 80 80 C0 C0 E0
    .he F0 F0 F0 F8 F8 F8 F8 F8 F0 F0 E0 C0 80 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1C 3E
    .he 3E 7E 7E 7E 7E 7F 7F FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF CF C7 83 9F 1F 1F 1F 3F 3F 7F 7E 7C
    .he 7C 3C 3C 3C 3C 3C 3C 3C 1C 1C 18 18 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1C 3E
    .he 3E 7E 7E 7E 7E 7F 7F FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF CF C7 83 9F 1F 1F 1F 3F 3F 7F 7E 7C
    .he 7C 3C 3C 3C 3C 3C 3C 3C 1C 1C 18 18 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES2
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 10 30 3C 3D 3F 3F 3F 3F
    .he 1F 1B 1B 1B 1B 3B 3B 3B 1B 19 19 3B 33 33 32 32
    .he 30 34 34 3C 3C 3C 3F 3F 3F 3F 2F 2F 2F 0F 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 07 07 07 07 1F 1F 1F 3F 3F 3E 3C
    .he 3C 3C 38 38 38 30 30 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 40 C0 C0 E0 F0 F0 F8 78 78 7C 3C 1E
    .he 1E 1E 1E 3E 7E FC FC F8 F8 F0 E0 E0 C0 C0 80 80
    .he 80 80 80 80 80 80 80 80 80 00 00 00 00 00 80 80
    .he 80 C0 C0 C0 C0 E0 E0 E0 E0 E0 E0 E0 E0 C0 C0 C0
    .he C0 C0 80 80 80 80 80 80 80 80 C0 C0 C0 C0 C0 C0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 01 03 03 01 00 00 03 00 1C 3E 3E 7E
    .he 7E 7E 7E 7E 7E 7F 3F 7F FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF CF CF 87 87 03 03 03 03 03 07 07 07
    .he 0F 0F 0F 0F 07 0F 0F 0F 0F 0F 07 03 01 01 01 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 01 03 03 01 00 00 03 00 1C 3E 3E 7E
    .he 7E 7E 7E 7E 7E 7F 3F 7F FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF CF CF 87 87 03 03 03 03 03 07 07 07
    .he 0F 0F 0F 0F 07 0F 0F 0F 0F 0F 07 03 01 01 01 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES3
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 40 C0 C0 C0 C0 80 00 00 10 10
    .he 30 30 30 30 30 30 10 30 34 3C 3D 3D 3F 3F 3F 3F
    .he 3F 3F 3F 36 34 3C 3C 3C 3C 3C 3C 34 34 34 3C 3C
    .he 3C 3D 3D 3F 3F 3F 3F 3F 3F 2F 2F 2F 0F 0D 09 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 04 0E 1C 1E 1F 1F 0F
    .he 0F 07 03 03 00 00 00 00 00 00 00 00 00 00 00 00
    .he 02 03 03 03 07 07 07 07 07 07 0F 0F 0F 0F 0F 0E
    .he 0E 06 04 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 02 03 03 07 07 07 0F 1F 1F
    .he 3E 7E 7C FC F8 F8 F0 F0 F0 E0 C0 80 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 80 80 80 80 80 80 C0 C0 C0 C0 C0 E0 E0 E0 E0
    .he C0 C0 E0 E0 E0 E0 E0 E0 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 E0 E0 F0
    .he F0 F0 F0 F0 F1 FF FF FF FF FF FF FF FF FF FF FE
    .he FE FE FE FE FE FE FE FE FE FE FE FE FC FC FC FC
    .he FC FC FC FC FC FE 7E 7E 7E 3E 3E 3E 1F 1F 1F 1F
    .he 1F 0F 0F 0F 0F 0F 07 07 07 07 07 07 07 07 03 03
    .he 03 03 03 01 01 01 01 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 E0 E0 F0
    .he F0 F0 F0 F0 F1 FF FF FF FF FF FF FF FF FF FF FE
    .he FE FE FE FE FE FE FE FE FE FE FE FE FC FC FC FC
    .he FC FC FC FC FC FE 7E 7E 7E 3E 3E 3E 1F 1F 1F 1F
    .he 1F 0F 0F 0F 0F 0F 07 07 07 07 07 07 07 07 03 03
    .he 03 03 03 01 01 01 01 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES4
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 34 34 3C
    .he 3C 3C 3C 3C 3C 3C 34 34 3C 3F 3F 3F 3F 3F 3F 3F
    .he 3F 3F 3D 3D 3D 3D 3C 3C 3C 3C 3C 3C 3C 3C 3C 3D
    .he 3D 3D 3D 3F 3F 3F 3F 3F 2F 3F 3F 3F 3F 3F 3D 3D
    .he 3C 14 10 10 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 50 50 70 F0 FC 78
    .he 70 78 78 78 3C 3C 3C 3E 1F 1F 1F 1F 1F 0F 07 07
    .he 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 01 01 01 01 01 01 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 10 10 50 78 38 70 F0 F8 F8 F8 F8 F0 F0
    .he F0 F0 20 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 80
    .he C0 E0 E0 E0 E0 F0 F0 F0 F0 F0 F0 F0 70 70 70 70
    .he 30 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 80
    .he C0 C0 C0 C0 C0 E0 E0 F8 FE FF FF FF FF FF FF FF
    .he FF FC FC FC FC FC FC FC F8 F8 F8 F8 F8 F8 FC FC
    .he FC FC FC FC FC FC BC 3E 3E BE 9E 9F DF DF DF CF
    .he CF CF CF C7 C7 C7 C7 03 01 01 01 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 80
    .he C0 C0 C0 C0 C0 E0 E0 F8 FE FF FF FF FF FF FF FF
    .he FF FC FC FC FC FC FC FC F8 F8 F8 F8 F8 F8 FC FC
    .he FC FC FC FC FC FC BC 3E 3E BE 9E 9F DF DF DF CF
    .he CF CF CF C7 C7 C7 C7 03 01 01 01 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM