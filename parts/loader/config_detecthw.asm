// detekcja stereo, pami�ci, vbxe, xbios-a, NTSC
// konfigurator bank�w i vbxe
	
//	org $2000	
	opt f+ h-
	org $2000-5
	dta a($1ffd)
go_go_go
	jmp main

	icl 'loader_config.hea'
	icl 'atari_shadows.hea'
	icl 'atari.hea'
	icl 'sls.hea'

/////////////////////////////////////////////////////////////////////////
//.align $400
fnt
	ins 'data\font.fnt'
fl_fnt 
	ins 'data\monogram2.fnt', +0, $190
fl_scr
	ins 'data\monogram2.scr', +760, 400
fl_zero
	:40 dta b(0)
load_dl		:1	dta b($80)
			:3	dta b(0)
			:19 dta b($44),a(fl_zero)
			:1  dta b($44),a(fl_scr)
			:9	dta b($04)
			:1	dta b($41),a(load_dl)
load_dl1	:4	dta b(0)
			:19 dta b($44),a(fl_zero)
			:1  dta b($44),a(fl_scr)
			:9	dta b($04)
			:1	dta b($41),a(load_dl1)			
loader_pic_end

cl01 dta b(15,14,13,12,11,10,9,8,8,7,7,6,6,5,5,4,4) 	//34
cl02 dta b(15,14,13,12,11,10,9,9,8,8,8,7,7,7,6,6,6) 	//26
cl03 dta b(15,15,15,14,15,14,15,14,15,14,14,14,14,14,14,14,14) 	//1e

SINUS .byte 1,2,3,4,6
      .byte 8,10,12,15,18,21
      .byte 25,28,32,36,41,45
      .byte 50,55,60,65,70,75
      .byte 81,86,92,98,104,109
      .byte 115,121,127,133,139,144
      .byte 150,156,161,167,172,177
      .byte 182,187,192,197,201,205
      .byte 209,213,216,220,223,226
      .byte 228,231,233,234,236,237
      .byte 238,239
			
load_main	.local
		lda #0
		sta dmactl
		sta SDMCTL
		mwa #load_dl SDLSTL
		mva #$0 COLOR0
		sta COLOR1
		sta COLOR2
		sta COLOR3
		sta COLBK
		lda #>fl_fnt
		sta CHBAS
		mwa #dli_01 512
		mva #$C0 nmien
		mva #34 SDMCTL
		jsr wait_frame


		ldx #0
l01		txa
		//sta COLOR0
		sta COLOR1
		sta COLOR2
		sta COLOR3
		jsr wait_frame		
		inx
		cpx #15
		bne l01

		ldx #0
l02		lda cl01,x
		clc 
		adc #$30
		sta COLOR1
		lda cl02,x
		clc
		adc #$20
		sta COLOR2
		lda cl03,x
		clc
		adc #$10
		sta COLOR3	
		jsr wait_frame			
		inx
		cpx #16
		bne l02		


		ldx #0
l03		jsr wait_frame
		lda SINUS,x
		sta dli_01.l0+1
		inx
		cpx #61
		bne l03
		
		mva #$62 COLOR0
		jsr wait_frame
		mwa olddli 512

		mwa #load_dl1 SDLSTL
		mwa #load_dl1 dlptr
		mva #$40 nmien
		rts
.endl			 			

dli_01	.local 
	phr
	mva #$62 colpf0
l0	ldx #0
	beq	n0
l1	sta wsync
	dex
	bne l1
n0	mva #0 colpf0
	plr
	rti
.endl

///////////////////////////////////////////////////////////////////////

installOS	.local
		sei
		lda #0
		sta nmien
		sta dmactl
		lda #$fe
		sta portb
		lda #<os_data
		ldy #>os_data
		jsr BONGO_DECRUNCH
		lda #$ff
		sta portb
		cli
		lda #$40
		sta nmien
		rts		
.endl


olddli	dta a(0)
main	.local
		ldx #bank_swith_end-bank_swith-1
o1		lda bank_swith,x
		sta $600,x
		dex
		bpl o1

		jsr wait_frame
		jsr colors_down
		jsr installOS
		jsr detect_main
		lda #>fnt
		sta $02F4 
		mva #0 config_vbxe_on	//inicjalnie obs�uga vbxe zawsze wylaczona
		lda config_vbxe
		beq n1
		lda #0
		vbsta VBXE_VIDEO_CONTROL
