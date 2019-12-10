spr_anim_speed=4
spr_anim_size=4*spr_anim_speed 
spr_h_off = 71

spr_anim_tab
    //0
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)
    //16
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)            
    //32
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)
    //48
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)            
    //64
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)
    //80
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)            
    //96
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)
    //112
    :spr_anim_speed dta b(>pmg1)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg4)            
    //128
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //144
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //160
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //176
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //192
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //208
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //224
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       
    //240
    :spr_anim_speed dta b(>pmg4)
    :spr_anim_speed dta b(>pmg3)
    :spr_anim_speed dta b(>pmg2)
    :spr_anim_speed dta b(>pmg1)       

init_sprites
s0  lda #$00
    sta sizep0
    sta sizep1
    sta sizep2
    sta sizep3
    sta sizem
x0  lda #$30+spr_h_off
    sta hposp0
    sta hposp1
x1  lda #$3A+spr_h_off
    sta hposp2
    sta hposp3
x2  lda #$38+spr_h_off
    sta hposm0
    sta hposm1
x3  lda #$42+spr_h_off
    sta hposm2
    sta hposm3

    setup_anim_idxs
    mva #>pmg1 pmbase
    rts

.macro setup_anim_idxs
    mva #0 spr_anim_idx0
    mva #8 spr_anim_idx1
    mva #16 spr_anim_idx2
    mva #24 spr_anim_idx3
    mva #32 spr_anim_idx4
    mva #40 spr_anim_idx5 
.endm

