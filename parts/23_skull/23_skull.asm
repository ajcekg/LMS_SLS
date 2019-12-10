PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS equ $1000
RUN_ADDRESS equ main

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
       utils_wait_x_frame
main\ .print 'main:', main
   .if PGENE = 1
    run main
       jsr rom_off  
   .else
       lda end_eff
       beq * -2
   .endif
    jmp start
    
    
HSC     equ $10
VSC     equ $20
LMS     equ $40
DLI     equ $80
JMPDL   equ $01
color0  equ colpf0
color1  equ colpf1
color2  equ colpf2
color3  equ colpf3

.print cntw

//Zero page

p0  equ $a0
p1  equ $a2
p2  equ $a4
p3  equ $a6


 org $1100
mode=4
dlist1
    dta b(JMPDL), a(dnl)
dnl  .he 70,70,70,70,70,70,70,70
    .he 70,70,70,70,60,60,60,60,50,50,50,40,40,40,30,30,20,20,10,10,0,0,0,00,00
    .he 00,00,00,10,10,10,20,30,40,40,30,20,10,10,10,10,10,10,10,10,10,00,00,00,00

   
dlistS
    :1 .he 00
    dta b(mode+LMS+DLI), a(graph1)
    dta b(mode+DLI)
    dta b(mode+DLI)
    dta b(mode+DLI)
    dta b(mode)
    dta b(mode)
    dta b(mode+DLI)
    dta b(mode)
    dta b(mode)
    dta b(mode)
    dta b(mode)
dlj  dta b(JMPDL), a(dlend) //:3 dta b ($70)

    :1 dta b($e+LMS), a(gcheck)
    :101 dta b($e)
    :1 dta b($e+LMS), a(gcheck+40*102)
    :16 dta b($e)
    
dlend dta b($41), a(dlist1)

dlisttxt
    :5 .he 70
    :1 .he 20
    :1 dta b($e+LMS), a(txt)
    :21 dta b($e)
dlend2 dta b($41), a(dlist1)
    
.if dlist1/$400 <> */$400\ .error 'Wrong DList location. Start: ',dlist1, '  end: ', *, '  size: ', *-dlist1\ .endif    
    
    icl 'dli.asm'

eye .he 01 b1 b3 b5 b7 b9 bb bd bf bd bb b9 b7 b5 b3 b1   
eye2 .he a3 a3 a3 a3 a5 a5 a7 a7 a9 a7 a7 a5 a5 a3 a3 a3   
dlab :47 dta a(dlab:1)
dlabb
.rept 47, 46-#
    dta a(dlab:1)
.endr

cntw dta a(0)

.align $1000
graph1
 icl 'chars.asm'
 .if graph1/$1000 <> */$1000
    .error 'Wrong graph1 location. Start: ',graph1, '  end: ', *, '  size: ', *-graph1
.endif    
 
.align $400
fonts
 icl 'fonts.asm'
 
start
    jsr wait_one_frame
    mva #scr40 dmactl   
    mva #$02 chrctl
    mva #$00 pmcntl
    mva #$00 grafp0 \ sta grafp1\ sta grafp2\ sta grafp3
    sta hposp1\ sta hposp2\ sta hposp3\ sta hposm0\ sta hposm1\ sta hposm2\ sta hposm3\	sta sizep1\ sta sizep2\ sta sizep3\ sta sizem
    mva #$ff grafm
    mwa #dlist1 dlptr
    set_vbl vblProgram
    
    mwa #tabsta p0
    mwa #tabsta+32*64 p1
    mwa #tabsta+64*64 p2
    mwa #tabsta+96*64 p3

ci0	lda #$01
	sta colbak
ci1	lda #$05
	sta color0
ci2	lda #$29
	sta color1
ci3	lda #$1d
	sta color2
ci4	lda #$79
	sta color3
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
    
si0	lda #$00
	sta sizep0
xi0	lda #$7D
	sta hposp0
ci5	lda #$BD
	sta colpm0

    mva #>fonts chbase
    set_dli dli4
    
loop

ctr jmp ef0

//wait
ef0 cr (45)
    bcc ef1 
    mwa #ef0 ctr+1
    jmp eef


//scroll half
ef1 cr (25+8+44)
    bcc ef2
    mwa #ef1 ctr+1
    inc chdl2+1
    jmp eef
    
//stay & blink
ef2 cr (235-24)
    bcc ef3
    mwa #ef2 ctr+1
    jmp ec
    
//scroll up
ef3 cr (235)
    bcc ef4
    mwa #ef3 ctr+1
    lda cntw
    and #$fe
    bne @+
    jmp ec
