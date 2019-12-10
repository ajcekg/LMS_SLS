PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$2000
RUN_ADDRESS		equ	main

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

fcnt	equ first_free_zp
fadr	equ first_free_zp+2

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
	jmp main
.else
	org LOAD_ADDRESS
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'	
.endif

	utils_wait_end_frame
	utils_wait_one_frame
	utils_wait_x_frame

ant	dta $C4,a(scr)
	dta $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	dta $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	dta $41,a(ant)

scr	ins "data\blocks.scr"

	.ALIGN $0400
fnt	ins "data\blocks.fnt"

.local main
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2		
.endif
	jsr wait_one_frame
	mva #0 colbak
	jsr wait_one_frame
	mva #0 dmactl
	jsr save_color_00
	jsr wait_one_frame
	restore_nmi
	mva >pmg pmbase
	mva #$03 pmcntl
	set_vbl vblk
	set_dli dli_start


l0	ldx #16
	beq l1
	dec l0+1
	jsr wait_one_frame
	jsr fade_in
	jmp l0
	
	
	
l1	lda #200
	jsr wait_x_frame
	
l2	ldx #16
	beq l3
	dec l2+1
	jsr wait_one_frame
	jsr fade_out
	jmp l2
	
l3	jsr wait_one_frame
	restore_nmi
	lda #0
	sta colbak
	sta dmactl
.if PGENE = 0
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400
.else
	jmp *
.endif
.endl
/////////////////////////////////////////////////////////////////////

.local	save_color_00
.rept 8 #
	lda vblk.c:1+1
	sta fade_in.cm:1+1
	and #$f0
	sta vblk.c:1+1
.endr
.rept 240 #+8
	lda dli_start.c:1+1
	sta fade_in.cm:1+1
	and #$f0
	sta dli_start.c:1+1
.endr
	rts
.endl

.local fade_in
.rept 8 # 
	ldx vblk.c:1+1
cm:1 cpx #0
	beq n:1
	inc vblk.c:1+1
n:1	
.endr

.rept 240 #+8
	ldx dli_start.c:1+1
cm:1 cpx #0
	beq n:1
	inc dli_start.c:1+1
n:1	
.endr
	rts
.endl

.local fade_out
.rept 8 # 
	lda vblk.c:1+1
	and #$0f
	beq n:1
	dec vblk.c:1+1
n:1	
.endr

.rept 240 #+8
	lda dli_start.c:1+1
	and #$0f
	beq n:1
	dec dli_start.c:1+1
n:1	
.endr
	rts
.endl

tcolend


/////////////////////////////////////////////////////////////////////
.local vblk
	sta regA
	stx regX
	sty regY
	sta nmist
	mwa #ant dlptr
	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl
	lda >fnt+$400*$00
	sta chbase
c0	lda #$2A
	sta colbak
c1	lda #$06
	sta color0
c2	lda #$36
	sta color1
c3	lda #$0E
	sta color2
	sta color3
	lda #$02
	sta chrctl
	lda #$04
	sta gtictl
s0	lda #$03
	sta sizep0
x0	lda #$5D
	sta hposp0
c4	lda #$B8
	sta colpm0
s1	lda #$01
	sta sizem
x1	lda #$7C
	sta hposm0
s2	lda #$03
	sta sizep1
x2	lda #$6B
	sta hposp1
c5	lda #$06
	sta colpm1
s3	lda #$03
	sta sizep2
x3	lda #$6C
	sta hposp2
c6	lda #$38
	sta colpm2
s4	lda #$01
	sta sizep3
x4	lda #$83
	sta hposp3
c7	lda #$6A
	sta colpm3
x5	lda #$73
	sta hposm1
x6	lda #$80
	sta hposm3
x7	lda #$00
	sta hposm2
quit
	lda regA
	ldx regX
	ldy regY
	rti
.endl

.local dli_start

dli4
	sta regA
	stx regX
	sty regY

	sta wsync		;line=8
c8	lda #$2E
	sta wsync		;line=9
	sta color3
c9	lda #$0E
	sta wsync		;line=10
	sta color3
c10	lda #$2E
	sta wsync		;line=11
	sta color3
c11	lda #$0E
	sta wsync		;line=12
	sta color3