n1		jsr fill_config_info
		mva #34 SDMCTL 
		mwa #info_dlist SDLSTL
		mva #$C0 $D40E
		mwa 512 olddli
		mwa #dli1 512
		jsr wait_frame
		
waitm	lda dli1
		cmp #{RTI}
		bne waitm		
		
		mva #0 20	
		//czekamy na wcisniecie spacji lub start
loop	lda $D01F
		and #1
		bne l3
		jmp enter_config
l3		lda 20
		cmp #50
		bne l1
		mva #0 20
		dec tmp
		lda tmp
		bmi l2
		jsr convert_to_str
		sty	config_action+74
l1		ldx 764
		cpx #33
		bne loop
		lda #255
		sta 764
		//wcisnieta spacje - gasimy napisy
l2		jsr wait_frame
		mva #0 709
		mwa #dli2 512
		ldx #40
l5		jsr wait_frame
		dex
		bpl l5
		mva #0 $D400
		jmp load_main	

		
tmp		dta b(5)
.endl		


enter_config .local
		jsr wait_frame
		mva #0 709
		mwa #dli2 512
		ldx #40
w1		jsr wait_frame
		dex
		bpl w1
		mva #$40 $D40E		
		mwa #dli3 512
		mwa #edit_dlist SDLSTL
		jsr fill_config
		jsr print_cursor
		jsr wait_frame
		mva #$c0 $D40E

wait	lda dli3
		cmp #{RTI}
		bne wait 
		
mk		ldx 764
		cpx #33		//spacja
		beq eend
		cpx #15		//down
		bne ?n1
		jsr cursor_down
		jmp ?endloop
?n1		cpx #14		//up
		bne ?n2
		jsr cursor_up
		jmp ?endloop	
?n2		cpx #7		//right
		bne ?n3
		jsr cursor_right
		jmp ?endloop
?n3		cpx #6		//left
		bne ?endloop
		jsr cursor_left
		jmp ?endloop
?endloop
		lda #255
		sta 764
		lda 20
		cmp 20
		beq *-2
		jsr print_banks
		jsr print_cursor
		jmp mk		
		
eend	jsr wait_frame
		mva #0 709
		mwa #dli4 512
		ldx #50
l51		jsr wait_frame
		dex
		bpl l51
		
		ldx #MIN_FREE_BANKS-1
l52		ldy active_banks,x
		lda config_ext_banks,y
		sta config_ext_banks,x
		dex
		bpl l52

		jmp load_main

.endl

///////////////////////////////////////////////////////////////////////////////
// procedura uzupelniaj�ca dane konfiguracyjne na ekranie

active_banks
.rept MIN_FREE_BANKS #
	dta b(:1)
.endr

min_index 	dta b(0)
cursor_pos	dta b(0)
cursor_adr	dta a(23)

cursor_up	.local
		jsr clear_cursor
		lda cursor_pos
		cmp min_index
		beq eend
		dec cursor_pos
		sbw cursor_adr #40
eend	jmp print_cursor		
.endl

cursor_down	.local
		jsr clear_cursor
		lda cursor_pos
		cmp #MIN_FREE_BANKS
		beq eend
		inc cursor_pos
		adw cursor_adr #40
eend	jmp print_cursor
.endl

cursor_left	.local
		lda cursor_pos
		bne mem
		jmp change_vbxe_state
mem		jmp get_prev_bank
		rts			
.endl

cursor_right .local
		lda cursor_pos
		bne mem
		jmp change_vbxe_state
mem		jmp get_next_bank
		rts		
.endl

change_vbxe_state	.local
		lda #CONFIG_COLOR_SAT
		ora #CONFIG_COLOR
		sta 709
		ldx #0
		lda config_vbxe_on
		eor #1
		sta config_vbxe_on
		beq l1
		ldx #11
l1		ldy #0
l2		lda von,x+
		sta config_edit+23,y
		iny
		cpy #11
		bne l2
		jsr print_cursor
		lda config_vbxe_on
		beq off
		lda #2
off		vbsta VBXE_VIDEO_CONTROL
		rts
		
				
von		dta d'off        '
vof		dta d'xcolor mode'
		
.endl

