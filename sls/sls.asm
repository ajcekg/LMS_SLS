	icl 'sls.hea'
	icl 'atari.hea'

///////////////////////////////////////////////////////////////////////////
/// pierwszy blok ini
/// zawiera detekt hw, konfigurator, bank switcher, micro os
/// po zakoñczonej pracy konfiguracja jest na zp od $80
/// ekran widoczny w trakcie wczytywania jest od $2000 i zajmuje +- $600

	org $8000
	
pack_loader
	ins '..\build\config_detecthw.obx.bc'
	
install_loader	.local
		lda #<pack_loader
		ldy #>pack_loader
		jsr BONGO_DECRUNCH
		jsr $2000-3
		jmp SET_NEXT_BANK

	icl '..\lib\fast_os.asm'
.endl

	ini install_loader	

//////////////////////////////////////////////////
bank0	.local
	org $4000
	dta a(p0,p1-p0,$1000)
	dta a(p1,p2-p1,$400)
	dta a(p2,p3-p2,$4000)
	dta a(p3,p4-p3,$4000)
	dta a(p4,p5-p4,$400)

p0	ins '..\build\02_trans_to_chess.obx.bc'
p1  ins '..\build\03_go_to_chess.obx.bc'
p2  ins '..\build\04_chess.obx.bc'
p3	ins '..\build\08_meta.obx.bc'
p4	ins '..\build\21_go_to_gretz.obx.bc'
p5	
.print 'free space in bank 0: ', $7fff-p5
	ert *>=$8000,'Out of bank 0'
	ini SET_NEXT_BANK
.endl
;
;//////////////////////////////////////////////////
bank1	.local
	org $4000
	dta a(p0,p1-p0,$4000)
	dta a(p1,p2-p1,$4000)
		
p0	ins '..\build\05_xor.obx.bc'
p1	ins '..\build\10_logos.obx.bc'
p2  
.print 'free space in bank 1: ', $7fff-p2
	ert *>=$8000,'Out of bank 1'
	ini SET_NEXT_BANK
.endl
;
;//////////////////////////////////////////////////
bank2	.local
	org $4000
	dta a(p0,p1-p0,$a00)
	dta a(p1,p2-p1,OS_RTS)

p0	ins '..\build\06_sinscroll.obx.bc'
p1	ins '..\build\16_go_to_trans_to_credit.obx.bc'
p2
.print 'free space in bank 2: ', $7fff-p2
	ert *>=$8000,'Out of bank 2'
	ini SET_NEXT_BANK
.endl
;
;//////////////////////////////////////////////////
bank3	.local
	org $4000
	dta a(p0,p1-p0,$1000)
	dta a(p1,p2-p1,$1000)	
	
p0	ins '..\build\07_hiphop.obx.bc'
p1	ins '..\build\20_vscoll2_ab_a0.bc'
p2
.print 'free space in bank 3: ', $7fff-p2
	ert *>=$8000,'Out of bank 3'
	ini SET_NEXT_BANK
.endl
;
;//////////////////////////////////////////////////
bank4	.local
	org $4000
	dta a(p0,p1-p0,$4000)

p0	ins '..\build\09_worm.obx.bc'
p1
.print 'free space in bank 4: ', $7fff-p1
	ert *>=$8000,'Out of bank 4'
	ini SET_NEXT_BANK
.endl
;
;//////////////////////////////////////////////////
bank5	.local
	org $4000
	dta a(p0,p1-p0,$2000)
	dta a(p1,p2-p1,$1000)	
	
p0	ins '..\build\11_carpet.obx.bc'
p1	ins '..\build\12_budda.obx.bc'
p2
.print 'free space in bank 5: ', $7fff-p2
	ert *>=$8000,'Out of bank 5'
	ini SET_NEXT_BANK
.endl
;//////////////////////////////////////////////////
bank6	.local
	org $4000
	dta a(p0,p1-p0,$1000)
	
p0	ins '..\build\14_boxes.obx.bc'
p1
.print 'free space in bank 6: ', $7fff-p1
	ert *>=$8000,'Out of bank 6'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank7	.local
	org $4000
	dta a(p0,p1-p0,$2000)
	dta a(p1,p2-p1,$3000)
		