c12	lda #$2E
	sta wsync		;line=13
	sta color3
c13	lda #$0E
	sta wsync		;line=14
	sta color3
c14	lda #$2E
	sta wsync		;line=15
	sta color3
c15	lda #$0E
	sta wsync		;line=16
	sta color3
c16	lda #$2E
	sta wsync		;line=17
	sta color3
c17	lda #$0E
	sta wsync		;line=18
	sta color3
c18	lda #$2E
	sta wsync		;line=19
	sta color3
c19	lda #$0E
	sta wsync		;line=20
	sta color3
c20	lda #$2E
	sta wsync		;line=21
	sta color3
c21	lda #$0E
	sta wsync		;line=22
	sta color3
c22	lda #$2E
	sta wsync		;line=23
	sta color3
c23	lda #$0E
	sta wsync		;line=24
	sta color3
c24	lda #$2E
	sta wsync		;line=25
	sta color3
c25	lda #$0E
	sta wsync		;line=26
	sta color3
c26	lda #$2E
	sta wsync		;line=27
	sta color3
c27	lda #$0E
	sta wsync		;line=28
	sta color3
c28	lda #$2E
	sta wsync		;line=29
	sta color3
c29	lda #$0E
	sta wsync		;line=30
	sta color3
c30	lda #$2E
	sta wsync		;line=31
	sta color3
c31	lda #$0E
	sta wsync		;line=32
	sta color3
c32	lda #$2E
	sta wsync		;line=33
	sta color3
c33	lda #$0E
	sta wsync		;line=34
	sta color3
c34	lda #$2E
	sta wsync		;line=35
	sta color3
c35	lda #$0E
	sta wsync		;line=36
	sta color3
c36	lda #$2E
	sta wsync		;line=37
	sta color3
c37	lda #$0E
	sta wsync		;line=38
	sta color3
c38	lda #$2E
	sta wsync		;line=39
	sta color3
c39	lda #$0E
	sta wsync		;line=40
	sta color3
c40	lda #$2E
	sta wsync		;line=41
	sta color3
c41	lda #$0E
	sta wsync		;line=42
	sta color3
c42	lda #$2E
	sta wsync		;line=43
	sta color3
c43	lda #$0E
	sta wsync		;line=44
	sta color3
c44	lda #$2E
	sta wsync		;line=45
	sta color3
c45	lda #$0E
	sta wsync		;line=46
	sta color3
c46	lda #$2E
	sta wsync		;line=47
	sta color3
c47	lda #$0E
	sta wsync		;line=48
	sta color3
c48	lda #$2E
	sta wsync		;line=49
	sta color3
c49	lda #$0E
	sta wsync		;line=50
	sta color3
c50	lda #$2E
	sta wsync		;line=51
	sta color3
c51	lda #$0E
	sta wsync		;line=52
	sta color3
c52	lda #$2E
	sta wsync		;line=53
	sta color3
c53	lda #$0E
	sta wsync		;line=54
	sta color3
c54	lda #$2E
	sta wsync		;line=55
	sta color3
c55	lda #$0E
	sta wsync		;line=56
	sta color3
c56	lda #$2E
	sta wsync		;line=57
	sta color3
c57	lda #$0E
	sta wsync		;line=58
	sta color3
c58	lda #$2E
	sta wsync		;line=59
	sta color3
c59	lda #$0E
	sta wsync		;line=60
	sta color3
c60	lda #$2E
	sta wsync		;line=61
	sta color3
c61	lda #$0E
	sta wsync		;line=62
	sta color3
c62	lda #$2E
	sta wsync		;line=63
	sta color3
	lda >fnt+$400*$01
c63	ldx #$0E
	sta wsync		;line=64
	sta chbase
	stx color3
c64	lda #$2E
	sta wsync		;line=65
	sta color3
c65	lda #$0E
	sta wsync		;line=66
	sta color3
c66	lda #$2E
	sta wsync		;line=67
	sta color3
c67	lda #$0E
	sta wsync		;line=68
	sta color3
c68	lda #$2E
	sta wsync		;line=69
	sta color3
c69	lda #$0E
	sta wsync		;line=70
	sta color3
c70	lda #$2E
	sta wsync		;line=71
	sta color3