print_cursor	.local
		ldy #0
		mwa #config_edit 254
		adw 254 cursor_adr
		ldx cursor_pos
		bne l2
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda config_vbxe_on
		beq l1
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y+		
l1		rts
l2		lda (254),y
		ora #$80
		sta (254),y+
		lda (254),y
		ora #$80
		sta (254),y
		rts		
.endl

clear_cursor	.local
		ldy #0
		mwa #config_edit 254
		adw 254 cursor_adr
		ldx cursor_pos
		bne l2
		lda (254),y
		and #$7f
		sta (254),y+
		lda (254),y
		and #$7f
		sta (254),y+
		lda (254),y
		and #$7f
		sta (254),y
		rts
l2		lda (254),y
		and #$7f
		sta (254),y+
		lda (254),y
		and #$7f
		sta (254),y
		rts		
.endl

get_next_bank	.local
		lda config_ext_num_banks
		cmp #MIN_FREE_BANKS
		beq end
		ldx cursor_pos
		lda active_banks-1,x
		tax
l2		inx
		cpx config_ext_num_banks
		bne l1
		ldx #0
l1		stx cm+1
		ldy #0
l3		lda active_banks,y
cm		cmp #0
		beq l2
		iny
		cpy #MIN_FREE_BANKS
		bne l3
		txa
		ldx cursor_pos
		sta active_banks-1,x 
end		rts
.endl

get_prev_bank	.local
		lda config_ext_num_banks
		cmp #MIN_FREE_BANKS
		beq end
		ldx cursor_pos
		lda active_banks-1,x
		tax
		beq l4
l2		dex
		bpl l1
l4		ldx config_ext_num_banks
		dex
l1		stx cm+1
		ldy #0
l3		lda active_banks,y
cm		cmp #0
		beq l2
		iny
		cpy #MIN_FREE_BANKS
		bne l3
		txa
		ldx cursor_pos
		sta active_banks-1,x 
end		rts
.endl

fill_config	.local
		//vbxe
		lda config_vbxe
		bne l2
		ldx #39
		lda #0
l1		sta config_edit,x
		dex
		bpl l1
		mva #1 min_index
		mva min_index cursor_pos
		adw cursor_adr #40
l2		jmp print_banks
.endl

print_banks	.local
		mva #0 l0+1
		mwa #config_edit+40+23 l2+1
		mwa #config_edit+40+24 l3+1
l0		ldy #0
l1		ldx active_banks,y
		lda config_ext_banks,x
		jsr convert_to_str
l2		stx config_edit+40+23
l3		sty	config_edit+40+24
		adw l2+1 #40
		adw l3+1 #40
		inc l0+1
		ldy l0+1
		cpy #MIN_FREE_BANKS
		bne l1	
		rts
.endl


///////////////////////////////////////////////////////////////////////////////
// procedura przerwania dli

dli1	.local 
		pha
		txa
		pha
m0		ldx #0
		lda tab,x
		bmi set_0
		sta $D017
		jmp l1		
set_0	lda #0		
		sta $D017
l1		inx
		cpx #7+num_conf_line
		beq set_n
		inc m0+1
		jmp l4
set_n	lda #0
		sta m0+1
		sta eend+1
		ldx #6+num_conf_line
l3		lda tab,x
		cmp #CONFIG_COLOR_SAT
		beq l2
		clc
		adc #1
		sta tab,x
		sta eend+1
l2		dex
		bpl l3
eend	lda #0
		bne l4
		lda #{RTI}
		sta dli1
		lda #CONFIG_COLOR_SAT
		sta 709
l4		pla
		tax
		pla
		rti				
tab
.rept (7+num_conf_line) 0-#
	dta b(:1)
.endr
.endl

dli2	.local 
		pha
		txa
		pha
m0		ldx #0
		lda col,x
		bmi l1
		sta $D017
l1		inx
		cpx #7+num_conf_line
		beq l2
		stx m0+1
		jmp e1
l2		lda #0
		sta m0+1
m1		ldx #0
l3		dec col,x
		dex
		bpl l3
		ldx m1+1
		cpx #6+num_conf_line
		beq l4
		inc m1+1					
l4		ldx #9
		lda col,x
		bne e1
		dex
		bpl l4
		lda #{RTI}
		sta dli2
e1		pla
		tax
		pla
		rti				