.macro set_spr_colors_anim
    ldx dli_idx
    ldy spr_anim_idx0,x
    lda spr_anim_tab,y 
    sta pmbase
    iny
    sty spr_anim_idx0,x

    lda spr_colors_tab1,x
    sta colpm0
    sta colpm2
    lda spr_colors_tab2,x
    sta colpm1
    sta colpm3
    inc dli_idx
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
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 03 03 03 03 03 03 0C 0C
    .he 03 03 03 03 03 03 03 03 03 03 06 03 03 03 03 03
    .he 03 03 03 03 00 00 23 23 23 23 23 23 26 26 26 26
    .he 26 26 26 26 26 26 26 26 26 26 26 26 23 23 23 23
    .he 23 23 00 00 CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he 00 00 83 8F 83 8F 83 8F 8C 8C 83 8F 89 8D 89 8D
    .he 89 8D 89 8D 89 8D 89 8D 83 8F 83 8F 83 8F 00 00
    .he 03 03 03 03 03 03 09 09 03 03 03 03 03 03 03 03
    .he 09 09 09 09 09 09 03 03 03 03 03 03 00 00 23 23
    .he 23 23 23 23 26 26 26 26 26 26 26 26 26 26 26 26
    .he 26 26 26 23 23 23 23 23 23 23 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 1F 1F 1F 1F 1F 1F 1C 1C
    .he 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1F 1F
    .he 1F 1F 1F 1F 00 00 7F 7F 7F 7F 7F 7F 47 5F 5F 5F
    .he 5F 5F 57 5F 5F 5F 5F 5F 57 5F 5F 5F 7F 7F 7F 7F
    .he 7F 7F 00 00 FF FF FF FF FF FF FC FC FD FD FD FD
    .he FD FD FD FD CD CD D9 DD DF EF FF FF FF FF FF FF
    .he 00 00 7F 7F 7F 7F 7F 7F 78 70 73 77 77 77 77 77
    .he 77 77 77 76 77 77 77 77 7F 7F 7F 7F 7F 7F 00 00
    .he 1F 1F 1F 1F 1F 1F 1C 1C 1C 1C 1C 1C 1C 1C 1E 1E
    .he 1E 1E 1E 1E 1E 1E 1F 1F 1F 1F 1F 1F 00 00 7F 7F
    .he 7F 7F 7F 7F 57 57 57 57 57 57 57 57 57 57 57 57
    .he 57 5F 5F 6F 7F 7F 7F 7F 7F 7F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 03
    .he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 00 00
    .he 00 00 00 00 00 00 00 7C 00 7C 00 7C 38 7C 20 7C
    .he 20 7C 28 7C 20 7C 20 7C 28 7C 20 7C 00 7C 00 7C
    .he 00 7C 00 00 FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he 00 00 00 7F 00 7F 00 7F 07 7F 0C 7F 08 7F 08 7F
    .he 08 7F 08 7F 08 7F 08 7F 00 7F 00 7F 00 7F 00 00
    .he 00 00 00 00 00 00 03 03 03 03 03 03 03 03 01 01
    .he 01 01 01 01 01 01 00 00 00 00 00 00 00 00 00 7C
    .he 00 7C 00 7C 28 7C 28 7C 28 7C 28 7C 28 7C 28 7C
    .he 28 7C 20 7C 00 7C 00 7C 00 7C 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 FE FE FE FE FE FE 1E 0E
    .he FE FE BE 9E 9E 9E 9E 9E 9E 9E 1E 1E FE FE FE FE
    .he FE FE FE FE 00 00 FF FF FF FF FF FF 07 07 07 07
    .he 7F 7F 0F 0F 0F 0F 7F 7F 07 07 07 07 FF FF FF FF
    .he FF FF 00 00 00 FF 00 FF 00 FF 00 FE 00 FE 00 FE
    .he 00 FE 00 FE 00 F6 00 FE 00 FD 00 FF 00 FF 00 FF
    .he 00 00 F0 F0 F0 F0 F0 F0 F0 70 F0 F0 F0 F0 F0 F0
    .he F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 00 00
    .he FE FE FE FE FE FE 8E 8E 9E 9E 9E 9E 9E 9E BE BE
    .he 3E 3E 3E BE FE FE FE FE FE FE FE FE 00 00 FF FF
    .he FF FF FF FF 67 67 67 67 67 67 67 67 67 67 67 67
    .he 07 07 07 0F FF FF FF FF FF FF 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E0 F0
    .he 00 00 40 60 60 60 60 60 60 60 E0 E0 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 FC F8 FC F8
    .he C0 80 F8 F0 F8 F0 C0 80 FC F8 FC F8 00 00 00 00
    .he 00 00 00 00 FF 00 FF 00 FF 00 FF 01 FF 01 FF 01
    .he FF 01 FF 01 FF 09 FF 01 FF 02 FF 00 FF 00 FF 00
    .he 00 00 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 00 00
    .he 00 00 00 00 00 00 70 70 60 60 60 60 60 60 40 40
    .he C0 C0 C0 40 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 DC 98 DC 98 DC 98 DC 98 DC 98 DC 98
    .he FC F8 FC F0 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES2
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 23 23 23 23 23 23 26 26
    .he 26 26 26 26 26 26 26 26 26 26 26 26 26 26 23 23
    .he 23 23 23 23 00 00 CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F 00 00 83 8F 83 8F 83 8F 8C 8C 89 8D 89 8D
    .he 89 8D 89 8D 89 8D 89 8D 83 8F 83 8F 83 8F 83 8F
    .he 00 00 03 03 03 03 03 03 0C 0C 03 03 03 03 03 03
    .he 03 03 06 03 03 03 03 03 03 03 03 03 03 03 00 00
    .he 23 23 23 23 23 23 26 26 26 26 26 26 26 26 23 23
    .he 23 23 23 23 23 23 23 23 23 23 23 23 00 00 CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 7F 7F 7F 7F 7F 7F 4F 5F
    .he 5F 5F 57 57 57 57 57 57 57 57 57 5F 5F 5F 7F 7F
    .he 7F 7F 7F 7F 00 00 FF FF FF FF FF FF C0 C0 DF DF
    .he DF DF D9 DD DF DF DF DF D8 DC DF DF FF FF FF FF
    .he FF FF 00 00 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F
    .he 7F 7F 7F 7F 71 71 76 77 77 7B 7F 7F 7F 7F 7F 7F
    .he 00 00 1F 1F 1F 1F 1F 1F 1E 1C 1C 1C 1C 1C 1C 1C
    .he 1C 1C 1C 1C 1C 1C 1C 1C 1F 1F 1F 1F 1F 1F 00 00
    .he 7F 7F 7F 7F 7F 7F 57 57 57 57 57 57 57 57 77 77
    .he 6F 6F 6F 6F 6F 6F 7F 7F 7F 7F 7F 7F 00 00 FF FF
    .he FF FF FF FF CC CC DD DD DD DD DD DD DD DD DD DD
    .he D9 DD DF EF FF FF FF FF FF FF 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 7C 00 7C 00 7C 30 7C
    .he 20 7C 28 7C 28 7C 28 7C 28 7C 28 7C 20 7C 00 7C
    .he 00 7C 00 7C 00 00 FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF 00 00 00 7F 00 7F 00 7F 00 7F 00 7F 00 7F
    .he 00 7F 00 7F 0E 7F 09 7F 08 7F 00 7F 00 7F 00 7F
    .he 00 00 00 00 00 00 00 00 01 03 03 03 03 03 03 03
    .he 03 03 03 03 03 03 03 03 00 00 00 00 00 00 00 00
    .he 00 7C 00 7C 00 7C 28 7C 28 7C 28 7C 28 7C 08 7C
    .he 10 7C 10 7C 10 7C 00 7C 00 7C 00 7C 00 00 FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 FF FF FF FF FF FF 0F 07
    .he 07 07 67 67 67 67 67 67 67 67 07 07 07 0F FF FF
    .he FF FF FF FF 00 00 00 FF 00 FF 00 FF 00 FE 00 FE
    .he 00 F7 00 FD 00 FD 00 F7 00 FE 00 FE 00 FF 00 FF
    .he 00 FF 00 00 F0 F0 F0 F0 F0 F0 70 70 F0 F0 F0 F0
    .he F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
    .he 00 00 FE FE FE FE FE FE 1E 0E FE FE BE 9E 9E 9E
    .he 9E 9E 1E 1E BE 9E 9E 9E FE FE FE FE FE FE 00 00
    .he FF FF FF FF FF FF 67 67 67 67 67 67 67 67 6F 6F
    .he 6F 6F 0F 0F 0F 0F FF FF FF FF FF FF 00 00 00 FF
    .he 00 FF 00 FF 00 F6 00 F6 00 F6 00 F6 00 F6 00 F6
    .he 00 FE 00 FD 00 FF 00 FF 00 FF 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F8 F8
    .he FC F8 DC 98 DC 98 DC 98 DC 98 FC F8 FC F0 00 00
    .he 00 00 00 00 00 00 FF 00 FF 00 FF 00 FF 01 FF 01
    .he FF 08 FF 02 FF 02 FF 08 FF 01 FF 01 FF 00 FF 00
    .he FF 00 00 00 0F FF 0F FF 0F FF 8F FF 0F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF
    .he 00 00 00 00 00 00 00 00 E0 F0 00 00 40 60 60 60
    .he 60 60 E0 E0 40 60 60 60 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 DC 98 DC 98 DC 98 DC 98 D0 90
    .he 98 90 F8 F0 F8 F0 00 00 00 00 00 00 00 00 FF 00
    .he FF 00 FF 00 FF 09 FF 09 FF 09 FF 09 FF 09 FF 09
    .he FF 01 FF 02 FF 00 FF 00 FF 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES3
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F 00 00 83 8F 83 8F 83 8F 8C 8C 83 8F
    .he 83 8F 8C 8C 83 8F 83 8F 8C 8C 83 8F 83 8F 83 8F
    .he 83 8F 00 00 03 03 03 03 03 03 03 03 03 03 03 03
    .he 03 03 03 03 09 09 06 03 03 09 03 03 03 03 03 03
    .he 00 00 23 23 23 23 23 23 23 26 26 26 26 26 26 26
    .he 26 26 26 26 26 26 26 26 23 23 23 23 23 23 00 00
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F 00 00 83 8F
    .he 83 8F 83 8F 8C 8C 89 8D 89 8D 89 8D 89 8D 89 8D
    .he 89 8D 83 8F 83 8F 83 8F 83 8F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 FF FF FF FF FF FF C1 C0
    .he DF DF DD DD DD DD DD DD DD DD D9 DD DF DF FF FF
    .he FF FF FF FF 00 00 7F 7F 7F 7F 7F 7F 70 70 77 77
    .he 77 77 76 77 77 77 77 77 76 77 77 77 7F 7F 7F 7F
    .he 7F 7F 00 00 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F 1F
    .he 1F 1F 1F 1F 1C 1C 1C 1C 1C 1E 1F 1F 1F 1F 1F 1F
    .he 00 00 7F 7F 7F 7F 7F 7F 6F 5F 5F 5F 57 57 57 57
    .he 57 57 5F 5F 57 57 57 57 7F 7F 7F 7F 7F 7F 00 00
    .he FF FF FF FF FF FF CC CC DD DD DD DD DD DD FD FD
    .he E9 ED EF EF EF EF FF FF FF FF FF FF 00 00 7F 7F
    .he 7F 7F 7F 7F 71 71 77 77 77 77 77 77 77 77 77 77
    .he 76 77 77 7B 7F 7F 7F 7F 7F 7F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF 00 00 00 7F 00 7F 00 7F 0F 7F 08 7F
    .he 08 7F 09 7F 08 7F 08 7F 09 7F 08 7F 00 7F 00 7F
    .he 00 7F 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 03 03 03 03 03 01 00 00 00 00 00 00
    .he 00 00 00 7C 00 7C 00 7C 10 7C 20 7C 28 7C 28 7C
    .he 28 7C 20 7C 28 7C 28 7C 00 7C 00 7C 00 7C 00 00
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF 00 00 00 7F
    .he 00 7F 00 7F 0E 7F 08 7F 08 7F 08 7F 08 7F 08 7F
    .he 09 7F 08 7F 00 7F 00 7F 00 7F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 FF 00 FF 00 FF 00 FE
    .he 00 FE 00 F6 00 F6 00 F6 00 F6 00 FE 00 FD 00 FF
    .he 00 FF 00 FF 00 00 F0 F0 F0 F0 F0 F0 70 70 F0 F0
    .he F0 F0 F0 F0 F0 F0 F0 F0 70 70 F0 F0 F0 F0 F0 F0
    .he F0 F0 00 00 FE FE FE FE FE FE 8E 8E 9E 9E 9E 9E
    .he 9E 9E 9E 9E 9E 9E 1E 1E FE FE FE FE FE FE FE FE
    .he 00 00 FF FF FF FF FF FF 0F 07 07 07 67 67 67 67
    .he 67 67 07 07 67 67 67 67 FF FF FF FF FF FF 00 00
    .he 00 FF 00 FF 00 FF 00 F6 00 F6 00 F6 00 F6 00 F7
    .he 00 FD 00 FD 00 FD 00 FF 00 FF 00 FF 00 00 F0 F0
    .he F0 F0 F0 F0 70 70 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
    .he F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 FF 00 FF 00 FF 00 FF 01
    .he FF 01 FF 09 FF 09 FF 09 FF 09 FF 01 FF 02 FF 00
    .he FF 00 FF 00 00 00 0F FF 0F FF 0F FF 8F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 8F FF 0F FF 0F FF 0F FF
    .he 0F FF 00 00 00 00 00 00 00 00 70 70 60 60 60 60
    .he 60 60 60 60 60 60 E0 E0 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 F8 F8 FC F8 DC 98 DC 98
    .he DC 98 FC F8 DC 98 DC 98 00 00 00 00 00 00 00 00
    .he FF 00 FF 00 FF 00 FF 09 FF 09 FF 09 FF 09 FF 08
    .he FF 02 FF 02 FF 02 FF 00 FF 00 FF 00 00 00 0F FF
    .he 0F FF 0F FF 8F FF 0F FF 0F FF 0F FF 0F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 0F FF 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

