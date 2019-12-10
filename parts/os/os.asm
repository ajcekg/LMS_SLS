		opt f+ h-
		org $D800-2
		dta a($D800)

	icl 'sls.hea'
	icl 'atari.hea'
	icl 'loader_config.hea'


zero_page_start		equ		2					//to jest to samo miejsce gdzie znajduje si� bufor bongo, nie mozna copiowac i depakowac w tym samym czasie
copysrc				equ		zero_page_start
copydst				equ		zero_page_start+2
copysize			equ		zero_page_start+4


		
		
// tablica funkcji 
		jmp BONGO_DECRUNCH
		jmp init_demo
		jmp prepare_next_part
		jmp enable_xcolor_mode
		jmp disable_xcolor_mode
		jmp set_player
		rts
end_jump_tab

///////////////////////////////////////////////////////////////////////////////////
/// memory management
active_bank	:MIN_FREE_BANKS dta b(0)

/// tablica z definicja jaka cz�� dema znajduje si� w jakim banku
/// pozycja 0   - indeks do tablicy active_bank
/// pozycja 1	- numer partu w banku
demo_part_ram_config
	dta b(0,0)		//trans to chess
	dta b(0,1) 		//emb fade out
	dta b(0,2) 		//chess
	dta b(1,0) 		//xor
	dta b(2,0)		//sinscroll
	dta b(3,0)		//hiphop
	dta b(0,3)		//meta
	dta b(4,0)		//worm
	dta b(1,1)		//logos
	dta b(5,0)		//carpet
	dta b(5,1)		//budda
	dta b(7,0)		//box picture
	dta b(6,0)		//boxes
	dta b(7,1)		//twist
	dta b(2,1)		//przejscie do anim to eclips
	dta b(8,0)		//tunnel
	dta b(9,0)		//anim
	dta b(9,1)		//credit
	dta b(11,0)		//vscroll 1
	dta b(10,0)		//vscroll 2_1
	dta b(3,1)		//vscroll 2_2
	dta b(0,4)		//go to gretz
	dta b(12,0)		//gretz 1 2
	dta b(11,1)		//gretz 2 2
	dta b(13,0)		//skull


/// na pocz�tku ka�dego banku znajduje si� tablica z konfiguracj� part�w, zawiera:
/// pozycja 0,1 - adres pocz�tku partu
/// pozycja 2,3 - d�ugo�� partu
/// pozycja 4,5 - adres uruchomienia

/// procedura przygotowuje i uruchamia kolejna czesc dema
/// wywolywana bez parametrow

prepare_next_part	.local
demo_part_cnt
		lda #0	//demo_part_cnt
		asl		//wyliczamy pozycje w demo_part_ram_config
		clc
		adc #<demo_part_ram_config
		sta 6
		lda #>demo_part_ram_config
		sta 7
		bcc *+4
		inc 7

		ldy #0		//wlacznie wlasciwego banku ext ram
		lda (6),y
		tax
		lda active_bank,x
		sta portb
		
		iny			// wyliczenie pozycji w tablicy konfiguracji danego banku
		lda (6),y
		asl
		sta m0+1
		asl
		clc
m0		adc #0
		tax
		lda $4000,x+
		sta copysrc
		lda $4000,x+
		sta copysrc+1
		lda $4000,x+
		sta copysize
		lda $4000,x+
		sta copysize+1
		lda $4000,x+
		sta r1+1
		lda $4000,x
		sta r1+2
		
		lda #<$d000
		sec
		sbc copysize
		sta copydst
		sta m1+1
		lda #>$d000
		sbc copysize+1
		sta copydst+1
		sta m2+1
		jsr copy_ram

		mva #$fe portb 
m1		lda #0
m2		ldy #0
		jsr BONGO_DECRUNCH
		inc demo_part_cnt+1
r1		jmp $2000
.endl

/////////////////////////////////////////////////////////////////////////

set_player	.local
	sta playeraddres
	stx playeraddres+1
	rts
.endl


/////////////////////////////////////////////////////////////////////////

enable_xcolor_mode .local
	lda #0
	bne *+3
	rts
	lda #2
m0	sta $d640
	rts
.endl

/////////////////////////////////////////////////////////////////////////

disable_xcolor_mode .local
	lda #0
	bne *+3
	rts
	lda #0
m0	sta $d640
	rts
.endl

/////////////////////////////////////////////////////////////////////////

init_demo	.local
		lda config_vbxe_on			//zezwolenie na vbxe
		sta enable_xcolor_mode+1
		sta disable_xcolor_mode+1
		lda config_vbxe_page
		sta enable_xcolor_mode.m0+2
		sta disable_xcolor_mode.m0+2
		ldx #MIN_FREE_BANKS-1		//pobranie danych a aktualnej konfiguracji bank�w pami�ci
l1		lda config_ext_banks,x
		and #$fe
		sta active_bank,x
		dex
		bpl l1
		
		ldx #<MSX_INTERNAL			//inicjalizacja rmtplayer i zerowanie licznika ramek
		ldy #>MSX_INTERNAL
		lda #0
		sta frmcnt
		sta frmcnt+1
		jsr RMTINIT
		
		mwa #nmi_handler nmivec		//ustawienie wektora przerwa� nmi i w��czenie przerwa�
		mva #$c0 nmien
		rts		
.endl


/////////////////////////////////////////////////////////////////////////
copy_ram	.local
		ldx copysize+1
		beq copy1
		ldy #0
l2		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+
		lda (copysrc),y
		sta (copydst),y+		
		bne l2
		inc copysrc+1
		inc copydst+1
		dex
		bne l2

copy1	ldy copysize
		beq end_copy
		ldy #0
l1		lda (copysrc),y
		sta (copydst),y
		iny
		cpy copysize
		bne l1
end_copy
rts_ad	rts
.endl

// depacker bongo	
bongodecrunch_start
	icl '..\..\lib\fast_noos.asm'
bongodecrunch_stop

// player i muzyka 
	org $db82
rmtplayer_start	
	ins "..\..\build\rmtplayr4.obx", +6
rmtplayer_end



///////////////////////////////////////////////////////////////////////////////////
/// handler obs�ugi przerwania nmi

		org	$FFdb
playeraddres equ plad+1
nmi_handler
		bit nmist
		bpl _vbl_main
dli_point	
		jmp int_exit

_vbl_main
		phr
		inw frmcnt
plad	jsr copy_ram.rts_ad
		plr
vbl_point	
		jmp int_exit
int_exit
		rti	
	