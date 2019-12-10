* G2F VSCROLL ENGINE v1.2
* 22.01.2007
cntr	dta a(0)
w_sta	dta b(0)
prg
	lda w_sta
	beq prg

	mva	#0	scrl
start

.local
loop
	ldy	#0
_down
	inw cntr
	cpw cntr #544
	bne *+3
	rts
	
	sty	vscrol

	UPDATE
	ldx	precision 
	_INW

l1	lda $D40B
	cmp #$69
	bne l1
l2	lda $D40B
	cmp #$68
	bne l2
_cnt
	tya
	add	precision
	tay
	and	#7
	bne	_down

	inc:ldy	scrl
	cpy	#ile
	beq	nxt

	jsr	CREATE._add
	jmp	loop
.end

nxt
	dec	scrl

	ldx:dex	precision
	seq
	_INW

.local
loop
	ldy	#7
_up
	sty	vscrol

	ldx	precision
	_DEW
	UPDATE

	lda:cmp:req clock

	tya
	sub	precision
	tay
	bpl	_up

	dec:ldy	scrl
	bne	_ok

	inc	scrl

	ldx:dex	precision
	seq
	_DEW

	jmp	start
_ok
	jsr	CREATE._sub
	jmp	loop
.end


_INW	.proc
	txa
	add	UPDATE.idx+1
	sta	UPDATE.idx+1
	bcc	_skp

	inc	UPDATE.vlo+2
	inc	UPDATE.vhi+2

	inc	UPDATE.dlo+2
	inc	UPDATE.dhi+2
	inc	UPDATE.dlo2+2
	inc	UPDATE.dhi2+2
_skp
	txa
	add	UPDATE._0+1
	sta	UPDATE._0+1
	sta	UPDATE._1+1
	sta	UPDATE._2+1
	sta	UPDATE._3+1
	sta	UPDATE._4+1
	bcc	_skp2
 
	inc	UPDATE._0+2
	inc	UPDATE._1+2
	inc	UPDATE._2+2
	inc	UPDATE._3+2
	inc	UPDATE._4+2
_skp2
	rts
	.end


_DEW	.proc
	stx	_sb0+1
	stx	_sb1+1

	lda	UPDATE.idx+1
	sec
_sb0	sbc	#0
	sta	UPDATE.idx+1
	bcs	_skp

	dec	UPDATE.vlo+2
	dec	UPDATE.vhi+2

	dec	UPDATE.dlo+2
	dec	UPDATE.dhi+2
	dec	UPDATE.dlo2+2
	dec	UPDATE.dhi2+2
_skp
	lda	UPDATE._0+1
	sec
_sb1	sbc	#0
	sta	UPDATE._0+1
	sta	UPDATE._1+1
	sta	UPDATE._2+1
	sta	UPDATE._3+1
	sta	UPDATE._4+1 
	bcs	_skp2
 
	dec	UPDATE._0+2
	dec	UPDATE._1+2
	dec	UPDATE._2+2
	dec	UPDATE._3+2
	dec	UPDATE._4+2
_skp2
	rts
	.end


UPDATE	.proc
	sty	oldY+1

idx	ldx	#0

vlo	mva	l_vbl,x	ivbl+1
vhi	mva	h_vbl,x	ivbl+2

	mwa	_temp+3	temp

	ldy	#0
	mva	_temp	(temp),y+
	mva	_temp+1	(temp),y+
	mva	_temp+2	(temp),y

dlo	mva	l_dli,x	ldli+1
	sta	dliv+1
dhi	mva	h_dli,x	hdli+1
	sta	dliv+2

dlo2	mva	l_dli+height*8-6,x	temp
	sta	_temp+3
dhi2	mva	h_dli+height*8-6,x	temp+1
	sta	_temp+4

	ldy	#0
	mva	(temp),y	_temp
	mva	#{jmp nmiQ}	(temp),y
	iny
	mva	(temp),y	_temp+1
	mva	<nmiQ		(temp),y
	iny
	mva	(temp),y	_temp+2
	mva	>nmiQ		(temp),y

?ofs = 16+((30-height-1)/2)*8-1

	ldx	#height*8-7

_0	mva	mis-1,x		pmg+$300+?ofs,x
_1	mva	pm0-1,x		pmg+$400+?ofs,x
_2	mva	pm1-1,x		pmg+$500+?ofs,x
_3	mva	pm2-1,x		pmg+$600+?ofs,x
_4	mva	pm3-1,x		pmg+$700+?ofs,x

	dex
	bne	_0

oldY	ldy	#0
	rts

_temp	.ds 5
	.end


CREATE	.proc

	ift rows
_add
_sub
_nxt
	lda	f_fnt,y
	sta	ffnt+1
	sta	chbase

	.rept height
	lda gfxmode+.r,y
	
	ift .r=height-1
	and	#[$20^$ff]
	eif

	ora #$40
	sta scr+.r*3
	mva	l_scr+.r,y	scr+.r*3+1
	mva	h_scr+.r,y	scr+.r*3+2
	.endr

	els

_add	adw	scr+1	#width
	jmp	_nxt
_sub
	sbw	scr+1	#width
_nxt
	lda	f_fnt,y
	sta	ffnt+1
	sta	chbase

	lda	 gfxmode,y
	ora	#$40
	sta	scr

	:height-2	mva gfxmode+1+.r,y scr+3+.r

	lda	gfxmode+2+height-3,y
	and	#[$20^$ff]
	sta	scr+4+height-3

	eif

	rts
	.end


INIT	.proc
	mva	l_dli+height*8-6	temp
	sta	UPDATE._temp+3
	mva	h_dli+height*8-6	temp+1
	sta	UPDATE._temp+4

	ldy	#0
	tya
clr	:5 sta pmg+$300+#*$100,y
	iny
	bne	clr

	mva	(temp),y	UPDATE._temp
	mva	#{jmp nmiQ}	(temp),y
	iny
	mva	(temp),y	UPDATE._temp+1
	mva	<nmiQ		(temp),y
	iny
	mva	(temp),y	UPDATE._temp+2
	mva	>nmiQ		(temp),y
	rts
	.end

precision dta 1		; 1, 2, 4, 8

f_fnt	:ile+30	dta h(fnt+.get[#]*$400)

scrl	brk