col
.rept 7+num_conf_line CONFIG_COLOR_SAT
	dta b(:1)
.endr	
.endl

dli3	.local 
		pha
		txa
		pha
m0		ldx #0
		lda tab,x
		bmi set_0
		sta $D017
		jmp l1		
set_0	lda #0		
		sta $D017
l1		inx
		cpx #4+MIN_FREE_BANKS
		beq set_n
		inc m0+1
		jmp l4
set_n	lda #0
		sta m0+1
		sta eend+1
		ldx #3+MIN_FREE_BANKS
l3		lda tab,x
		cmp #CONFIG_COLOR_SAT
		beq l2
		clc
		adc #1
		sta tab,x
		sta eend+1
l2		dex
		bpl l3
eend	lda #0
		bne l4
		lda #{RTI}
		sta dli3
		lda #CONFIG_COLOR_SAT
		sta 709
l4		pla
		tax
		pla
		rti				

tab
.rept (4+MIN_FREE_BANKS) 0-#
	dta b(:1)
.endr
.endl

dli4	.local 
		pha
		txa
		pha
m0		ldx #0
		lda col,x
		bmi l1
		ora #CONFIG_COLOR
		sta $D017
l1		inx
		cpx #4+MIN_FREE_BANKS
		beq l2
		stx m0+1
		jmp e1
l2		lda #0
		sta m0+1
m1		ldx #0
l3		dec col,x
		dex
		bpl l3
		ldx m1+1
		cpx #3+MIN_FREE_BANKS
		beq l4
		inc m1+1					
l4		ldx #3+MIN_FREE_BANKS
		lda col,x
		bne e1
		dex
		bpl l4
		lda #{RTI}
		sta dli4
e1		pla
		tax
		pla
		rti				

col
.rept 4+MIN_FREE_BANKS CONFIG_COLOR_SAT
	dta b(:1)
.endr	
.endl


.align $400
edit_dlist
		:1	dta b($70)
		:1	dta b($F0)
		:1	dta b($C2),a(config_header)
		:1	dta b($02)
		:1	dta b($F0)
		:1	dta b($C2),a(config_edit)
		:MIN_FREE_BANKS-1	dta b($82)
		:1	dta b($02)
		:1	dta b($F0)
		:1	dta b($42),a(config_space)
		:1	dta b($41),a(edit_dlist)


num_conf_line	equ	(MIN_FREE_BANKS/4)

info_dlist
		:1	dta b($70)
		:1	dta b($F0)
		:1	dta b($C2),a(config_header)
		:1	dta b($02)
		:1	dta b($F0)
		:1	dta b($C2),a(config_status)
		:1	dta b($82)
		:num_conf_line	dta b($82)
		:1	dta b($02)
		:1	dta b($F0)
		:1	dta b($C2),a(config_action)
		:1	dta b($02)
		:1	dta b($41),a(info_dlist)			

config_edit
	dta d'                 VBXE: off              '
	dta d'              bank 00:                  '
	dta d'              bank 01:                  '
	dta d'              bank 02:                  '
	dta d'              bank 03:                  '
	dta d'              bank 04:                  '
	dta d'              bank 05:                  '
	dta d'              bank 06:                  '
	dta d'              bank 07:                  '
	dta d'              bank 08:                  '
	dta d'              bank 09:                  '
	dta d'              bank 0a:                  '
	dta d'              bank 0b:                  '
	dta d'              bank 0c:                  '
	dta d'              bank 0d:                  '
	dta d'              bank 0e:                  '
	dta d'              bank 0f:                  '
	
config_space
	dta d'        press SPACE to continue         '
	
config_header
	dta d'      Second Life Syndrome by Lamers    '
	dta d'           Silly Venture 2k19           '

config_status
	dta d'        stereo: not detected            '
	dta d'          VBXE: not detected or bad core'
	dta d'           ram:                         '
	dta d'  active banks:                         '
	dta d'                                        '
	dta d'                                        '
	dta d'                                        '
	
config_action
	dta d'      press START to enter config       '
	dta d'  press SPACE to continue or wait 5 sec '

