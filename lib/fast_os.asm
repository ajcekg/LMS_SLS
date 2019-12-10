; BONGO RECURSIVE DE-CRUNCHER - WEGI 2013.02.13
; WITH GOLDEN SEQUENCES SERVICE
; FAST VERSION	
;
; optimize for upspeed help me Bitbreaker
; thanks a lot Toby




;=======
BONGO_DECRUNCH	.local

;---
RECURSIVE = 2 ; <> 1 no recursive decruncher (21 bytes shorted)
GOLDEN_SEQ_USED = 1 ; <> 1 without golden seq decruncher (46 bytes shorted + optional 48 bytes for golden seq table)
;---
LENGTH		= $f0 
STREAM_BYTE	= LENGTH +1
PUT			= LENGTH+2
COPY_SEQ		= LENGTH+4
;---

        ;---------------------------------------------
        ; FIRST ENTRY POINT TO DECRUNCHER
        ; IN ACC LO BYTE DATA ADDRESS IN Y HI BYTE
        ;---------------------------------------------
                sta COPY_SEQ      ;LO BYTE START DATA
                sty COPY_SEQ+1    ;HI BYTE

                ldy #$00
                sty STREAM_BYTE
                lda (COPY_SEQ),y
.if RECURSIVE = 1                
			 STA ITERATOR
.endif
        ;----------------------------
        ; BELLOW IF YOU MAKE DECRUNCH
        ; INTO YOUR AREA BEFORE YOU
        ; MUST SET THE PUT VECTOR
        ; AND GET2 VECTOR
        ;----------------------------

                pha ;remember A
.if GOLDEN_SEQ_USED = 1
                and #$3f
                sta LENGTH
                bne l1
l2
                lda (COPY_SEQ),y
                sta SEQENCES-1,y
l1
                iny
                cpy LENGTH
                bne l2
.else
			 iny
.endif
			                
                pla ;restore A

                bpl l3
                
                lda (COPY_SEQ),y
                sta PUT
.if RECURSIVE = 1
                STA GET2LO
.endif
                iny
                lda (COPY_SEQ),y
                sta PUT+1
.if RECURSIVE = 1
                STA GET2HI
.endif
;                iny
l3
                tya 
                ;clc
                SEC
                adc COPY_SEQ     ;move all offset to x and keep lowbyte to zero! then no page boundaries will be crossed on lda $1111,x and also we can store x easily as lowbyte instead of index
                tax
                lda #$00
                adc COPY_SEQ+1
                sta MGET1HI
                sta MGET2HI

;**********************
;* MAIN DECRUNCH LOOP *
;**********************
DECRUNCH_LOOP
                asl STREAM_BYTE
                bne *+5
                jsr GET_STREAM_BYTE      ;A can be trashed
                bcc IS_UNCRUNCH

                asl STREAM_BYTE
                bne *+5
                jsr GET_STREAM_BYTE      ;A can be trashed
                bcs COPY_ONLY_1          ;never zero, rol would set zero flag in case

                jsr GET3_OR_6BITS        ;sets Y to 0
                sta LENGTH
                cmp #$00
                bne LOOP_COPY
                beq CHECK_PAGE
;---
COPY_ONLY_1
                ldy #$01
                sty LENGTH
                dey
                sty COPY_SEQ+1
;=================
LOOP_COPY       ;Y = #$00
MGET2HI = *+2
                lda $1000,x
                sta (PUT),y
                inx
                bne l4
                jsr BIG_INCR
l4
                inc PUT
                bne *+4
                inc PUT+1
                dec LENGTH
                bne LOOP_COPY
;---
CHECK_PAGE
                lda COPY_SEQ+1
                beq IS_UNCRUNCH
                dec COPY_SEQ+1
                jmp LOOP_COPY
                
IS_UNCRUNCH
                ldy #$03    ;used in SHORT_C and as A later on

                asl STREAM_BYTE
                bne *+5
                jsr GET_STREAM_BYTE    ;A can be trashed
                lda #$02    ;2 BYTES SEQ?
                bcc SHORT_C

                asl STREAM_BYTE
                bne *+5
                jsr GET_STREAM_BYTE    ;A can be trashed
                tya         ;A = Y = 3
                bcc START_UNCRUNCH

                jsr GET3MANYBITS
                tay
.if GOLDEN_SEQ_USED = 1
                beq CHECK_SEQ
.endif
                lda #$01
                jsr GETCRUNCHBYTES
                cmp #4
                bcs START_UNCRUNCH