p0	ins '..\build\13_boxpic.obx.bc'
p1  ins '..\build\15_twist.obx.bc'
p2
.print 'free space in bank 7: ', $7fff-p2
	ert *>=$8000,'Out of bank 7'
	ini SET_NEXT_BANK
.endl

//////////////////////////////////////////////////
bank8	.local
	org $4000
	dta a(p0,p1-p0,$4000)
		
p0	ins '..\build\16_tunnel.obx.bc'
p1
.print 'free space in bank 8: ', $7fff-p1
	ert *>=$8000,'Out of bank 8'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank9	.local
	org $4000
	dta a(p0,p1-p0,$2000-3)
	dta a(p1,p2-p1,$5000-$400-3)
		
p0	ins '..\build\17_anim.obx.bc'
p1  ins '..\build\18_credits.obx.bc'
p2
.print 'free space in bank 9: ', $7fff-p2
	ert *>=$8000,'Out of bank 9'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank10	.local
	org $4000
	dta a(p0,p1-p0,OS_PREP_NEXT_PART)
		
p0	ins '..\build\20_vscoll2_aa.bc'
p1

.print 'free space in bank 10: ', $7fff-p1
	ert *>=$8000,'Out of bank 10'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank11	.local
	org $4000
	dta a(p0,p1-p0,$3000-3)
	dta a(p1,p2-p1,$1000)
		
p0	ins '..\build\19_vscroll1.obx.bc'
p1  ins '..\build\22_wavexy_ab_a0.bc'
p2

.print 'free space in bank 11: ', $7fff-p2
	ert *>=$8000,'Out of bank 11'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank12	.local
	org $4000
	dta a(p0,p1-p0,OS_PREP_NEXT_PART)
		
p0	ins '..\build\22_wavexy_aa.bc'
p1

.print 'free space in bank 12: ', $7fff-p1
	ert *>=$8000,'Out of bank 12'
	ini SET_NEXT_BANK
.endl

;//////////////////////////////////////////////////
bank13	.local
	org $4000
	dta a(p0,p1-p0,$1000)
		
p0	ins '..\build\23_skull.obx.bc'
p1

.print 'free space in bank 13: ', $7fff-p1
	ert *>=$8000,'Out of bank 13'
	//ini SET_NEXT_BANK
.endl

//////////////////////////////////////////////////////////////////
		org $8600
pborn .local
		ins '..\build\01_startscr.obx.bc'
pborn_end_mem		
.endl
	
//////////////////////////////////////////////////

	org $610
go_go_go_rock_and_roll	.local
		sei
		mva #0 nmien
		lda #$fe
		sta portb
		jsr OS_INIT

		lda #0
		sta colpm0
		sta colpm1
		lda #3
		sta sizep0
		sta sizep1
		lda #255
		sta grafp0
		sta grafp1
		lda #16
		sta hposp0
		lda #208
		sta hposp1
		lda #1
		sta gtictl
		
		ldy #16
l0		lda frmcnt
		cmp frmcnt
		beq *-2
		lda frmcnt
		cmp frmcnt
		beq *-2		
c0		ldx #$00
		cpx #$02
		beq ww
		stx colbak
		inc c0+1
		jmp c2
ww		mva #$62 colbak			
c2		ldx #$26
		cpx #$22
		beq ec2
		stx colpf2
		dec c2+1
		jmp c1
ec2		mva #$62 colpf2	
c1		ldx #$34
		cpx #$32
		beq ec1
		stx colpf1
		dec c1+1
		jmp c3
ec1		mva #$62 colpf1		
c3		ldx #$1e
		cpx #$12
		beq	qq
		stx colpf3
		dec c3+1
		jmp el0
qq		mva #$62 colpf3
el0		dey
		bne l0
		
		lda frmcnt
		cmp frmcnt
		beq *-2
		mva #0 dmactl
		
t0		lda frmcnt
		cmp frmcnt
		beq *-2
		dec t2+1
		inc t1+1
t2		lda #16
		bmi eee
		sta hposp0
t1		lda #208
		sta hposp1				
		jmp t0
		
eee		lda #0
		sta grafp0
		sta grafp1
		lda #<pborn
		ldy #>pborn
		jsr OS_DECRUNCH
		jmp $1000

.endl
	run go_go_go_rock_and_roll