detected_txt	dta d'detected + not supported    '
disabled_txt	dta d'but disabled                '
ram_size		dta d'192 208 224 240 256 272 288 304 320 336 352 368 384 400 416 432 448 464 480 496 512 528 544 560 576 592 608 624 640 656 672 688 704 720 736 752 768 784 800 816 832 848 864 880 896 912 928 944 960 976 992 100810241040105610721088'
converthex		dta d'0123456789abcdef'


///////////////////////////////////////////////////////////////////////////////
// procedura wype�niaj�ca bufor config_status danymi o konfiguracji
fill_config_info	.local
		//stereo
		lda config_stereo
		beq vbxe
		ldx #0
l1		lda detected_txt,x
		sta config_status+16,x	
		inx
		cpx #25
		bne l1
		
vbxe	//vbxe
		lda config_vbxe
		beq ramsize
		ldx #0
l2		lda detected_txt,x
		sta config_status+56,x
		inx
		cpx #13
		bne l2	
		ldx #0
l3		lda disabled_txt,x
		sta config_status+65,x
		inx
		cpx #15
		bne l3
		
ramsize	//wielko�� pami�ci
		lda config_ext_num_banks
		ldy #0
		sec
		sbc #8
		asl
		asl
		tax
lo7		lda ram_size,x
		sta config_status+96,y
		inx
		iny
		cpy #4
		bne lo7
		lda #"K"
		sta config_status+96,y+
		lda #"B"
		sta config_status+96,y

		// informacja o aktualnie aktywnych bankach		
.rept 4 #*40 #*4
		lda config_ext_banks+:2
		jsr convert_to_str
		stx config_status+136+:1
		sty	config_status+137+:1	
		lda config_ext_banks+:2+1
		jsr convert_to_str
		stx config_status+139+:1
		sty	config_status+140+:1			
		lda config_ext_banks+:2+2
		jsr convert_to_str
		stx config_status+142+:1
		sty	config_status+143+:1		
		lda config_ext_banks+:2+3
		jsr convert_to_str
		stx config_status+145+:1
		sty	config_status+146+:1
.endr		
		rts
.endl

///////////////////////////////////////////////////////////////////////////////
// procedura zamienia liczbe na string w hex
// in:  A - liczba do zamiany
// out: X - pierwszy znak liczby, Y - drugi znak liczby
convert_to_str	.local
	tay
	and #$f0
	lsr
	lsr
	lsr
	lsr
	tax
	lda converthex,x
	tax
	tya
	and #$0f
	tay
	lda converthex,y
	tay
	rts
.endl

///////////////////////////////////////////////////////////////////////////////
// procedura robi�ca fadeout
colors_down	.local
l3		ldx #0
		ldy #0
l2		lda 708,x
		pha
		and #$f0
		beq l1
		iny
		sec
		sbc #$10
l1		sta o1+1
		pla
		and #$f
		beq o1
		iny
		sec
		sbc #1
o1		ora #0
		sta 708,x
		inx
		cpx #5
		bne l2
		jsr wait_frame
		cpy #0
		bne l3
		rts
.endl


///////////////////////////////////////////////////////////////////////////////
// procedura czekaj�ca jedn� ramke
wait_frame	.local
		lda 20
		cmp 20
		beq *-2
		rts
.endl

///////////////////////////////////////////////////////////////////////////////
// g�owna procedura wykrywania hw i soft

detect_main	.local
		jsr check_memlo
		jsr check_sparta_mode
		jsr detect_ntsc
		jsr detect_xbios
		jsr detect_ext_ram
		lda config_ext_num_banks
		cmp #MIN_FREE_BANKS
		bcs	l1
		lda #2
		jsr display_error	
l1		jsr detect_stereo
		jmp detect_vbxe
.endl

///////////////////////////////////////////////////////////////////////////////
// detekcja pami�ci - kod z atariki autorstwa KMK
detect_ext_ram .local
       lda $d301
       pha

       ldx #$0f      ;zapami�tanie bajt�w ext (z 16 blok�w po 64k)
_p0    jsr setpb
       lda $4000
       sta bsav,x
       dex
       bpl _p0

       ldx #$0f      ;wyzerowanie ich (w oddzielnej p�tli, bo nie wiadomo
_p1    jsr setpb     ;kt�re kombinacje bit�w PORTB wybieraj� te same banki)
       lda #$00
       sta $4000
       dex
       bpl _p1

       stx $d301      ;eliminacja pami�ci podstawowej
       stx $4000
       stx $00        ;niezb�dne dla niekt�rych rozszerze� do 256k

       ldy #$00       ;p�tla zliczaj�ca bloki 64k
       ldx #$0f
_p2    jsr setpb
       lda $4000      ;je�li ext_b jest r�ne od zera, blok 64k ju� zliczony
       bne _n2
       dec $4000      ;w przeciwnym wypadku zaznacz jako zliczony
       lda $d301      ;wpisz warto�� PORTB do tablicy dla banku 0
       sta config_ext_banks,y
       eor #%00000100 ;uzupe�nij warto�ci dla bank�w 1, 2, 3
       sta config_ext_banks+1,y
       eor #%00001100
       sta config_ext_banks+2,y
       eor #%00000100
       sta config_ext_banks+3,y
       iny
       iny
       iny
       iny
_n2    dex
       bpl _p2

       ldx #$0f       ;przywr�cenie zawarto�ci ext
_p3    jsr setpb
       lda bsav,x
       sta $4000
       dex
       bpl _p3

       pla
       sta $d301
       sty config_ext_num_banks
       rts

; podprogramy
setpb  txa
       lsr            ;zmiana kolejno�ci bit�w: %0000dcba -> %cba000d0
       ror
       ror
       ror
       bcc _j1
       ora #%00000010
_j1    ora #%00001101 ;wyb�r pierwszego banku 16k w bloku 64k i ustawienie bitu steruj�cego OS ROM
       sta $d301
       rts
       
bsav   .ds 16
.endl

///////////////////////////////////////////////////////////////////////////////
// detekcja stereo - kod z atariki autorstwa KMK
detect_stereo	.local
		ldx #$00
		stx $d20f     ;halt pokey 0
		stx $d21f     ;halt pokey 1
		ldy #$03
		sty $d21f     ;release pokey 1
		lda $d20a     ;see if pokey 0 is halted ($d20a = $ff)
?loop	and $d20a
		inx
		bne ?loop
		sty $d20f
		cmp #$ff
		bne ?mono
		inx
?mono	stx config_stereo
		rts
.endl

///////////////////////////////////////////////////////////////////////////////
// detekcja NTSC
detect_ntsc		.local
		lda $D014
		cmp #1
		beq eend
		lda #1
		jmp display_error
eend	rts		
.endl

///////////////////////////////////////////////////////////////////////////////
// detekcja xbios
detect_xbios	.local
		lda $800
		cmp #'x'
		bne eend
		lda $801
		cmp #'B'
		bne eend
		lda #0
		jmp display_error
eend	rts
.endl

///////////////////////////////////////////////////////////////////////////////
// sprawdzenie memlo
check_memlo	.local
		cpw MEMLO #MAX_MEMLO+1
		bcc eend
		lda #3
		jmp display_error
eend	rts
.endl

///////////////////////////////////////////////////////////////////////////////
// sprawdzenie memlo

check_sparta_mode	.local
		jsr sparta_detect
		cmp #$ff
		beq eend
		cmp #$fe
		bne eend
		lda #4
		jmp display_error
eend	rts		
.endl
                   
sparta_detect .local
; sparta_detect.asm
; (c) idea by KMK, code: mikey
; $Id: sparta_detect.asm,v 1.2 2006/09/27 22:59:27 mikey Exp $


p0      = $f0
fsymbol = $07EB
; if peek($700) = 'S' and bit($701) sets V then we're SDX

                lda $0700
                cmp #$53         ; 'S'
                bne no_sparta
                lda $0701
                cmp #$40
                bcc no_sparta
                cmp #$44
                bcc _oldsdx

; we're running 4.4 - the old method is INVALID as of 4.42

                lda #<sym_t
                ldx #>sym_t
                jsr fsymbol
                sta p0
                stx p0+1
                ldy #$06
                bne _fv

; we're running SDX, find (DOSVEC)-$150 

_oldsdx         lda $a
                sec
                sbc #<$150
                sta p0
                lda $b
                sbc #>$150
                sta p0+1

; ok, hopefully we have established the address. 
; now peek at it. return the value. 

                ldy #0
_fv             lda (p0),y
                rts
no_sparta       lda #$ff 
                rts

sym_t           .byte "T_      "

; if A=$FF -> No SDX :(
; if A=$FE -> SDX is in OSROM mode
; if A=$00 -> SDX doesn't use any XMS banks
; if A=anything else -> BANKED mode, and A is the bank number 
.endl

///////////////////////////////////////////////////////////////////////////////
// detekcja vbxe - kod od Candle

;--------------------------------------------------------
;VBXE_Detect - detects VBXE FX core version 1.07 and above,
; and stores VBXE Base address in VBXEBase
detect_vbxe	.local
	lda	#0
	ldx	#0xd6
	sta	0xd640			; make sure it isn't coincidence
	lda	0xd640
	cmp	#0x10			; do we have major version here?
	beq	VBXE_FX_Detected	; if so, then VBXE FX core is detected
	lda	#0
	inx
	sta	0xd740			; no such luck, try other location
	lda	0xd740
	cmp	#0x10
	beq	VBXE_FX_Detected
	ldx #0  			; not here, so not present or FX core version too low
	stx	config_vbxe_page
	stx config_vbxe
	sec
	rts
VBXE_FX_Detected:
	stx	config_vbxe_page
	lda	#0
	vblda VBXE_MINOR
	and	#0x70			; disregard if this is A or R core version
	cmp	#(REVISION & 0x70)	; check if core revision is compatible with the software
	beq	VBXE_Detected
	lda #0
	sta config_vbxe
	sec
	rts
VBXE_Detected:
	stx	config_vbxe_page
	lda #1
	sta config_vbxe
	rts
.endl	
;--------------------------------------------------------
;vblda	- loads accumulator with VBXE register value
;	  use:	vblda	VBXE_REGISTER

vblda	.macro
.ifdef	__VBXE_AUTO__
	lda	config_vbxe_page
	sta	vblda_adr
	lda.w	:1
vblda_adr	equ *-1
.else
	lda	:1
.endif
.endm

;--------------------------------------------------------
;vbsta	- stores accumulator in VBXE register
;	  use:	vbsta	VBXE_REGISTER

vbsta	.macro
.ifdef	__VBXE_AUTO__
	pha
	lda	config_vbxe_page
	sta	vbsta_adr
	pla
	sta.w	:1
vbsta_adr	equ *-1
.else
	sta.w	:1
.endif
.endm

.def	__VBXE_AUTO__
.def	REVISION	=	0x20

.if .not .def __VBXE_AUTO__ .and .not .def __VBXE_D700__	; default case - vbxe at 0xd640
VBXE_BASE		equ	0xd600
.elseif .not .def __VBXE_AUTO__ .and def __VBXE_D700__		; vbxe is assumed to be under 0xd740
VBXE_BASE		equ	0xd700
.else								; vbxe should be autodetected
VBXE_BASE		equ	0x0000
.endif

VBXE_MAJOR		equ	VBXE_BASE+0x40
VBXE_MINOR		equ	VBXE_BASE+0x41
VBXE_VIDEO_CONTROL	equ	VBXE_BASE+0x40
	


///////////////////////////////////////////////////////////////////////////////
// wy�wietlanie komunikatu o b��dzie
//A = 0  - xbios
//A = 1  - NTSC
//A = 2	 - memory
//A = 3  - memlo
//A = 4  - sparta dos x in 

display_error	.local
		asl
		tax
		lda error_tab,x
		sta errordl+4
		lda error_tab+1,x
		sta errordl+5
		jsr wait_frame
		mva #0 COLOR2
		mva #34 SDMCTL 
		mwa #errordl SDLSTL
l1		lda random
		sta colpf1
		jmp l1
		
.align $100
errordl	:3 	dta b($70)
		:1	dta b($42),a(error_txt1)
		:1	dta b($41),a(errordl)
.align		
error_txt1 		dta d'      XBIOS loader not supported        '
				dta d'          NTSC not supported            '
				dta d'      To run the demo need 320KB        '
				dta d'     MEMLO must be less than 8183       '
				dta d'     SDX OSROM mode not supported       '
				
error_tab		dta a(error_txt1,error_txt1+40,error_txt1+80,error_txt1+120,error_txt1+160)			
.endl

///////////////////////////////////////////////////////////////////////////////
	icl '..\..\lib\fast_os.asm'

bank_swith 
	ins 'bank_switcher.obx'
bank_swith_end

os_data	
	ins '..\..\build\os.obx.bc'
end_os_data

//	run main