@
    inc chdl2+1
    jmp ec

//tentacles ext
ef4 cr 375
    bcc ef5
    mwa #ef4 ctr+1
    jmp skc

//wait    
ef5 cr 430
    bcc ef6
    mwa #ef5 ctr+1
    jmp mlo1
    
//show ring
ef6 cr (625)
    bcc ef7
    mwa #ef6 ctr+1
    inc chdl+1
    jmp mlo1
    
//show txt    
ef7 cr (647)
    bcc ef8
    mwa #ef7 ctr+1
    ldx #22
tx  lda txt+9-1,x
gf  sta gcheck+20*40+9-1,x
    dex
    bne tx
    adw tx+1 #40
    adw gf+1 #40
    jmp mlo1
    
//wait
ef8 cr (745+265)
    bcc ef9
    mwa #ef8 ctr+1
    jmp mlo1
    
//hide down
ef9 cr (746+265)
    bcc ef10
    mwa #ef9 ctr+1
    inc chdl3+1
    mva #$1 spd+1
    mva #$94 cb2+1
    jmp mlo1
    
//nothing
ef10 cr (845+355)
    bcc ef11
    mwa #ef10 ctr+1
    jmp ec

//blink txt
ef11 cr (895+355)
    bcc ef12
    mwa #ef11 ctr+1

bk  ldx #0
    cpx #34
    beq bsk
    lda blkt,x
    sta cb2+1
    inc bk+1
    jmp skc
bsk 
    //hide txt    
    inc chdl4+1
    // start hiding tentacles
    mva #46 ml+1
    mva #46*2+1 jx+1
    mwa #dlabb-2 db1+1
    mwa #dlabb-2 db2+1
    mwa #ef12 ctr+1
    jmp skc
    

ef12 cr (896+290)
    bcc ef13
    mwa #ef12 ctr+1
    jmp skc
    
//wait
ef13 
    mwa #ef13 ctr+1
    jmp skc
    
//-----------------------------------

//rotate palette
mlo1
    lda cntw
    and #%00000011
    bne ec
gx  ldx #3
    bne @+
    mva #ggg gx+1
    ldx #ggg
@   lda ctab0-1,x
    sta cb0+1
    lda ctab1-1,x
    sta cb1+1
    lda ctab2-1,x
    sta cb2+1
    dec gx+1
    
//extend tentacles
skc 
ml  lda #46
    beq ec
    dec ml+1
    mva #$ff grm+1
jx  ldx #46*2+1
db1 lda dlab-2,x
    sta jmd+2
    dex 
db2 lda dlab-2,x
    sta jmd+1
    dex
    stx jx+1
   
//blink eye
ec  lda cntw
spd and #$ff
    beq eef
ece  lda #0
    and #%00001111
    tax
    lda eye,x
	sta c5+1
    lda eye2,x
    sta c18+1
    inc ece+1

    
eef cpw #50*27+25 cntw
    beq eend

    jsr wait_one_frame
    inw cntw
    jmp loop
eend
    
    
//Close part.
.if PGENE = 0
  jsr wait_one_frame
  mva #$00 pmcntl\ sta grafp0 \ sta grafp1\ sta grafp2\ sta grafp3
  sta hposp1\ sta hposp2\ sta hposp3\ sta hposm0\ sta hposm1\ sta hposm2\ sta hposm3
  lda #1\ sta color0\ sta color1\ sta color2\ sta color3\ sta colbak\ sta colpf0\ sta colpf1\ sta colpf2\ sta colpf3
  set_dli dnul
  set_vbl dnul
  restore_nmi
  mva #0 dmactl
  jmp *
  
.else
  jmp *
.endif
 
 
.macro cr
    lda #(>:1)
    cmp cntw+1
    bne cre
    lda #(<:1)
    cmp cntw
cre
.endm
      
ggg=3
cv2=$95
cv1=$93
cv0=$91
ctab0 .by cv0 cv1 cv2   
ctab1 .by cv2 cv0 cv1
ctab2 .by cv1 cv2 cv0
 
 
blkt .he 99 99 99 9b 9b 9b 9d 9d 9d 9f 9f 9f 9d 9d 9d 9b 9b 9b 99 99 99 97 97 97 95 95 95 93 93 93 91 91 91 1
 
.align 
tabsta
 ins 'tent.bin'
tabend

txt
 ins 'txt02.mic',0,880
 .if txt/$1000 <> */$1000\ .error 'Wrong gfx location. Start: ',txt, '  end: ', *, '  size: ', *-txt\ .endif    
 
.align $1000
 org *+$10
gcheck
 ins 'u33.mic',0,4760
 
 

 
 