c71	lda #$0E
	sta wsync		;line=72
	sta color3
c72	lda #$2E
	sta wsync		;line=73
	sta color3
c73	lda #$0E
	sta wsync		;line=74
	sta color3
c74	lda #$2E
	sta wsync		;line=75
	sta color3
c75	lda #$0E
	sta wsync		;line=76
	sta color3
c76	lda #$2E
	sta wsync		;line=77
	sta color3
c77	lda #$0E
	sta wsync		;line=78
	sta color3
c78	lda #$2E
	sta wsync		;line=79
	sta color3
c79	lda #$0E
	sta wsync		;line=80
	sta color3
c80	lda #$2E
	sta wsync		;line=81
	sta color3
c81	lda #$0E
	sta wsync		;line=82
	sta color3
c82	lda #$2E
	sta wsync		;line=83
	sta color3
c83	lda #$0E
	sta wsync		;line=84
	sta color3
c84	lda #$2E
	sta wsync		;line=85
	sta color3
c85	lda #$0E
	sta wsync		;line=86
	sta color3
c86	lda #$2E
	sta wsync		;line=87
	sta color3
c87	lda #$0E
	sta wsync		;line=88
	sta color3
c88	lda #$2E
	sta wsync		;line=89
	sta color3
c89	lda #$0E
	sta wsync		;line=90
	sta color3
c90	lda #$2E
	sta wsync		;line=91
	sta color3
c91	lda #$0E
	sta wsync		;line=92
	sta color3
c92	lda #$2E
c93	ldx #$78
	sta wsync		;line=93
	sta color3
	stx colpm1
c94	lda #$0E
	sta wsync		;line=94
	sta color3
c95	lda #$2E
	sta wsync		;line=95
	sta color3
c96	lda #$0E
	sta wsync		;line=96
	sta color3
c97	lda #$2E
	sta wsync		;line=97
	sta color3
c98	lda #$0E
	sta wsync		;line=98
	sta color3
c99	lda #$2E
	sta wsync		;line=99
	sta color3
c100	lda #$0E
	sta wsync		;line=100
	sta color3
c101	lda #$2E
	sta wsync		;line=101
	sta color3
c102	lda #$0E
	sta wsync		;line=102
	sta color3
c103	lda #$2E
	sta wsync		;line=103
	sta color3
c104	lda #$0E
x8	ldx #$7D
	sta wsync		;line=104
	sta color3
	stx hposm0
c105	lda #$2E
	sta wsync		;line=105
	sta color3
c106	lda #$0E
	sta wsync		;line=106
	sta color3
c107	lda #$2E
	sta wsync		;line=107
	sta color3
c108	lda #$0E
	sta wsync		;line=108
	sta color3
c109	lda #$2E
	sta wsync		;line=109
	sta color3
c110	lda #$0E
	sta wsync		;line=110
	sta color3
c111	lda #$2E
	sta wsync		;line=111
	sta color3
	lda >fnt+$400*$02
c112	ldx #$0E
	sta wsync		;line=112
	sta chbase
	stx color3
c113	lda #$2E
	sta wsync		;line=113
	sta color3
c114	lda #$0E
	sta wsync		;line=114
	sta color3
c115	lda #$2E
	sta wsync		;line=115
	sta color3
c116	lda #$0E
	sta wsync		;line=116
	sta color3
c117	lda #$2E
	sta wsync		;line=117
	sta color3
c118	lda #$0E
	sta wsync		;line=118
	sta color3
c119	lda #$2E
x9	ldx #$6D
	sta wsync		;line=119
	sta color3
	stx hposp2
c120	lda #$0E
	sta wsync		;line=120
	sta color3
c121	lda #$2E
x10	ldx #$6A
x11	ldy #$6F
	sta wsync		;line=121
	sta color3
	stx hposp1
	sty hposp2
c122	lda #$0E
	sta wsync		;line=122
	sta color3
c123	lda #$2E
	sta wsync		;line=123
	sta color3
c124	lda #$0E
	sta wsync		;line=124
	sta color3
c125	lda #$2E
	sta wsync		;line=125
	sta color3
c126	lda #$0E
	sta wsync		;line=126
	sta color3
c127	lda #$2E
	sta wsync		;line=127
	sta color3