.MACRO  SPRITES4
missiles
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 83 8F 83 8F 83 8F 8C 8C
    .he 83 8F 89 8D 89 8D 89 8D 89 8D 89 8D 83 8F 83 8F
    .he 83 8F 83 8F 00 00 03 03 03 03 03 03 0C 0C 03 03
    .he 03 03 06 03 03 03 03 03 06 03 03 03 03 03 03 03
    .he 03 03 00 00 23 23 23 23 23 23 23 23 23 23 23 23
    .he 23 23 23 23 26 26 26 26 26 23 23 23 23 23 23 23
    .he 00 00 CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F
    .he CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F CF 3F 00 00
    .he 83 8F 83 8F 83 8F 8C 8C 89 8D 89 8D 89 8D 89 8D
    .he 89 8D 83 8F 83 8F 83 8F 83 8F 83 8F 00 00 03 03
    .he 03 03 03 03 09 09 03 03 03 03 03 03 03 03 03 03
    .he 06 03 03 09 03 03 03 03 03 03 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 7F 7F 7F 7F 7F 7F 70 70
    .he 77 77 77 77 77 77 77 77 77 77 76 77 77 77 7F 7F
    .he 7F 7F 7F 7F 00 00 1F 1F 1F 1F 1F 1F 1C 1C 1C 1C
    .he 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1F 1F 1F 1F
    .he 1F 1F 00 00 7F 7F 7F 7F 7F 7F 77 77 77 77 77 77
    .he 77 77 77 77 57 57 57 5F 5F 6F 7F 7F 7F 7F 7F 7F
    .he 00 00 FF FF FF FF FF FF E1 C0 CF DF DD DD DD DD
    .he DD DD D9 DD DD DD DD DD FF FF FF FF FF FF 00 00
    .he 7F 7F 7F 7F 7F 7F 71 71 77 77 77 77 77 77 7F 7F
    .he 7A 7B 7B 7B 7B 7B 7F 7F 7F 7F 7F 7F 00 00 1F 1F
    .he 1F 1F 1F 1F 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C 1C
    .he 1C 1C 1C 1E 1F 1F 1F 1F 1F 1F 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 7F 00 7F 00 7F 0F 7F
    .he 08 7F 08 7F 08 7F 08 7F 08 7F 09 7F 08 7F 00 7F
    .he 00 7F 00 7F 00 00 00 00 00 00 00 00 03 03 03 03
    .he 03 03 03 03 03 03 03 03 03 03 03 03 00 00 00 00
    .he 00 00 00 00 00 7C 00 7C 00 7C 08 7C 08 7C 08 7C
    .he 08 7C 08 7C 28 7C 28 7C 20 7C 00 7C 00 7C 00 7C
    .he 00 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    .he FF FF FF FF FF FF FF FF FF FF FF FF FF FF 00 00
    .he 00 7F 00 7F 00 7F 0E 7F 08 7F 08 7F 08 7F 00 7F
    .he 05 7F 04 7F 04 7F 00 7F 00 7F 00 7F 00 00 00 00
    .he 00 00 00 00 03 03 03 03 03 03 03 03 03 03 03 03
    .he 03 03 03 01 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 F0 F0 F0 F0 F0 F0 F0 70
    .he F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
    .he F0 F0 F0 F0 00 00 FE FE FE FE FE FE 0E 0E FE FE
    .he FE FE 3E 3E FE FE FE FE 0E 0E FE FE FE FE FE FE
    .he FE FE 00 00 FF FF FF FF FF FF E7 E7 E7 E7 E7 E7
    .he E7 E7 E7 E7 67 67 07 07 07 0F FF FF FF FF FF FF
    .he 00 00 00 FF 00 FF 00 FF 00 FE 00 FE 00 F6 00 F6
    .he 00 F6 00 FE 00 F6 00 F6 00 FF 00 FF 00 FF 00 00
    .he F0 F0 F0 F0 F0 F0 70 70 F0 F0 F0 F0 F0 F0 F0 F0
    .he F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 00 00 FE FE
    .he FE FE FE FE 8E 8E 9E 9E 9E 9E 9E 9E 9E 9E 9E 9E
    .he 1E 1E FE FE FE FE FE FE FE FE 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 0F FF 0F FF 0F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF
    .he 0F FF 0F FF 00 00 00 00 00 00 00 00 F0 F0 00 00
    .he 00 00 C0 C0 00 00 00 00 F0 F0 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 1C 18 1C 18 1C 18
    .he 1C 18 1C 18 DC 98 FC F8 FC F0 00 00 00 00 00 00
    .he 00 00 FF 00 FF 00 FF 00 FF 01 FF 01 FF 09 FF 09
    .he FF 09 FF 01 FF 09 FF 09 FF 00 FF 00 FF 00 00 00
    .he 0F FF 0F FF 0F FF 8F FF 0F FF 0F FF 0F FF 0F FF
    .he 0F FF 0F FF 0F FF 0F FF 0F FF 0F FF 00 00 00 00
    .he 00 00 00 00 70 70 60 60 60 60 60 60 60 60 60 60
    .he E0 E0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    .he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM