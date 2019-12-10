
frmcnt			equ		$00
end_eff			equ		$1b			//pomocniczy marker okreslajacy czy dany eff juz siê skoñczy³
regA			equ		$1c
regX			equ		$1d
regY			equ		$1e
first_free_zp	equ 	$1f			//address of first free byte on zero page

restore_vbl	.macro
		mwa #int_exit vblvec
.endm

restore_dli	.macro
		mwa #_dli_main vbivec
.endm

restore_nmi	.macro
	restore_vbl
	restore_dli
.endm

set_vbl		.macro
		mwa #:1 vblvec
.endm

set_dli		.macro
		mwa #:1 vbivec
.endm

set_dli_lo	.macro		//jeden parametr, okreœla mlodszy bajt adresu nowej procedury dli
						//jesli kilka procedur dli znajduje siê na tej samej stronie pamiêci to 
						//uzycie tego macra oszczêdza nam 6 cykli podczas prze³¹czania siê na now¹ procedurê
		mva #:1 vbivec
.endm

set_turbo_dli	.macro	//jeden parametr, okreœla adres nowej procedury dli
		mwa #:1 nmivec
.endm		

set_turbo_dli_lo .macro	//jeden parametr, okreœla mlodszy bajt adresu nowej procedury dli, reszta opisu przy set_dli_lo
		mva #:1 nmivec
.endm		

restore_normal_nmi	.macro	//parametrów brak, przywraca normaln¹ obs³ugê przerwañ nmi
		mwa #nmi_main nmivec
.endm	


utils_wait_one_frame	.macro 
.DEF :wait_one_frame
.local
		lda frmcnt
		cmp frmcnt
		beq *-2
		rts
.endl
.endm

utils_wait_end_frame	.macro
.DEF :wait_end_frame
.local
	lda vcount
	cmp #$79
	bcc *-5
	rts
.endl	
.endm

utils_wait_x_frame	.macro	//liczba ramek do odczekania w A (pozwala czekoaæ od 1 do 255 ramek)
.DEF :wait_x_frame
.local
		sta m0+1
m0		lda #0
		beq eend
		dec m0+1		
		lda frmcnt
		cmp frmcnt
		beq *-2
		jmp m0
eend	rts
.endl
.endm


vbivec	equ vbi_point+1
vblvec	equ vbl_point+1

rom_off
	lda 20
	cmp 20
	beq *-2

 	sei
	mva #0 nmien
	mva #$fe portb   
	mwa #nmi_main nmivec
	mva #$c0 nmien
	rts
	
nmi_main
	bit nmist
	bpl _vbl_main
vbi_point	
	jmp _dli_main

_vbl_main
	pha
	inw frmcnt
	lda #0	
_vbl_l1
	sta wsync
	clc
	adc #1
	cmp #13
	bcc _vbl_l1
	pla
vbl_point	
	jmp int_exit
int_exit
	rti	

_dli_main
	rti

PM_X1_M_OFFSET		equ	$300
PM_X1_P0_OFFSET		equ	$400
PM_X1_P1_OFFSET		equ	$500
PM_X1_P2_OFFSET		equ	$600
PM_X1_P3_OFFSET		equ	$700

PM_X2_M_OFFSET		equ	$180
PM_X2_P0_OFFSET		equ	$200
PM_X2_P1_OFFSET		equ	$280
PM_X2_P2_OFFSET		equ	$300
PM_X2_P3_OFFSET		equ	$380


pm_x1_clear_mem_short	.macro // pierwszy parametr to adres pacz¹tku bufora pm, drugi to dana jak¹ wype³nic bufor
		ldy #0
		lda #:2
l:2		sta :1+PM_X1_M_OFFSET,y											
		sta :1+PM_X1_P0_OFFSET,y											
		sta :1+PM_X1_P1_OFFSET,y										
		sta :1+PM_X1_P2_OFFSET,y										
		sta :1+PM_X1_P3_OFFSET,y
		iny
		bne l:2
.endm	

pm_x2_clear_mem_short	.macro // pierwszy parametr to adres pacz¹tku bufora pm, drugi to dana jak¹ wype³nic bufor
		ldy #0
		lda #:2
l:2		sta :1+PM_X2_M_OFFSET,y											
		sta :1+PM_X2_P0_OFFSET,y											
		sta :1+PM_X2_P1_OFFSET,y										
		sta :1+PM_X2_P2_OFFSET,y										
		sta :1+PM_X2_P3_OFFSET,y
		iny
		bpl l:2
.endm

pm_set_size	.macro	//jeden parametr okresla szerokoœæ pm 0-normal, 1-x2, 3-x4
		lda #:1
		sta sizep0	
		sta sizep1	
		sta sizep2	
		sta sizep3
		lda #((:1<<6)|(:1<<4)|(:1<<2)|(:1))
		sta sizem
.endm

pm_out_of_screen	.macro	//przesuwa wszystkie pm poza ektan
		lda #255
		sta hposp0
		sta hposp1
		sta hposp2
		sta hposp3
		sta hposm0
		sta hposm1
		sta hposm2
		sta hposm3
.endm

pm_set_all_color	.macro	//ustawienie kolorow pm na wartosc param 1
		lda #:1
		sta colpm0	
		sta colpm1	
		sta colpm2	
		sta colpm3
.endm