c128	lda #$0E
x12	ldx #$69
	sta wsync		;line=128
	sta color3
	stx hposp1
c129	lda #$2E
	sta wsync		;line=129
	sta color3
c130	lda #$0E
x13	ldx #$88
	sta wsync		;line=130
	sta color3
	stx hposp3
c131	lda #$2E
s5	ldx #$01
c132	ldy #$8A
	sta wsync		;line=131
	sta color3
	stx sizep0
	sty colpm0
c133	lda #$0E
s6	ldx #$04
x14	ldy #$70
	sta wsync		;line=132
	sta color3
	stx sizem
	sty hposp2
c134	lda #$2E
	sta wsync		;line=133
	sta color3
c135	lda #$0E
	sta wsync		;line=134
	sta color3
c136	lda #$2E
	sta wsync		;line=135
	sta color3
	lda >fnt+$400*$03
c137	ldx #$0E
x15	ldy #$68
	sta wsync		;line=136
	sta chbase
	stx color3
	sty hposp1
c138	lda #$2E
	sta wsync		;line=137
	sta color3
c139	lda #$0E
	sta wsync		;line=138
	sta color3
c140	lda #$2E
	sta wsync		;line=139
	sta color3
c141	lda #$0E
	sta wsync		;line=140
	sta color3
c142	lda #$2E
	sta wsync		;line=141
	sta color3
c143	lda #$0E
x16	ldx #$67
x17	ldy #$71
	sta wsync		;line=142
	sta color3
	stx hposp1
	sty hposp2
c144	lda #$2E
	sta wsync		;line=143
	sta color3
c145	lda #$0E
x18	ldx #$8C
	sta wsync		;line=144
	sta color3
	stx hposp0
c146	lda #$2E
	sta wsync		;line=145
	sta color3
c147	lda #$0E
	sta wsync		;line=146
	sta color3
c148	lda #$2E
	sta wsync		;line=147
	sta color3
c149	lda #$0E
	sta wsync		;line=148
	sta color3
c150	lda #$2E
	sta wsync		;line=149
	sta color3
c151	lda #$0E
	sta wsync		;line=150
	sta color3
c152	lda #$08
c153	ldx #$2E
	sta wsync		;line=151
	sta color0
	stx color3
	lda >fnt+$400*$02
c154	ldx #$0E
	sta wsync		;line=152
	sta chbase
	stx color3
c155	lda #$2E
	sta wsync		;line=153
	sta color3
c156	lda #$0E
	sta wsync		;line=154
	sta color3
c157	lda #$2E
	sta wsync		;line=155
	sta color3
c158	lda #$0E
	sta wsync		;line=156
	sta color3
c159	lda #$2E
s7	ldx #$01
x19	ldy #$8F
	sta wsync		;line=157
	sta color3
	stx sizep1
	sty hposp1
c160	lda #$BC
	sta colpm1
c161	lda #$0E
	sta wsync		;line=158
	sta color3
c162	lda #$2E
	sta wsync		;line=159
	sta color3
	lda >fnt+$400*$01
c163	ldx #$0E
s8	ldy #$C0
	sta wsync		;line=160
	sta chbase
	stx color3
	sty sizem
c164	lda #$2E
	sta wsync		;line=161
	sta color3
c165	lda #$0E
	sta wsync		;line=162
	sta color3
c166	lda #$2E
	sta wsync		;line=163
	sta color3
c167	lda #$0E
	sta wsync		;line=164
	sta color3
c168	lda #$2E
	sta wsync		;line=165
	sta color3
c169	lda #$0E
	sta wsync		;line=166
	sta color3
c170	lda #$2E
	sta wsync		;line=167
	sta color3
	lda >fnt+$400*$03
c171	ldx #$0E
	sta wsync		;line=168
	sta chbase
	stx color3
c172	lda #$2E
x20	ldx #$8B
	sta wsync		;line=169
	sta color3
	stx hposp0
c173	lda #$0E
	sta wsync		;line=170
	sta color3
c174	lda #$2E
s9	ldx #$C1
x21	ldy #$88
	sta wsync		;line=171
	sta color3
	stx sizem
	sty hposm0
c175	lda #$0E
x22	ldx #$95
c176	ldy #$1E
	sta wsync		;line=172
	sta color3
	stx hposp3
	sty colpm3
