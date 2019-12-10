
vblProgram
    phr
    
    mwa #dlist1 dlptr
    set_dli dli4   
    
c0	lda #$01
	sta colbak
c1	lda #$05
	sta color0
c2	lda #$29
	sta color1
c3	lda #$1d
	sta color2
c4	lda #$79
	sta color3
x0	lda #$7e
	sta hposp0
c5	lda #$Bd
    sta colpm0
    
    lda #$04
	sta gtictl
    
    mva #$00 grafp0 \ sta grafp1\ sta grafp2\ sta grafp3\ sta grafm
    sta hposp0\ sta hposp1\ sta hposp2\ sta hposp3\ sta hposm0\ sta hposm1\ sta hposm2\ sta hposm3
    
    adw p0 #64
    lda p0+1
    cmp #>tabend
    bcc @+
    mva #>tabsta p0+1
@
    adw p1 #64
    lda p1+1
    cmp #>tabend
    bcc @+
    mva #>tabsta p1+1
@
    adw p2 #64
    lda p2+1
    cmp #>tabend
    bcc @+
    mva #>tabsta p2+1
@
    adw p3 #64
    lda p3+1
    cmp #>tabend
    bcc @+
    mva #>tabsta p3+1
@

chdl lda #0
     beq @+
     dec chdl+1
     lda #$70\ sta dlj\ sta dlj+1\ sta dlj+2
@

chdl2 lda #0
     beq @+
     dec chdl2+1
     inw dlist1+1
@
     
chdl3 lda #0
     beq @+
     dec chdl3+1
     mva #JMPDL dlj
     mwa #dlisttxt dlj+1
@ 
    
chdl4 lda #0
     beq @+
     dec chdl4+1
     mva #JMPDL dlj
     mwa #dlend dlj+1
@   
    
    
    plr
vblEmpty    rti



dli4
	sta regA
    lda #$79
	sta hposp0

c6	lda #$1f
	sta wsync		;line=64
	sta color2
c7	lda #$2b
	sta wsync		;line=65
	sta color1
c8	lda #$1d
	sta color2
c9	lda #$1f
	sta wsync		;line=66
	sta color2
c10	lda #$1d
	sta wsync		;line=67
	sta color2
c11	lda #$1f
	sta wsync		;line=68
	sta color2
    set_dli dli5
	lda regA
    rti

dli5
	sta regA

	sta wsync		;line=72
	sta wsync		;line=73
c12	lda #$29
	sta wsync		;line=74
	sta color1
    set_dli dli6
    lda regA
	rti

dli6
	sta regA

	sta wsync		;line=80
c13	lda #$1d
	sta wsync		;line=81
	sta color2
c14	lda #$1f
	sta wsync		;line=82
	sta color2
c15	lda #$1d
	sta wsync		;line=83
	sta color2
    set_dli dli7
    lda regA
	rti

dli7
	sta regA

	sta wsync		;line=88
	sta wsync		;line=89
	sta wsync		;line=90
	sta wsync		;line=91
c16	lda #$1f
	sta wsync		;line=92
	sta color2
	sta wsync		;line=93
c17	lda #$1d
	sta wsync		;line=94
	sta color2

	sta wsync		;line=95
        mva #$23 grafp0
	sta wsync		;line=96
        mva #$ab grafp0
c18	lda #$A7
	sta wsync		;line=97
    sta colpm0
        
c19	lda #$1f
	sta wsync		;line=98

	sta color2
        mva #$8b grafp0
c20	lda #$1d
	sta wsync		;line=99
	sta color2
        mva #$77 grafp0
c21	lda #$1f
	sta wsync		;line=100
        
	sta color2
	sta wsync		;line=101
        mva #$0 grafp0\ sta hposp0
	sta wsync		;line=102
c22	lda #$1d
	sta wsync		;line=103
	sta color2
    set_dli dli_112
	lda regA
dnul	rti    
    
dli_112
    sta regA
    stx regX
    sty regY
    
    sta wsync

    ldy #0
    clc
    :5 sta wsync

grm mva #$00 grafm
    mva #$70 colpm0\ sta colpm1\ mva #$80 colpm3\ mva #$60 colpm2

.rept 3, #
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda (p3),y\ adc #12\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr

    mva #$73 colpm0\ sta colpm1
    mva #$83 colpm3
    mva #$63 colpm2
    
.rept 1
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda (p3),y\ adc #12\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr

    mva #$73 colpm0\ mva #$75 colpm1\ mva #$85 colpm3\ mva #$63 colpm2
    
jmd    jmp dlab46

dlab0
dlab1
    
.rept 1
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda (p3),y\ adc #12\ sta hposm3
    iny\dlab2 sta wsync\dlab3 sta wsync\dlab4 sta wsync
.endr

    mva #$75 colpm0\ mva #$77 colpm1\ mva #$87 colpm3\ mva #$65 colpm2
    
.rept 34, #+5
dlab:1
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda (p3),y\ adc #12\ sta hposm3
    iny\ sta wsync
    
.if :1=13
    lda vcount
    cmp #50
    bcc skk
cb0 mva #$05 color0
cb1 mva #$03 color1
cb2 mva #$1d color2     
    mva #01 gtictl
    clc
skk
    .endif
    sta wsync
    sta wsync
    
    .if :1=20
    mva #2 gtictl
    .endif
    
    .if :1=35
    mva #01 gtictl
    .endif
    
.endr

    mva #%01111111 grafm

.rept 2, #+39
dlab:1
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda (p3),y\ adc #12\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr

     mva #%01110111 grafm

.rept 2, #+41
dlab:1
    lda (p0),y\ sta hposm0
    lda (p1),y\ adc #4\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda #0\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr

    mva #%01010111 grafm

.rept 2, #+43
dlab:1
    lda (p0),y\ sta hposm0
    lda #0\ sta hposm1
    lda (p2),y\ adc #8\ sta hposm2
    lda #0\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr

    mva #%01010101 grafm
    
.rept 2, #+45
dlab:1
    lda (p0),y\ sta hposm0
    lda #0\ sta hposm1\ sta hposm2\ sta hposm3
    iny\ sta wsync\ sta wsync\ sta wsync
.endr
   
    mva #$0 grafm\ sta grafp0\ sta grafp1\ sta grafp2\ sta grafp3
    
    lda regA
    ldx regX
    ldy regY
    rti