;=====
EOF
.if RECURSIVE = 1
ITERATOR = *+1
			LDA #$00
			ASL
			BPL l5
GET2LO = *+1
			LDA #$00
GET2HI = *+1
			LDY #$00
			JMP DECRUNCH
l5               
.endif
                ;clc       ;MAYBE FOR PARTIAL LOAD INDICATOR
                rts

;-----------------------------
;HERE SERVICE GOLDEN SEQUENCES
;-----------------------------
.if GOLDEN_SEQ_USED = 1
CHECK_SEQ
                ldy #4
                jsr GETMANYBITS ;GET4BITS

                ;NR OF SEQ *3
                sta LENGTH
                asl
                adc LENGTH
                tay
;===
                lda SEQENCES,Y
                sta LENGTH_+1

                lda SEQENCES+2,Y ;OFFSET HI BYTE
                sta COPY_SEQ+1
                lda SEQENCES+1,Y ;OFFSET LO BYTE
                ldy #$00
                beq SHORT_WAY
.endif
;===================================================
;=============      UNCRUNCHING      ===============
;===================================================
START_UNCRUNCH
                ldy #$04         ;4 BITS FOR >2 BYTES SEQ
SHORT_C
                sta LENGTH_+1
                jsr GET_Y_BYTES  ;GET 3 OR 4 BITS
;***************************************************
SHORT_WAY
                ;SUBSTRACT OFFSET
                eor #$ff         ;-COPY_SEQ + PUT = PUT - COPY_SEQ :-) -> COPY_SEQ ^ $ff + 1 (carry!) + PUT
                sec
                adc PUT
                sta CP+1
                lda PUT+1
                sbc COPY_SEQ+1
                sta CP+2
;---
                ;Y = 0
l6
CP              lda $1000,y
                sta (PUT),y
                iny
LENGTH_         cpy #$00
                bne l6

                tya
                clc
                adc PUT
                sta PUT
                bcc *+4
                inc PUT+1
                jmp DECRUNCH_LOOP
;==========================
GET_STREAM_BIT
                ;asl STREAM_BYTE
                ;beq GET_STREAM_BYTE
                ;rts

GET_STREAM_BYTE
                ;A is trashed, but in most cases this is no problem
MGET1HI = *+2
                lda $1000,x   ;we could do lda #$01 + slo $1000,x instead of the next three commands but slo takes 7 cycles, dammit :-)
                sec
                rol
                sta STREAM_BYTE
                inx
                beq BIG_INCR
                rts
;---
BIG_INCR
                inc MGET1HI
                inc MGET2HI

                ;sec ; FOR FUTURE USE
                rts
;============
GET3MANYBITS
                ldy #3             ;fetch 3 bits
GETMANYBITS                        ;Y holds the number of bits to fetch
                lda #$00
GETCRUNCHBYTES
l7
                asl STREAM_BYTE
                bne *+7
                pha
                jsr GET_STREAM_BYTE
                pla
                rol
                dey
                bne l7
                rts
;===
GET3_OR_6BITS
                jsr GET3MANYBITS    ;sets Y to 0
                cmp #7
                bne GETBYTESTOCOPY

                jsr GET3MANYBITS    ;IN ACC #BITS - 7 , C=0, sets Y to 0
                adc #7
                bne GETBYTESTOCOPY
GET_Y_BYTES
                jsr GETMANYBITS     ;sets Y to 0, A is already 0, actually no need to set it to 0 again @GETMANYBITS

GETBYTESTOCOPY  ;why can it happen that we shall copy 0 bytes? can't we avoid that case while packing?!
                ;ldy #$00 y is always 0
                sty COPY_SEQ+1
                tay
                beq LOWER

                lda #$01
                cpy #$08
                bcc GETCRUNCHBYTES  ;we fetch too less bits to be able to rol anything into COPY_SEQ+1, so we take the faster version
l8
                asl STREAM_BYTE
                bne *+7
                pha
                jsr GET_STREAM_BYTE
                pla
                rol
                rol COPY_SEQ+1
                dey
                bne l8
                rts
LOWER
                lda #$01
                rts
;---
_DECRUNCHER_LENGTH = * -BONGO_DECRUNCH
;====
.if GOLDEN_SEQ_USED = 1
SEQENCES = *
.endif
;---------------------------------------------
; 48 BYTES MAX FOR MY LOVELLY GOLDEN SEQUENCES
; OF COURSE - YOU CAN CHANGE SEQ ADDRESS
;---------------------------------------------	
	:48 dta b(0)
.endl	
	