c177	lda #$2E
	sta wsync		;line=173
	sta color3
c178	lda #$0E
x23	ldx #$8A
	sta wsync		;line=174
	sta color3
	stx hposp0
c179	lda #$2E
	sta wsync		;line=175
	sta color3
c180	lda #$0E
	sta wsync		;line=176
	sta color3
c181	lda #$2E
	sta wsync		;line=177
	sta color3
c182	lda #$0E
s10	ldx #$05
x24	ldy #$89
	sta wsync		;line=178
	sta color3
	stx sizem
	sty hposp0
x25	lda #$8C
	sta hposm1
c183	lda #$2E
	sta wsync		;line=179
	sta color3
c184	lda #$0E
	sta wsync		;line=180
	sta color3
c185	lda #$2E
	sta wsync		;line=181
	sta color3
c186	lda #$0E
	sta wsync		;line=182
	sta color3
c187	lda #$2E
	sta wsync		;line=183
	sta color3
	lda >fnt+$400*$04
c188	ldx #$0E
	sta wsync		;line=184
	sta chbase
	stx color3
c189	lda #$2E
	sta wsync		;line=185
	sta color3
c190	lda #$0E
	sta wsync		;line=186
	sta color3
c191	lda #$2E
s11	ldx #$01
x26	ldy #$8F
	sta wsync		;line=187
	sta color3
	stx sizep2
	sty hposp2
c192	lda #$4C
	sta colpm2
c193	lda #$0E
	sta wsync		;line=188
	sta color3
c194	lda #$0A
c195	ldx #$2E
	sta wsync		;line=189
	sta color0
	stx color3
c196	lda #$0E
	sta wsync		;line=190
	sta color3
c197	lda #$2E
	sta wsync		;line=191
	sta color3
c198	lda #$0E
	sta wsync		;line=192
	sta color3
c199	lda #$2E
	sta wsync		;line=193
	sta color3
c200	lda #$0E
	sta wsync		;line=194
	sta color3
c201	lda #$2E
	sta wsync		;line=195
	sta color3
c202	lda #$0E
x27	ldx #$94
c203	ldy #$0A
	sta wsync		;line=196
	sta color3
	stx hposp0
	sty colpm0
c204	lda #$08
c205	ldx #$2E
	sta wsync		;line=197
	sta color0
	stx color3
c206	lda #$0E
x28	ldx #$93
	sta wsync		;line=198
	sta color3
	stx hposp0
c207	lda #$2E
	sta wsync		;line=199
	sta color3
c208	lda #$0E
	sta wsync		;line=200
	sta color3
c209	lda #$2E
	sta wsync		;line=201
	sta color3
c210	lda #$0E
	sta wsync		;line=202
	sta color3
c211	lda #$2E
	sta wsync		;line=203
	sta color3
c212	lda #$0E
	sta wsync		;line=204
	sta color3
c213	lda #$2E
	sta wsync		;line=205
	sta color3
c214	lda #$0E
	sta wsync		;line=206
	sta color3
c215	lda #$2E
	sta wsync		;line=207
	sta color3
	lda >fnt+$400*$00
c216	ldx #$0E
	sta wsync		;line=208
	sta chbase
	stx color3
c217	lda #$2E
	sta wsync		;line=209
	sta color3
c218	lda #$0E
	sta wsync		;line=210
	sta color3
c219	lda #$2E
	sta wsync		;line=211
	sta color3
c220	lda #$0E
	sta wsync		;line=212
	sta color3
c221	lda #$2E
	sta wsync		;line=213
	sta color3
c222	lda #$0E
	sta wsync		;line=214
	sta color3
c223	lda #$2E
	sta wsync		;line=215
	sta color3
	lda >fnt+$400*$02
c224	ldx #$0E
	sta wsync		;line=216
	sta chbase
	stx color3
c225	lda #$2E
	sta wsync		;line=217
	sta color3
c226	lda #$0E
	sta wsync		;line=218
	sta color3
c227	lda #$2E
	sta wsync		;line=219
	sta color3
c228	lda #$0E
	sta wsync		;line=220
	sta color3
c229	lda #$2E
	sta wsync		;line=221
	sta color3
c230	lda #$0E
	sta wsync		;line=222
	sta color3
c231	lda #$2E
	sta wsync		;line=223
	sta color3
	lda >fnt+$400*$03
c232	ldx #$0E
	sta wsync		;line=224
	sta chbase
	stx color3
c233	lda #$2E
	sta wsync		;line=225
	sta color3
c234	lda #$0E
	sta wsync		;line=226
	sta color3
c235	lda #$2E
	sta wsync		;line=227
	sta color3
c236	lda #$0E
	sta wsync		;line=228
	sta color3
c237	lda #$2E
	sta wsync		;line=229
	sta color3
c238	lda #$0E
	sta wsync		;line=230
	sta color3
c239	lda #$2E
	sta wsync		;line=231
	sta color3
	lda >fnt+$400*$00
c240	ldx #$0E
	sta wsync		;line=232
	sta chbase
	stx color3
c241	lda #$2E
	sta wsync		;line=233
	sta color3
c242	lda #$0E
	sta wsync		;line=234
	sta color3
c243	lda #$2E
	sta wsync		;line=235
	sta color3
c244	lda #$0E
	sta wsync		;line=236
	sta color3
c245	lda #$2E
	sta wsync		;line=237
	sta color3
c246	lda #$0E
	sta wsync		;line=238
	sta color3
c247	lda #$2E
	sta wsync		;line=239
	sta color3
	lda regA
	ldx regX
	ldy regY
	rti
.endl


.ALIGN $0800
pmg	.ds $0300
	SPRITES
	

.MACRO	SPRITES
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 03 03 03 03 03 03 03
	.he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
	.he 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
	.he 03 03 03 03 02 00 00 00 00 00 00 00 0C 0C 0C 0C
	.he 0C 0C 0C 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 C0 C0 C0 C0 C0 40 40 40
	.he 40 40 40 03 03 03 03 03 03 03 0F 0F 0C 0C 0C 0C
	.he 0C 0C 0C 0C 0C 0C 0C 0C 0C 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 06 06 1F BE FE FE FE FE FE FE FE FE FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FF FF FF 3F 1F 1F 0F 0F 07 0F 07 07
	.he 07 07 07 07 03 07 03 07 06 06 02 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 0F 07 0F 07 07 07 0C 06
	.he 0C 00 02 07 07 07 06 0B 0C 08 0C 1C 0C 0C 00 00
	.he 00 40 C0 E0 E0 E0 F0 FF FF FF FF FF FF FF 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 7C 81 FE C0
	.he FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 07 1F 07 1F 07 1F 07 0F 27 0F 67 0F
	.he E7 0F E7 07 F7 07 F7 07 FF 07 FF 07 7F 07 7F 07
	.he 7F 07 3F 07 1F 07 1F 0F 3F 3F 1F 3F 1F 3F 1F 1F
	.he 1F 1F 1F 1F 3F 3F 3F 1F 3F 1F 1F 1F 1F 00 00 00
	.he 00 00 00 00 00 0F 18 16 30 30 30 30 30 30 00 00
	.he 00 00 00 80 80 83 C7 FF FF FF FF FF FF FF FF FF
	.he FF FF FF FF FE FC F8 F0 E0 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 0F 07 1F 07
	.he 1F 06 1F 17 0F 0F 0F 0F 0F 0F 1F 1F 0F 0F 0F 0F
	.he 0F 0F 0F 07 07 07 07 07 07 07 07 07 1F 7F FF FF
	.he FF FF FF FE FE FC FC FC F8 D0 C0 C0 C0 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 FF FF FF FF FF FF FF FF FC F0 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 FA FA FF FF F8 FC FC FC FC FD
	.he FD FF FF FF FD FF FF FF FF FF FF FF FF FF FF FF
	.he FF FE FC FD F9 FD F9 F2 F3 F2 F3 F7 F3 F3 F0 F0
	.he F0 F0 F0 F0 00 07 0F 07 CF 07 4F 87 4F C7 8F F7
	.he 07 F7 07 FF FF FF FF FF FF FF FF FF FF FF 7F FF
	.he FF BF FF 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

trans ins '13_go_to_boxes.obx.bc'

end_part_memory
.if PGENE = 1
	run RUN_ADDRESS
.endif	
