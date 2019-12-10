PGENE = 0	//0-demo build, 1-standalone part

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

LOAD_ADDRESS	equ	$1000
RUN_ADDRESS		equ	main

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS-$80
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
.endif

temp	= first_free_zp
clock	= temp+2

pmg	= $0000

width	= 40
height	= 22

ile	= 90-height

rows	= 90*width>$1000


.align
screen
	ift rows
	ins "fin.row"
	els
	ins "data\fin.scr"
	eif

	.ALIGN	$100
ant	:(30-height-1)/2 dta $70
	dta $f0
scr
	ift rows
	:height dta $62,a(screen+#*width)
	els
	dta $62,a(screen)
	:height-2 dta $22
	dta $02
	eif

	dta $41,a(ant)

gfxmode	ins "data\fin.gfx"

	.ALIGN	$400
fnt	ins "data\fin.fnt"

	.get "data\fin.tab"

	ert *>$BFFF,"no ram"

	utils_wait_one_frame
	utils_wait_end_frame

main	.local
.if PGENE = 1
	jsr rom_off
.else
	lda end_eff
	beq *-2
.endif
	jsr wait_one_frame
	
	INIT:UPDATE
	ldy	#0
	sty vscrol
	jsr	CREATE._nxt
	jsr wait_end_frame

	set_vbl vbl
	jsr prg
	mva #1 zgas+1
e0	lda #0
	beq e0
	mva #0 dmactl
	restore_nmi

.if PGENE = 0
	jmp OS_PREP_NEXT_PART
.else
	jmp *
.endif

.endl


dli
	sta	regA
	stx	regX
	sty	regY

dliv	jmp d0

nmiQ	lda	regA
	ldx	regX
	ldy	regY
	rti

vbl	phr
	sta	$d40f
	mva	>pmg	$d407
	mva	#3	$d01d	
	inc	clock
	set_dli dli
	mwa	#ant	$d402
	//mva	#scr40	$d400
	jsr zapal
	jsr zgas

ffnt	mva	>fnt	$d409

ivbl	jsr	v0

ldli	mva	<d0	dliv+1
hdli	mva	>d0	dliv+2

	plr:rti


zapal	.local
w	lda #0
	beq *+6
	dec w+1
	rts
w1	ldx #0
	ldy wait,x
	beq ee
	sty w+1
	inc w1+1
	txa
	and #1
	beq zg
	mva	#scr40	$d400
	rts
zg	mva	#0	$d400
	rts
ee	lda #{rts}
	sta w
	sta w_sta
	rts
	
wait	dta b(3,8,9,2,11,4,7,1,3,1,1,9,7,15,5,1,1,20,0)
	.endl

zgas	.local
	lda #0
	bne w
	rts
w	lda #0
	beq *+6
	dec w+1
	rts
w1	ldx #0
	ldy wait,x
	beq ee
	sty w+1
	inc w1+1
	txa
	and #1
	bne zg
	mva	#scr40	$d400
	rts
zg	mva	#0	$d400
	rts
ee	lda #{rts}
	sta main.e0+1
	rts
	
wait	dta b(20,8,9,2,11,4,7,1,3,1,1,9,7,15,5,1,1,5,0)
	.endl


d0
 sta $d40a	;0
d1
 sta $d40a	;1
d2
 sta $d40a	;2
d3
 sta $d40a	;3
d4
 sta $d40a	;4
d5
 sta $d40a	;5
d6
 sta $d40a	;6
d7
 sta $d40a	;7
d8
 sta $d40a	;8
d9
 sta $d40a	;9
d10
 sta $d40a	;10
d11
 sta $d40a	;11
d12
 sta $d40a	;12
d13
 sta $d40a	;13
d14
 sta $d40a	;14
d15
 sta $d40a	;15
d16
 sta $d40a	;16
d17
 sta $d40a	;17
d18
 sta $d40a	;18
d19
 sta $d40a	;19
d20
 sta $d40a	;20
d21
 sta $d40a	;21
d22
 sta $d40a	;22
d23
 sta $d40a	;23
d24
 sta $d40a	;24
d25
 sta $d40a	;25
d26
 sta $d40a	;26
d27
 sta $d40a	;27
d28
 sta $d40a	;28
d29
 sta $d40a	;29
d30
 sta $d40a	;30
d31
 sta $d40a	;31
d32
 sta $d40a	;32
d33
 sta $d40a	;33
d34
 sta $d40a	;34
d35
 sta $d40a	;35
d36
 sta $d40a	;36
d37
 sta $d40a	;37
d38
 sta $d40a	;38
d39
 sta $d40a	;39
d40
 sta $d40a	;40
d41
 sta $d40a	;41
d42
 sta $d40a	;42
d43
 sta $d40a	;43
d44
 sta $d40a	;44
d45
 sta $d40a	;45
d46
 sta $d40a	;46
d47
 sta $d40a	;47
d48
 lda #$04
 sta $d40a	;48
 sta gtictl
d49
 sta $d40a	;49
d50
 sta $d40a	;50
d51
 sta $d40a	;51
d52
 sta $d40a	;52
d53
 sta $d40a	;53
d54
 sta $d40a	;54
d55
 sta $d40a	;55
d56
 sta $d40a	;56
d57
 sta $d40a	;57
d58
 sta $d40a	;58
d59
 sta $d40a	;59
d60
 sta $d40a	;60
d61
 sta $d40a	;61
d62
 sta $d40a	;62
d63
 sta $d40a	;63
d64
 sta $d40a	;64
d65
 sta $d40a	;65
d66
 sta $d40a	;66
d67
 sta $d40a	;67
d68
 sta $d40a	;68
d69
 sta $d40a	;69
d70
 sta $d40a	;70
d71
 sta $d40a	;71
d72
 sta $d40a	;72
d73
 sta $d40a	;73
d74
 sta $d40a	;74
d75
 sta $d40a	;75
d76
 sta $d40a	;76
d77
 sta $d40a	;77
d78
 sta $d40a	;78
d79
 sta $d40a	;79
d80
 sta $d40a	;80
d81
 sta $d40a	;81
d82
 sta $d40a	;82
d83
 sta $d40a	;83
d84
 sta $d40a	;84
d85
 sta $d40a	;85
d86
 sta $d40a	;86
d87
 sta $d40a	;87
d88
 sta $d40a	;88
d89
 sta $d40a	;89
d90
 sta $d40a	;90
d91
 sta $d40a	;91
d92
 sta $d40a	;92
d93
 sta $d40a	;93
d94
 sta $d40a	;94
d95
 sta $d40a	;95
d96
 sta $d40a	;96
d97
 sta $d40a	;97
d98
 sta $d40a	;98
d99
 sta $d40a	;99
d100
 sta $d40a	;100
d101
 sta $d40a	;101
d102
 sta $d40a	;102
d103
 sta $d40a	;103
d104
 sta $d40a	;104
d105
 sta $d40a	;105
d106
 lda #$98
 sta $d40a	;106
 sta hposp2
d107
 lda #$58
 sta $d40a	;107
 sta hposp3
d108
 sta $d40a	;108
d109
 sta $d40a	;109
d110
 sta $d40a	;110
d111
 sta $d40a	;111
d112
 sta $d40a	;112
d113
 sta $d40a	;113
d114
 sta $d40a	;114
d115
 sta $d40a	;115
d116
 sta $d40a	;116
d117
 sta $d40a	;117
d118
 sta $d40a	;118
d119
 sta $d40a	;119
d120
 sta $d40a	;120
d121
 sta $d40a	;121
d122
 sta $d40a	;122
d123
 sta $d40a	;123
d124
 sta $d40a	;124
d125
 sta $d40a	;125
d126
 sta $d40a	;126
d127
 sta $d40a	;127
d128
 sta $d40a	;128
d129
 sta $d40a	;129
d130
 sta $d40a	;130
d131
 sta $d40a	;131
d132
 sta $d40a	;132
d133
 sta $d40a	;133
d134
 sta $d40a	;134
d135
 sta $d40a	;135
d136
 sta $d40a	;136
d137
 sta $d40a	;137
d138
 sta $d40a	;138
d139
 lda #$A8
 ldx #$48
 sta $d40a	;139
 sta hposp2
 stx hposp3
d140
 sta $d40a	;140
d141
 sta $d40a	;141
d142
 sta $d40a	;142
d143
 sta $d40a	;143
d144
 sta $d40a	;144
d145
 sta $d40a	;145
d146
 sta $d40a	;146
d147
 sta $d40a	;147
d148
 sta $d40a	;148
d149
 sta $d40a	;149
d150
 sta $d40a	;150
d151
 sta $d40a	;151
d152
 sta $d40a	;152
d153
 sta $d40a	;153
d154
 sta $d40a	;154
d155
 sta $d40a	;155
d156
 sta $d40a	;156
d157
 sta $d40a	;157
d158
 sta $d40a	;158
d159
 sta $d40a	;159
d160
 sta $d40a	;160
d161
 sta $d40a	;161
d162
 sta $d40a	;162
d163
 sta $d40a	;163
d164
 sta $d40a	;164
d165
 lda #$57
 sta $d40a	;165
 sta hposp0
d166
 lda #$97
 sta $d40a	;166
 sta hposp1
d167
 sta $d40a	;167
d168
 sta $d40a	;168
d169
 lda #$B8
 sta $d40a	;169
 sta hposp2
d170
 sta $d40a	;170
d171
 sta $d40a	;171
d172
 lda #$38
 sta $d40a	;172
 sta hposp3
d173
 sta $d40a	;173
d174
 sta $d40a	;174
d175
 sta $d40a	;175
d176
 sta $d40a	;176
d177
 sta $d40a	;177
d178
 sta $d40a	;178
d179
 sta $d40a	;179
d180
 sta $d40a	;180
d181
 sta $d40a	;181
d182
 sta $d40a	;182
d183
 sta $d40a	;183
d184
 lda >fnt+.get[184/8]*$400
 sta $d40a	;184
 sta chbase
d185
 sta $d40a	;185
d186
 sta $d40a	;186
d187
 sta $d40a	;187
d188
 sta $d40a	;188
d189
 sta $d40a	;189
d190
 sta $d40a	;190
d191
 sta $d40a	;191
d192
 sta $d40a	;192
d193
 sta $d40a	;193
d194
 sta $d40a	;194
d195
 lda #$86
 ldx #$14
 sta $d40a	;195
 sta hposp3
 stx colpm3
d196
 sta $d40a	;196
d197
 lda #$54
 sta $d40a	;197
 sta colpm2
d198
 lda #$47
 sta $d40a	;198
 sta hposp0
d199
 lda #$A7
 sta $d40a	;199
 sta hposp1
d200
 sta $d40a	;200
d201
 sta $d40a	;201
d202
 sta $d40a	;202
d203
 sta $d40a	;203
d204
 lda #$66
 sta $d40a	;204
 sta hposp2
d205
 sta $d40a	;205
d206
 sta $d40a	;206
d207
 sta $d40a	;207
d208
 sta $d40a	;208
d209
 sta $d40a	;209
d210
 sta $d40a	;210
d211
 sta $d40a	;211
d212
 sta $d40a	;212
d213
 sta $d40a	;213
d214
 sta $d40a	;214
d215
 sta $d40a	;215
d216
 sta $d40a	;216
d217
 sta $d40a	;217
d218
 sta $d40a	;218
d219
 sta $d40a	;219
d220
 sta $d40a	;220
d221
 sta $d40a	;221
d222
 sta $d40a	;222
d223
 sta $d40a	;223
d224
 sta $d40a	;224
d225
 sta $d40a	;225
d226
 sta $d40a	;226
d227
 sta $d40a	;227
d228
 lda #$56
 sta $d40a	;228
 sta hposm2
d229
 sta $d40a	;229
d230
 sta $d40a	;230
d231
 sta $d40a	;231
d232
 sta $d40a	;232
d233
 sta $d40a	;233
d234
 sta $d40a	;234
d235
 sta $d40a	;235
d236
 lda #$56
 ldx #$96
 sta $d40a	;236
 sta hposp2
 stx hposp3
d237
 sta $d40a	;237
d238
 sta $d40a	;238
d239
 sta $d40a	;239
d240
 lda >fnt+.get[240/8]*$400
 sta $d40a	;240
 sta chbase
d241
 sta $d40a	;241
d242
 sta $d40a	;242
d243
 sta $d40a	;243
d244
 sta $d40a	;244
d245
 sta $d40a	;245
d246
 sta $d40a	;246
d247
 sta $d40a	;247
d248
 sta $d40a	;248
d249
 sta $d40a	;249
d250
 sta $d40a	;250
d251
 sta $d40a	;251
d252
 sta $d40a	;252
d253
 sta $d40a	;253
d254
 sta $d40a	;254
d255
 sta $d40a	;255
d256
 sta $d40a	;256
d257
 sta $d40a	;257
d258
 sta $d40a	;258
d259
 sta $d40a	;259
d260
 sta $d40a	;260
d261
 lda #$86
 ldx #$24
 sta $d40a	;261
 sta hposp1
 stx colpm1
d262
 lda #$66
 ldx #$44
 sta $d40a	;262
 sta hposp0
 stx colpm0
d263
 sta $d40a	;263
d264
 sta $d40a	;264
d265
 sta $d40a	;265
d266
 sta $d40a	;266
d267
 sta $d40a	;267
d268
 sta $d40a	;268
d269
 sta $d40a	;269
d270
 sta $d40a	;270
d271
 sta $d40a	;271
d272
 sta $d40a	;272
d273
 sta $d40a	;273
d274
 sta $d40a	;274
d275
 sta $d40a	;275
d276
 sta $d40a	;276
d277
 sta $d40a	;277
d278
 sta $d40a	;278
d279
 lda #$8D
 sta $d40a	;279
 sta hposm1
d280
 lda >fnt+.get[280/8]*$400
 ldx #$6D
 sta $d40a	;280
 sta chbase
 stx hposm0
d281
 sta $d40a	;281
d282
 sta $d40a	;282
d283
 sta $d40a	;283
d284
 sta $d40a	;284
d285
 sta $d40a	;285
d286
 sta $d40a	;286
d287
 sta $d40a	;287
d288
 sta $d40a	;288
d289
 sta $d40a	;289
d290
 sta $d40a	;290
d291
 sta $d40a	;291
d292
 sta $d40a	;292
d293
 sta $d40a	;293
d294
 sta $d40a	;294
d295
 sta $d40a	;295
d296
 sta $d40a	;296
d297
 sta $d40a	;297
d298
 sta $d40a	;298
d299
 sta $d40a	;299
d300
 sta $d40a	;300
d301
 lda #$52
 sta $d40a	;301
 sta color3
d302
 lda #$50
 sta $d40a	;302
 sta color3
d303
 lda #$52
 sta $d40a	;303
 sta color3
d304
 lda #$50
 sta $d40a	;304
 sta color3
d305
 lda #$52
 sta $d40a	;305
 sta color3
d306
 lda #$50
 ldx #$79
 sta $d40a	;306
 sta color3
 stx hposp0
d307
 lda #$52
 ldx #$86
 sta $d40a	;307
 sta color3
 stx colpm0
d308
 sta $d40a	;308
d309
 sta $d40a	;309
d310
 sta $d40a	;310
d311
 sta $d40a	;311
d312
 lda >fnt+.get[312/8]*$400
 sta $d40a	;312
 sta chbase
d313
 sta $d40a	;313
d314
 sta $d40a	;314
d315
 sta $d40a	;315
d316
 sta $d40a	;316
d317
 sta $d40a	;317
d318
 sta $d40a	;318
d319
 sta $d40a	;319
d320
 sta $d40a	;320
d321
 sta $d40a	;321
d322
 sta $d40a	;322
d323
 lda #$8A
 sta $d40a	;323
 sta colpm0
d324
 lda #$01
 sta $d40a	;324
 sta sizep0
d325
 lda #$71
 ldx #$94
 sta $d40a	;325
 sta hposp2
 stx colpm2
d326
 sta $d40a	;326
d327
 lda #$8A
 ldx #$94
 sta $d40a	;327
 sta hposp1
 stx colpm1
d328
 sta $d40a	;328
d329
 sta $d40a	;329
d330
 sta $d40a	;330
d331
 sta $d40a	;331
d332
 sta $d40a	;332
d333
 sta $d40a	;333
d334
 sta $d40a	;334
d335
 lda #$8A
 ldx #$32
 sta $d40a	;335
 sta color1
 stx colpm0
d336
 lda >fnt+.get[336/8]*$400
 ldx #$96
 sta $d40a	;336
 sta chbase
 stx color0
d337
 sta $d40a	;337
d338
 sta $d40a	;338
d339
 sta $d40a	;339
d340
 sta $d40a	;340
d341
 sta $d40a	;341
d342
 sta $d40a	;342
d343
 lda #$34
 sta $d40a	;343
 sta color2
d344
 sta $d40a	;344
d345
 sta $d40a	;345
d346
 sta $d40a	;346
d347
 sta $d40a	;347
d348
 sta $d40a	;348
d349
 sta $d40a	;349
d350
 sta $d40a	;350
d351
 sta $d40a	;351
d352
 sta $d40a	;352
d353
 sta $d40a	;353
d354
 sta $d40a	;354
d355
 sta $d40a	;355
d356
 sta $d40a	;356
d357
 sta $d40a	;357
d358
 sta $d40a	;358
d359
 sta $d40a	;359
d360
 lda >fnt+.get[360/8]*$400
 sta $d40a	;360
 sta chbase
d361
 lda #$9C
 sta $d40a	;361
 sta color2
d362
 sta $d40a	;362
d363
 sta $d40a	;363
d364
 sta $d40a	;364
d365
 sta $d40a	;365
d366
 sta $d40a	;366
d367
 sta $d40a	;367
d368
 sta $d40a	;368
d369
 sta $d40a	;369
d370
 sta $d40a	;370
d371
 sta $d40a	;371
d372
 sta $d40a	;372
d373
 lda #$EE
 sta $d40a	;373
 sta colpm0
d374
 lda #$00
 sta $d40a	;374
 sta sizep0
d375
 sta $d40a	;375
d376
 sta $d40a	;376
d377
 sta $d40a	;377
d378
 sta $d40a	;378
d379
 sta $d40a	;379
d380
 sta $d40a	;380
d381
 sta $d40a	;381
d382
 sta $d40a	;382
d383
 sta $d40a	;383
d384
 lda >fnt+.get[384/8]*$400
 sta $d40a	;384
 sta chbase
d385
 lda #$34
 sta $d40a	;385
 sta color1
d386
 lda #$73
 sta $d40a	;386
 sta hposp0
d387
 sta $d40a	;387
d388
 sta $d40a	;388
d389
 sta $d40a	;389
d390
 sta $d40a	;390
d391
 sta $d40a	;391
d392
 sta $d40a	;392
d393
 sta $d40a	;393
d394
 sta $d40a	;394
d395
 sta $d40a	;395
d396
 sta $d40a	;396
d397
 sta $d40a	;397
d398
 sta $d40a	;398
d399
 sta $d40a	;399
d400
 sta $d40a	;400
d401
 sta $d40a	;401
d402
 lda #$BE
 ldx #$50
 sta $d40a	;402
 sta color2
 stx hposp0
d403
 lda #$9C
 sta $d40a	;403
 sta colpm0
d404
 sta $d40a	;404
d405
 sta $d40a	;405
d406
 sta $d40a	;406
d407
 sta $d40a	;407
d408
 lda >fnt+.get[408/8]*$400
 sta $d40a	;408
 sta chbase
d409
 sta $d40a	;409
d410
 sta $d40a	;410
d411
 sta $d40a	;411
d412
 sta $d40a	;412
d413
 sta $d40a	;413
d414
 sta $d40a	;414
d415
 sta $d40a	;415
d416
 sta $d40a	;416
d417
 sta $d40a	;417
d418
 lda #$DE
 sta $d40a	;418
 sta color2
d419
 sta $d40a	;419
d420
 sta $d40a	;420
d421
 sta $d40a	;421
d422
 sta $d40a	;422
d423
 lda #$94
 ldx #$7D
 sta $d40a	;423
 sta color0
 stx hposp0
d424
 lda #$2C
 sta $d40a	;424
 sta colpm0
d425
 lda #$A8
 sta $d40a	;425
 sta color1
d426
 sta $d40a	;426
d427
 sta $d40a	;427
d428
 sta $d40a	;428
d429
 sta $d40a	;429
d430
 lda #$74
 ldx #$78
 sta $d40a	;430
 sta hposp1
 stx colpm1
d431
 sta $d40a	;431
d432
 lda >fnt+.get[432/8]*$400
 sta $d40a	;432
 sta chbase
d433
 lda #$85
 ldx #$0C
 sta $d40a	;433
 sta hposp0
 stx colpm0
d434
 lda #$78
 sta $d40a	;434
 sta colpm0
d435
 lda #$AE
 sta $d40a	;435
 sta color2
d436
 sta $d40a	;436
d437
 sta $d40a	;437
d438
 sta $d40a	;438
d439
 lda #$8E
 ldx #$A8
 sta $d40a	;439
 sta hposp2
 stx colpm2
d440
 sta $d40a	;440
d441
 sta $d40a	;441
d442
 sta $d40a	;442
d443
 lda #$6B
 ldx #$A8
 sta $d40a	;443
 sta hposp3
 stx colpm3
d444
 sta $d40a	;444
d445
 lda #$78
 sta $d40a	;445
 sta color1
d446
 lda #$2E
 sta $d40a	;446
 sta colpm0
d447
 lda #$2E
 sta $d40a	;447
 sta colpm1
d448
 lda #$75
 sta $d40a	;448
 sta hposp1
d449
 lda #$83
 sta $d40a	;449
 sta hposp0
d450
 sta $d40a	;450
d451
 sta $d40a	;451
d452
 sta $d40a	;452
d453
 lda #$34
 sta $d40a	;453
 sta color0
d454
 sta $d40a	;454
d455
 sta $d40a	;455
d456
 lda >fnt+.get[456/8]*$400
 sta $d40a	;456
 sta chbase
d457
 sta $d40a	;457
d458
 lda #$84
 sta $d40a	;458
 sta hposp0
d459
 sta $d40a	;459
d460
 sta $d40a	;460
d461
 sta $d40a	;461
d462
 lda #$6E
 sta $d40a	;462
 sta color2
d463
 sta $d40a	;463
d464
 sta $d40a	;464
d465
 sta $d40a	;465
d466
 sta $d40a	;466
d467
 lda #$AE
 sta $d40a	;467
 sta color2
d468
 sta $d40a	;468
d469
 lda #$74
 sta $d40a	;469
 sta hposp1
d470
 sta $d40a	;470
d471
 sta $d40a	;471
d472
 sta $d40a	;472
d473
 sta $d40a	;473
d474
 lda #$0E
 sta $d40a	;474
 sta colpm3
d475
 sta $d40a	;475
d476
 sta $d40a	;476
d477
 sta $d40a	;477
d478
 sta $d40a	;478
d479
 lda #$7C
 ldx #$0A
 sta $d40a	;479
 sta hposp3
 stx colpm3
d480
 lda >fnt+.get[480/8]*$400
 ldx #$0E
 sta $d40a	;480
 sta chbase
 stx colpm3
d481
 sta $d40a	;481
d482
 sta $d40a	;482
d483
 sta $d40a	;483
d484
 sta $d40a	;484
d485
 sta $d40a	;485
d486
 lda #$AC
 sta $d40a	;486
 sta color2
d487
 sta $d40a	;487
d488
 sta $d40a	;488
d489
 sta $d40a	;489
d490
 sta $d40a	;490
d491
 lda #$2E
 sta $d40a	;491
 sta colpm3
d492
 sta $d40a	;492
d493
 sta $d40a	;493
d494
 sta $d40a	;494
d495
 sta $d40a	;495
d496
 sta $d40a	;496
d497
 sta $d40a	;497
d498
 sta $d40a	;498
d499
 sta $d40a	;499
d500
 sta $d40a	;500
d501
 sta $d40a	;501
d502
 sta $d40a	;502
d503
 sta $d40a	;503
d504
 sta $d40a	;504
d505
 sta $d40a	;505
d506
 sta $d40a	;506
d507
 sta $d40a	;507
d508
 sta $d40a	;508
d509
 sta $d40a	;509
d510
 sta $d40a	;510
d511
 sta $d40a	;511
d512
 lda >fnt+.get[512/8]*$400
 sta $d40a	;512
 sta chbase
d513
 sta $d40a	;513
d514
 sta $d40a	;514
d515
 sta $d40a	;515
d516
 sta $d40a	;516
d517
 sta $d40a	;517
d518
 lda #$AE
 sta $d40a	;518
 sta color2
d519
 sta $d40a	;519
d520
 sta $d40a	;520
d521
 sta $d40a	;521
d522
 lda #$3E
 ldx #$AE
 sta $d40a	;522
 sta hposp3
 stx colpm3
d523
 sta $d40a	;523
d524
 sta $d40a	;524
d525
 lda #$42
 ldx #$BE
 ldy #$2E
 sta $d40a	;525
 sta color3
 stx hposp2
 sty colpm2
d526
 lda #$2C
 sta $d40a	;526
 sta colpm0
d527
 sta $d40a	;527
d528
 lda #$7A
 ldx #$8E
 sta $d40a	;528
 sta color1
 stx color2
d529
 sta $d40a	;529
d530
 lda #$6D
 ldx #$2C
 sta $d40a	;530
 sta hposp1
 stx colpm1
d531
 lda #$16
 ldx #$01
 sta $d40a	;531
 sta color0
 stx sizep0
d532
 lda #$01
 sta $d40a	;532
 sta sizep1
d533
 sta $d40a	;533
d534
 sta $d40a	;534
d535
 sta $d40a	;535
d536
 lda >fnt+.get[536/8]*$400
 sta $d40a	;536
 sta chbase
d537
 sta $d40a	;537
d538
 sta $d40a	;538
d539
 sta $d40a	;539
d540
 sta $d40a	;540
d541
 lda #$8A
 sta $d40a	;541
 sta color1
d542
 sta $d40a	;542
d543
 sta $d40a	;543
d544
 sta $d40a	;544
d545
 sta $d40a	;545
d546
 sta $d40a	;546
d547
 sta $d40a	;547
d548
 sta $d40a	;548
d549
 sta $d40a	;549
d550
 sta $d40a	;550
d551
 sta $d40a	;551
d552
 sta $d40a	;552
d553
 sta $d40a	;553
d554
 sta $d40a	;554
d555
 sta $d40a	;555
d556
 sta $d40a	;556
d557
 sta $d40a	;557
d558
 sta $d40a	;558
d559
 sta $d40a	;559
d560
 lda >fnt+.get[560/8]*$400
 sta $d40a	;560
 sta chbase
d561
 sta $d40a	;561
d562
 sta $d40a	;562
d563
 sta $d40a	;563
d564
 sta $d40a	;564
d565
 sta $d40a	;565
d566
 sta $d40a	;566
d567
 sta $d40a	;567
d568
 sta $d40a	;568
d569
 sta $d40a	;569
d570
 sta $d40a	;570
d571
 sta $d40a	;571
d572
 sta $d40a	;572
d573
 sta $d40a	;573
d574
 sta $d40a	;574
d575
 sta $d40a	;575
d576
 sta $d40a	;576
d577
 sta $d40a	;577
d578
 sta $d40a	;578
d579
 sta $d40a	;579
d580
 sta $d40a	;580
d581
 sta $d40a	;581
d582
 sta $d40a	;582
d583
 sta $d40a	;583
d584
 lda >fnt+.get[584/8]*$400
 ldx #$00
 sta $d40a	;584
 sta chbase
 stx sizep0
d585
 sta $d40a	;585
d586
 sta $d40a	;586
d587
 sta $d40a	;587
d588
 sta $d40a	;588
d589
 sta $d40a	;589
d590
 sta $d40a	;590
d591
 sta $d40a	;591
d592
 sta $d40a	;592
d593
 sta $d40a	;593
d594
 lda #$4C
 ldx #$AC
 sta $d40a	;594
 sta hposp3
 stx colpm3
d595
 sta $d40a	;595
d596
 sta $d40a	;596
d597
 sta $d40a	;597
d598
 lda #$AE
 sta $d40a	;598
 sta hposp2
d599
 sta $d40a	;599
d600
 sta $d40a	;600
d601
 sta $d40a	;601
d602
 sta $d40a	;602
d603
 sta $d40a	;603
d604
 sta $d40a	;604
d605
 sta $d40a	;605
d606
 sta $d40a	;606
d607
 sta $d40a	;607
d608
 lda >fnt+.get[608/8]*$400
 sta $d40a	;608
 sta chbase
d609
 sta $d40a	;609
d610
 sta $d40a	;610
d611
 lda #$7A
 ldx #$55
 sta $d40a	;611
 sta color1
 stx hposm2
d612
 sta $d40a	;612
d613
 sta $d40a	;613
d614
 sta $d40a	;614
d615
 sta $d40a	;615
d616
 sta $d40a	;616
d617
 sta $d40a	;617
d618
 sta $d40a	;618
d619
 sta $d40a	;619
d620
 sta $d40a	;620
d621
 sta $d40a	;621
d622
 sta $d40a	;622
d623
 sta $d40a	;623
d624
 sta $d40a	;624
d625
 lda #$79
 sta $d40a	;625
 sta hposp1
d626
 lda #$4E
 sta $d40a	;626
 sta colpm1
d627
 sta $d40a	;627
d628
 lda #$2A
 sta $d40a	;628
 sta colpm2
d629
 lda #$AA
 sta $d40a	;629
 sta colpm3
d630
 sta $d40a	;630
d631
 sta $d40a	;631
d632
 lda >fnt+.get[632/8]*$400
 sta $d40a	;632
 sta chbase
d633
 sta $d40a	;633
d634
 sta $d40a	;634
d635
 lda #$32
 sta $d40a	;635
 sta color2
d636
 sta $d40a	;636
d637
 lda #$88
 sta $d40a	;637
 sta colpm1
d638
 lda #$00
 sta $d40a	;638
 sta sizep1
d639
 lda #$74
 sta $d40a	;639
 sta color1
d640
 lda #$7D
 sta $d40a	;640
 sta hposp1
d641
 sta $d40a	;641
d642
 sta $d40a	;642
d643
 sta $d40a	;643
d644
 lda #$B5
 sta $d40a	;644
 sta hposp2
d645
 lda #$56
 sta $d40a	;645
 sta hposm2
d646
 sta $d40a	;646
d647
 sta $d40a	;647
d648
 lda #$F6
 sta $d40a	;648
 sta color0
d649
 sta $d40a	;649
d650
 lda #$8A
 sta $d40a	;650
 sta colpm1
d651
 sta $d40a	;651
d652
 lda #$66
 sta $d40a	;652
 sta colpm0
d653
 sta $d40a	;653
d654
 sta $d40a	;654
d655
 sta $d40a	;655
d656
 sta $d40a	;656
d657
 sta $d40a	;657
d658
 lda #$48
 sta $d40a	;658
 sta hposp3
d659
 sta $d40a	;659
d660
 sta $d40a	;660
d661
 sta $d40a	;661
d662
 lda #$24
 sta $d40a	;662
 sta color0
d663
 sta $d40a	;663
d664
 lda >fnt+.get[664/8]*$400
 ldx #$88
 sta $d40a	;664
 sta chbase
 stx colpm1
d665
 sta $d40a	;665
d666
 sta $d40a	;666
d667
 sta $d40a	;667
d668
 lda #$BB
 sta $d40a	;668
 sta hposp2
d669
 sta $d40a	;669
d670
 sta $d40a	;670
d671
 lda #$86
 sta $d40a	;671
 sta colpm1
d672
 lda >fnt+.get[672/8]*$400
 sta $d40a	;672
 sta chbase
d673
 sta $d40a	;673
d674
 sta $d40a	;674
d675
 sta $d40a	;675
d676
 sta $d40a	;676
d677
 sta $d40a	;677
d678
 sta $d40a	;678
d679
 sta $d40a	;679
d680
 lda >fnt+.get[680/8]*$400
 sta $d40a	;680
 sta chbase
d681
 sta $d40a	;681
d682
 sta $d40a	;682
d683
 sta $d40a	;683
d684
 lda #$57
 sta $d40a	;684
 sta hposm2
d685
 sta $d40a	;685
d686
 sta $d40a	;686
d687
 sta $d40a	;687
d688
 lda >fnt+.get[688/8]*$400
 sta $d40a	;688
 sta chbase
d689
 sta $d40a	;689
d690
 sta $d40a	;690
d691
 sta $d40a	;691
d692
 sta $d40a	;692
d693
 sta $d40a	;693
d694
 sta $d40a	;694
d695
 sta $d40a	;695
d696
 sta $d40a	;696
d697
 sta $d40a	;697
d698
 sta $d40a	;698
d699
 sta $d40a	;699
d700
 sta $d40a	;700
d701
 sta $d40a	;701
d702
 sta $d40a	;702
d703
 sta $d40a	;703
d704
 lda >fnt+.get[704/8]*$400
 sta $d40a	;704
 sta chbase
d705
 sta $d40a	;705
d706
 sta $d40a	;706
d707
 sta $d40a	;707
d708
 sta $d40a	;708
d709
 sta $d40a	;709
d710
 sta $d40a	;710
d711
 sta $d40a	;711
d712
 sta $d40a	;712
d713
 sta $d40a	;713
d714
 sta $d40a	;714
d715
 sta $d40a	;715
d716
 sta $d40a	;716
d717
 sta $d40a	;717
d718
 sta $d40a	;718
d719
 sta $d40a	;719
d720
 sta $d40a	;720
d721
 jmp nmiQ

l_dli	dta l(d0,d1,d2,d3,d4,d5,d6,d7)
	dta l(d8,d9,d10,d11,d12,d13,d14,d15)
	dta l(d16,d17,d18,d19,d20,d21,d22,d23)
	dta l(d24,d25,d26,d27,d28,d29,d30,d31)
	dta l(d32,d33,d34,d35,d36,d37,d38,d39)
	dta l(d40,d41,d42,d43,d44,d45,d46,d47)
	dta l(d48,d49,d50,d51,d52,d53,d54,d55)
	dta l(d56,d57,d58,d59,d60,d61,d62,d63)
	dta l(d64,d65,d66,d67,d68,d69,d70,d71)
	dta l(d72,d73,d74,d75,d76,d77,d78,d79)
	dta l(d80,d81,d82,d83,d84,d85,d86,d87)
	dta l(d88,d89,d90,d91,d92,d93,d94,d95)
	dta l(d96,d97,d98,d99,d100,d101,d102,d103)
	dta l(d104,d105,d106,d107,d108,d109,d110,d111)
	dta l(d112,d113,d114,d115,d116,d117,d118,d119)
	dta l(d120,d121,d122,d123,d124,d125,d126,d127)
	dta l(d128,d129,d130,d131,d132,d133,d134,d135)
	dta l(d136,d137,d138,d139,d140,d141,d142,d143)
	dta l(d144,d145,d146,d147,d148,d149,d150,d151)
	dta l(d152,d153,d154,d155,d156,d157,d158,d159)
	dta l(d160,d161,d162,d163,d164,d165,d166,d167)
	dta l(d168,d169,d170,d171,d172,d173,d174,d175)
	dta l(d176,d177,d178,d179,d180,d181,d182,d183)
	dta l(d184,d185,d186,d187,d188,d189,d190,d191)
	dta l(d192,d193,d194,d195,d196,d197,d198,d199)
	dta l(d200,d201,d202,d203,d204,d205,d206,d207)
	dta l(d208,d209,d210,d211,d212,d213,d214,d215)
	dta l(d216,d217,d218,d219,d220,d221,d222,d223)
	dta l(d224,d225,d226,d227,d228,d229,d230,d231)
	dta l(d232,d233,d234,d235,d236,d237,d238,d239)
	dta l(d240,d241,d242,d243,d244,d245,d246,d247)
	dta l(d248,d249,d250,d251,d252,d253,d254,d255)
	dta l(d256,d257,d258,d259,d260,d261,d262,d263)
	dta l(d264,d265,d266,d267,d268,d269,d270,d271)
	dta l(d272,d273,d274,d275,d276,d277,d278,d279)
	dta l(d280,d281,d282,d283,d284,d285,d286,d287)
	dta l(d288,d289,d290,d291,d292,d293,d294,d295)
	dta l(d296,d297,d298,d299,d300,d301,d302,d303)
	dta l(d304,d305,d306,d307,d308,d309,d310,d311)
	dta l(d312,d313,d314,d315,d316,d317,d318,d319)
	dta l(d320,d321,d322,d323,d324,d325,d326,d327)
	dta l(d328,d329,d330,d331,d332,d333,d334,d335)
	dta l(d336,d337,d338,d339,d340,d341,d342,d343)
	dta l(d344,d345,d346,d347,d348,d349,d350,d351)
	dta l(d352,d353,d354,d355,d356,d357,d358,d359)
	dta l(d360,d361,d362,d363,d364,d365,d366,d367)
	dta l(d368,d369,d370,d371,d372,d373,d374,d375)
	dta l(d376,d377,d378,d379,d380,d381,d382,d383)
	dta l(d384,d385,d386,d387,d388,d389,d390,d391)
	dta l(d392,d393,d394,d395,d396,d397,d398,d399)
	dta l(d400,d401,d402,d403,d404,d405,d406,d407)
	dta l(d408,d409,d410,d411,d412,d413,d414,d415)
	dta l(d416,d417,d418,d419,d420,d421,d422,d423)
	dta l(d424,d425,d426,d427,d428,d429,d430,d431)
	dta l(d432,d433,d434,d435,d436,d437,d438,d439)
	dta l(d440,d441,d442,d443,d444,d445,d446,d447)
	dta l(d448,d449,d450,d451,d452,d453,d454,d455)
	dta l(d456,d457,d458,d459,d460,d461,d462,d463)
	dta l(d464,d465,d466,d467,d468,d469,d470,d471)
	dta l(d472,d473,d474,d475,d476,d477,d478,d479)
	dta l(d480,d481,d482,d483,d484,d485,d486,d487)
	dta l(d488,d489,d490,d491,d492,d493,d494,d495)
	dta l(d496,d497,d498,d499,d500,d501,d502,d503)
	dta l(d504,d505,d506,d507,d508,d509,d510,d511)
	dta l(d512,d513,d514,d515,d516,d517,d518,d519)
	dta l(d520,d521,d522,d523,d524,d525,d526,d527)
	dta l(d528,d529,d530,d531,d532,d533,d534,d535)
	dta l(d536,d537,d538,d539,d540,d541,d542,d543)
	dta l(d544,d545,d546,d547,d548,d549,d550,d551)
	dta l(d552,d553,d554,d555,d556,d557,d558,d559)
	dta l(d560,d561,d562,d563,d564,d565,d566,d567)
	dta l(d568,d569,d570,d571,d572,d573,d574,d575)
	dta l(d576,d577,d578,d579,d580,d581,d582,d583)
	dta l(d584,d585,d586,d587,d588,d589,d590,d591)
	dta l(d592,d593,d594,d595,d596,d597,d598,d599)
	dta l(d600,d601,d602,d603,d604,d605,d606,d607)
	dta l(d608,d609,d610,d611,d612,d613,d614,d615)
	dta l(d616,d617,d618,d619,d620,d621,d622,d623)
	dta l(d624,d625,d626,d627,d628,d629,d630,d631)
	dta l(d632,d633,d634,d635,d636,d637,d638,d639)
	dta l(d640,d641,d642,d643,d644,d645,d646,d647)
	dta l(d648,d649,d650,d651,d652,d653,d654,d655)
	dta l(d656,d657,d658,d659,d660,d661,d662,d663)
	dta l(d664,d665,d666,d667,d668,d669,d670,d671)
	dta l(d672,d673,d674,d675,d676,d677,d678,d679)
	dta l(d680,d681,d682,d683,d684,d685,d686,d687)
	dta l(d688,d689,d690,d691,d692,d693,d694,d695)
	dta l(d696,d697,d698,d699,d700,d701,d702,d703)
	dta l(d704,d705,d706,d707,d708,d709,d710,d711)
	dta l(d712,d713,d714,d715,d716,d717,d718,d719)
	dta l(d720,d721)

h_dli	dta h(d0,d1,d2,d3,d4,d5,d6,d7)
	dta h(d8,d9,d10,d11,d12,d13,d14,d15)
	dta h(d16,d17,d18,d19,d20,d21,d22,d23)
	dta h(d24,d25,d26,d27,d28,d29,d30,d31)
	dta h(d32,d33,d34,d35,d36,d37,d38,d39)
	dta h(d40,d41,d42,d43,d44,d45,d46,d47)
	dta h(d48,d49,d50,d51,d52,d53,d54,d55)
	dta h(d56,d57,d58,d59,d60,d61,d62,d63)
	dta h(d64,d65,d66,d67,d68,d69,d70,d71)
	dta h(d72,d73,d74,d75,d76,d77,d78,d79)
	dta h(d80,d81,d82,d83,d84,d85,d86,d87)
	dta h(d88,d89,d90,d91,d92,d93,d94,d95)
	dta h(d96,d97,d98,d99,d100,d101,d102,d103)
	dta h(d104,d105,d106,d107,d108,d109,d110,d111)
	dta h(d112,d113,d114,d115,d116,d117,d118,d119)
	dta h(d120,d121,d122,d123,d124,d125,d126,d127)
	dta h(d128,d129,d130,d131,d132,d133,d134,d135)
	dta h(d136,d137,d138,d139,d140,d141,d142,d143)
	dta h(d144,d145,d146,d147,d148,d149,d150,d151)
	dta h(d152,d153,d154,d155,d156,d157,d158,d159)
	dta h(d160,d161,d162,d163,d164,d165,d166,d167)
	dta h(d168,d169,d170,d171,d172,d173,d174,d175)
	dta h(d176,d177,d178,d179,d180,d181,d182,d183)
	dta h(d184,d185,d186,d187,d188,d189,d190,d191)
	dta h(d192,d193,d194,d195,d196,d197,d198,d199)
	dta h(d200,d201,d202,d203,d204,d205,d206,d207)
	dta h(d208,d209,d210,d211,d212,d213,d214,d215)
	dta h(d216,d217,d218,d219,d220,d221,d222,d223)
	dta h(d224,d225,d226,d227,d228,d229,d230,d231)
	dta h(d232,d233,d234,d235,d236,d237,d238,d239)
	dta h(d240,d241,d242,d243,d244,d245,d246,d247)
	dta h(d248,d249,d250,d251,d252,d253,d254,d255)
	dta h(d256,d257,d258,d259,d260,d261,d262,d263)
	dta h(d264,d265,d266,d267,d268,d269,d270,d271)
	dta h(d272,d273,d274,d275,d276,d277,d278,d279)
	dta h(d280,d281,d282,d283,d284,d285,d286,d287)
	dta h(d288,d289,d290,d291,d292,d293,d294,d295)
	dta h(d296,d297,d298,d299,d300,d301,d302,d303)
	dta h(d304,d305,d306,d307,d308,d309,d310,d311)
	dta h(d312,d313,d314,d315,d316,d317,d318,d319)
	dta h(d320,d321,d322,d323,d324,d325,d326,d327)
	dta h(d328,d329,d330,d331,d332,d333,d334,d335)
	dta h(d336,d337,d338,d339,d340,d341,d342,d343)
	dta h(d344,d345,d346,d347,d348,d349,d350,d351)
	dta h(d352,d353,d354,d355,d356,d357,d358,d359)
	dta h(d360,d361,d362,d363,d364,d365,d366,d367)
	dta h(d368,d369,d370,d371,d372,d373,d374,d375)
	dta h(d376,d377,d378,d379,d380,d381,d382,d383)
	dta h(d384,d385,d386,d387,d388,d389,d390,d391)
	dta h(d392,d393,d394,d395,d396,d397,d398,d399)
	dta h(d400,d401,d402,d403,d404,d405,d406,d407)
	dta h(d408,d409,d410,d411,d412,d413,d414,d415)
	dta h(d416,d417,d418,d419,d420,d421,d422,d423)
	dta h(d424,d425,d426,d427,d428,d429,d430,d431)
	dta h(d432,d433,d434,d435,d436,d437,d438,d439)
	dta h(d440,d441,d442,d443,d444,d445,d446,d447)
	dta h(d448,d449,d450,d451,d452,d453,d454,d455)
	dta h(d456,d457,d458,d459,d460,d461,d462,d463)
	dta h(d464,d465,d466,d467,d468,d469,d470,d471)
	dta h(d472,d473,d474,d475,d476,d477,d478,d479)
	dta h(d480,d481,d482,d483,d484,d485,d486,d487)
	dta h(d488,d489,d490,d491,d492,d493,d494,d495)
	dta h(d496,d497,d498,d499,d500,d501,d502,d503)
	dta h(d504,d505,d506,d507,d508,d509,d510,d511)
	dta h(d512,d513,d514,d515,d516,d517,d518,d519)
	dta h(d520,d521,d522,d523,d524,d525,d526,d527)
	dta h(d528,d529,d530,d531,d532,d533,d534,d535)
	dta h(d536,d537,d538,d539,d540,d541,d542,d543)
	dta h(d544,d545,d546,d547,d548,d549,d550,d551)
	dta h(d552,d553,d554,d555,d556,d557,d558,d559)
	dta h(d560,d561,d562,d563,d564,d565,d566,d567)
	dta h(d568,d569,d570,d571,d572,d573,d574,d575)
	dta h(d576,d577,d578,d579,d580,d581,d582,d583)
	dta h(d584,d585,d586,d587,d588,d589,d590,d591)
	dta h(d592,d593,d594,d595,d596,d597,d598,d599)
	dta h(d600,d601,d602,d603,d604,d605,d606,d607)
	dta h(d608,d609,d610,d611,d612,d613,d614,d615)
	dta h(d616,d617,d618,d619,d620,d621,d622,d623)
	dta h(d624,d625,d626,d627,d628,d629,d630,d631)
	dta h(d632,d633,d634,d635,d636,d637,d638,d639)
	dta h(d640,d641,d642,d643,d644,d645,d646,d647)
	dta h(d648,d649,d650,d651,d652,d653,d654,d655)
	dta h(d656,d657,d658,d659,d660,d661,d662,d663)
	dta h(d664,d665,d666,d667,d668,d669,d670,d671)
	dta h(d672,d673,d674,d675,d676,d677,d678,d679)
	dta h(d680,d681,d682,d683,d684,d685,d686,d687)
	dta h(d688,d689,d690,d691,d692,d693,d694,d695)
	dta h(d696,d697,d698,d699,d700,d701,d702,d703)
	dta h(d704,d705,d706,d707,d708,d709,d710,d711)
	dta h(d712,d713,d714,d715,d716,d717,d718,d719)
	dta h(d720,d721)

v0
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizep0
 sta sizem
 lda #$02
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$68
 sta hposp3
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$88
 sta hposp2
 lda #$96
 sta hposm3
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v1
v2
v3
v4
v5
v6
v7
v8
v9
v10
v11
v12
v13
v14
v15
v16
v17
v18
v19
v20
v21
v22
v23
v24
v25
v26
v27
v28
v29
v30
v31
v32
v33
v34
v35
v36
v37
v38
v39
v40
v41
v42
v43
v44
v45
v46
v47
v48
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizep0
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$68
 sta hposp3
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$88
 sta hposp2
 lda #$96
 sta hposm3
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v49
v50
v51
v52
v53
v54
v55
v56
v57
v58
v59
v60
v61
v62
v63
v64
v65
v66
v67
v68
v69
v70
v71
v72
v73
v74
v75
v76
v77
v78
v79
v80
v81
v82
v83
v84
v85
v86
v87
v88
v89
v90
v91
v92
v93
v94
v95
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizep0
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$58
 sta hposp3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$88
 sta hposp2
 lda #$96
 sta hposm3
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v96
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizep0
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$58
 sta hposp3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$98
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v97
v98
v99
v100
v101
v102
v103
v104
v105
v106
v107
v108
v109
v110
v111
v112
v113
v114
v115
v116
v117
v118
v119
v120
v121
v122
v123
v124
v125
v126
 lda #$00
 sta colbak
 sta sizep2
 sta sizep1
 sta sizep0
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$48
 sta hposp3
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$98
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v127
 lda #$00
 sta colbak
 sta sizep1
 sta sizep0
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$48
 sta hposp3
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$A8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v128
v129
v130
v131
v132
v133
v134
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$48
 sta hposp3
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$A8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v135
v136
v137
v138
v139
v140
v141
v142
v143
v144
v145
v146
v147
v148
v149
v150
v151
v152
v153
v154
v155
v156
v157
v158
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$38
 sta hposp3
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$A8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v159
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$38
 sta hposp3
 lda #$50
 sta color3
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$67
 sta hposp0
 lda #$74
 sta colpm3
 lda #$87
 sta hposp1
 lda #$96
 sta hposm3
 lda #$B8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v160
v161
v162
v163
v164
v165
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$38
 sta hposp3
 lda #$50
 sta color3
 lda #$57
 sta hposp0
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$74
 sta colpm3
 lda #$96
 sta hposm3
 lda #$97
 sta hposp1
 lda #$B8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v166
v167
v168
v169
v170
v171
v172
v173
v174
v175
v176
v177
v178
v179
v180
v181
v182
v183
v184
v185
v186
v187
v188
v189
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$57
 sta hposp0
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$97
 sta hposp1
 lda #$B8
 sta hposp2
 lda #$D4
 sta colpm2
 lda #$E4
 sta colpm1
 rts

v190
v191
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 sta sizem
 sta sizep2
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$57
 sta hposp0
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$97
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v192
v193
v194
v195
v196
 lda #$00
 sta colbak
 sta sizep1
 sta sizep3
 sta sizem
 sta sizep0
 sta sizep2
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$47
 sta hposp0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$97
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v197
v198
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 sta sizem
 sta sizep2
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$47
 sta hposp0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$97
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v199
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 sta sizem
 sta sizep2
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$47
 sta hposp0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$64
 sta colpm0
 lda #$66
 sta hposm2
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$A7
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v200
v201
v202
v203
v204
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$47
 sta hposp0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$64
 sta colpm0
 lda #$66
 sta hposp2
 sta hposm2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$A7
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v205
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$47
 sta hposp0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposm2
 lda #$64
 sta colpm0
 lda #$66
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$A7
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v206
v207
v208
v209
v210
v211
v212
v213
v214
v215
v216
v217
v218
v219
v220
v221
v222
v223
v224
v225
v226
v227
v228
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposm2
 lda #$66
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 lda #$A7
 sta hposp1
 lda #$E4
 sta colpm1
 rts

v229
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposm2
 lda #$66
 sta hposp2
 lda #$86
 sta hposp3
 lda #$96
 sta hposm3
 rts

v230
v231
v232
v233
v234
v235
v236
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 sta hposm2
 lda #$96
 sta hposp3
 sta hposm3
 rts

v237
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 lda #$96
 sta hposp3
 sta hposm3
 rts

v238
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 lda #$96
 sta hposp3
 rts

v239
v240
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizep0
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 lda #$66
 sta hposp0
 lda #$6D
 sta hposm0
 lda #$86
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$96
 sta hposp3
 rts

v241
v242
v243
v244
v245
v246
v247
v248
v249
v250
v251
v252
v253
v254
v255
v256
v257
v258
v259
v260
v261
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizep0
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 lda #$66
 sta hposp0
 lda #$6D
 sta hposm0
 lda #$86
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$96
 sta hposp3
 rts

v262
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$14
 sta colpm3
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$54
 sta colpm2
 lda #$56
 sta hposp2
 lda #$66
 sta hposp0
 lda #$6D
 sta hposm0
 lda #$86
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$96
 sta hposp3
 rts

v263
v264
v265
v266
v267
v268
v269
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizem
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$66
 sta hposp0
 lda #$6B
 sta hposp3
 lda #$6D
 sta hposm0
 lda #$71
 sta hposp2
 lda #$86
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$94
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v270
v271
v272
v273
v274
v275
v276
v277
v278
v279
v280
v281
v282
v283
v284
v285
v286
v287
v288
v289
v290
v291
v292
v293
v294
v295
v296
v297
v298
v299
v300
 lda #$00
 sta colbak
 sta sizep1
 sta sizem
 sta sizep0
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$6B
 sta hposp3
 lda #$6D
 sta hposm0
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$86
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$94
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v301
 lda #$00
 sta colbak
 sta sizem
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$6D
 sta hposm0
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$94
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v302
 lda #$00
 sta colbak
 sta sizem
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$6B
 sta hposp3
 lda #$6D
 sta hposm0
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$94
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v303
v304
 lda #$00
 sta colbak
 sta sizem
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$24
 sta colpm1
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 lda #$8D
 sta hposm1
 lda #$94
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v305
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 lda #$94
 sta colpm2
 sta colpm1
 lda #$A8
 sta colpm3
 rts

v306
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$44
 sta colpm0
 lda #$50
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 lda #$94
 sta colpm2
 sta colpm1
 lda #$A8
 sta colpm3
 rts

v307
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$86
 sta colpm0
 lda #$8A
 sta hposp1
 lda #$94
 sta colpm2
 sta colpm1
 lda #$A8
 sta colpm3
 rts

v308
v309
v310
v311
v312
v313
v314
v315
v316
v317
v318
v319
v320
v321
v322
v323
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta colpm0
 sta hposp1
 lda #$94
 sta colpm2
 sta colpm1
 lda #$A8
 sta colpm3
 rts

v324
 lda #$00
 sta colbak
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta colpm0
 sta hposp1
 lda #$94
 sta colpm2
 sta colpm1
 lda #$A8
 sta colpm3
 rts

v325
v326
v327
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 lda #$34
 sta color1
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta hposp1
 sta colpm0
 lda #$94
 sta colpm1
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v328
v329
v330
v331
v332
v333
v334
v335
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta color0
 sta colpm0
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 sta hposp1
 lda #$94
 sta colpm1
 sta colpm2
 lda #$A8
 sta colpm3
 rts

v336
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta colpm0
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 sta hposp1
 lda #$94
 sta colpm1
 sta colpm2
 lda #$96
 sta color0
 lda #$A8
 sta colpm3
 rts

v337
 lda #$00
 sta colbak
 sta sizep2
 sta sizep1
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta colpm0
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$71
 sta hposp2
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$94
 sta colpm2
 lda #$96
 sta color0
 lda #$A8
 sta colpm3
 rts

v338
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta colpm0
 lda #$36
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 rts

v339
v340
v341
v342
v343
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta colpm0
 lda #$34
 sta color2
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 rts

v344
v345
v346
v347
v348
v349
v350
v351
v352
v353
v354
v355
v356
v357
v358
v359
v360
v361
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$32
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta color2
 lda #$A8
 sta colpm2
 sta colpm3
 rts

v362
v363
v364
v365
v366
v367
v368
v369
v370
v371
v372
v373
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta color2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$EE
 sta colpm0
 rts

v374
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$79
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta color2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$EE
 sta colpm0
 rts

v375
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$73
 sta hposp0
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$8A
 sta color1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta color2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$EE
 sta colpm0
 rts

v376
v377
v378
v379
v380
v381
v382
v383
v384
v385
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$73
 sta hposp0
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta color2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$EE
 sta colpm0
 rts

v386
v387
v388
v389
v390
v391
v392
v393
v394
v395
v396
v397
v398
v399
v400
v401
v402
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$50
 sta hposp0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$BE
 sta color2
 lda #$EE
 sta colpm0
 rts

v403
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$50
 sta hposp0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta colpm0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$BE
 sta color2
 rts

v404
v405
v406
v407
v408
v409
v410
v411
v412
v413
v414
v415
v416
v417
v418
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$50
 sta hposp0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta colpm0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v419
v420
v421
v422
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$7D
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$96
 sta color0
 lda #$9C
 sta colpm0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v423
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$34
 sta color1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$7D
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$9C
 sta colpm0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v424
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 lda #$34
 sta color1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$7D
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v425
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$7D
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta color1
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v426
v427
v428
v429
v430
v431
v432
v433
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$0C
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta color1
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v434
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm0
 sta colpm1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta color1
 sta colpm2
 sta colpm3
 lda #$DE
 sta color2
 rts

v435
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta colpm0
 sta colpm1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta color1
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v436
v437
v438
v439
v440
v441
v442
v443
v444
v445
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 sta colpm0
 sta colpm1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v446
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 sta colpm1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v447
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v448
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$75
 sta hposp1
 lda #$78
 sta color1
 lda #$85
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v449
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$75
 sta hposp1
 lda #$78
 sta color1
 lda #$83
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$94
 sta color0
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v450
v451
v452
v453
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$75
 sta hposp1
 lda #$78
 sta color1
 lda #$83
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v454
v455
v456
v457
v458
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$75
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v459
v460
v461
v462
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$6E
 sta color2
 lda #$75
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$A8
 sta colpm2
 sta colpm3
 rts

v463
v464
v465
v466
v467
v468
v469
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$A8
 sta colpm2
 sta colpm3
 lda #$AE
 sta color2
 rts

v470
v471
v472
v473
v474
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$04
 sta gtictl
 lda #$0E
 sta colpm3
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta hposp2
 lda #$A8
 sta colpm2
 lda #$AE
 sta color2
 rts

v475
v476
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$0E
 sta colpm3
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$6B
 sta hposp3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 rts

v477
v478
v479
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 lda #$04
 sta gtictl
 lda #$0A
 sta colpm3
 lda #$2E
 sta colpm0
 sta colpm1
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$7C
 sta hposp3
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 rts

v480
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 sta sizep2
 sta sizem
 lda #$04
 sta gtictl
 lda #$0E
 sta colpm3
 lda #$2E
 sta colpm0
 sta colpm1
 sta colpm2
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$7C
 sta hposp3
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 lda #$BE
 sta hposp2
 rts

v481
v482
v483
v484
v485
v486
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep3
 sta sizep2
 sta sizem
 lda #$04
 sta gtictl
 lda #$0E
 sta colpm3
 lda #$2E
 sta colpm0
 sta colpm1
 sta colpm2
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$74
 sta hposp1
 lda #$78
 sta color1
 lda #$7C
 sta hposp3
 lda #$84
 sta hposp0
 lda #$AC
 sta color2
 lda #$BE
 sta hposp2
 rts

v487
v488
v489
v490
v491
 lda #$00
 sta colbak
 sta sizep0
 sta sizep3
 sta sizep2
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm1
 lda #$2E
 sta colpm0
 sta colpm3
 sta colpm2
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$7C
 sta hposp3
 lda #$84
 sta hposp0
 lda #$AC
 sta color2
 lda #$BE
 sta hposp2
 rts

v492
v493
v494
v495
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizep0
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm3
 sta colpm2
 lda #$34
 sta color0
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$7C
 sta hposp3
 lda #$84
 sta hposp0
 lda #$AC
 sta color2
 lda #$BE
 sta hposp2
 rts

v496
v497
v498
v499
v500
v501
v502
v503
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizep0
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$AC
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v504
v505
v506
v507
v508
v509
v510
v511
v512
v513
v514
v515
v516
v517
v518
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizep0
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$52
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v519
v520
v521
v522
v523
v524
v525
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizep0
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v526
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$78
 sta color1
 lda #$84
 sta hposp0
 lda #$AE
 sta color2
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v527
v528
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep3
 sta sizep1
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v529
v530
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$34
 sta color0
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v531
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$01
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v532
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$01
 sta sizep0
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v533
v534
v535
v536
v537
v538
v539
v540
v541
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$01
 sta sizep0
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 lda #$BE
 sta hposp2
 rts

v542
v543
v544
v545
v546
v547
v548
v549
v550
v551
v552
v553
v554
v555
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizem
 lda #$01
 sta sizep0
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$3E
 sta hposp3
 lda #$42
 sta color3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AE
 sta colpm3
 sta hposp2
 rts

v556
v557
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizem
 lda #$01
 sta sizep0
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v558
v559
v560
v561
v562
v563
v564
v565
v566
v567
v568
v569
v570
v571
v572
v573
v574
v575
v576
v577
v578
v579
v580
v581
v582
v583
v584
 lda #$00
 sta colbak
 sta sizep0
 sta sizep3
 sta sizep2
 sta sizem
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm0
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$6D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v585
v586
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$6D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v587
v588
v589
 lda #$00
 sta colbak
 sta sizep3
 sta sizep2
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v590
v591
v592
v593
v594
v595
v596
v597
v598
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta color1
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v599
v600
v601
v602
v603
v604
v605
v606
v607
v608
v609
v610
v611
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2C
 sta colpm1
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v612
v613
v614
v615
v616
v617
v618
v619
v620
v621
v622
v623
v624
v625
v626
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2E
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$4E
 sta colpm1
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v627
v628
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$4E
 sta colpm1
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AC
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v629
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$4E
 sta colpm1
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$8E
 sta color2
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v630
v631
v632
v633
v634
v635
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$4E
 sta colpm1
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v636
v637
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$01
 sta sizep1
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v638
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$79
 sta hposp1
 lda #$7A
 sta color1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v639
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep1
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v640
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$AE
 sta hposp2
 rts

v641
v642
v643
v644
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$55
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 rts

v645
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$16
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 rts

v646
v647
v648
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 lda #$F6
 sta color0
 rts

v649
v650
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 sta sizep0
 lda #$04
 sta gtictl
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 lda #$F6
 sta color0
 rts

v651
v652
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$4C
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 lda #$F6
 sta color0
 rts

v653
v654
v655
v656
v657
v658
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 lda #$F6
 sta color0
 rts

v659
v660
v661
v662
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$8A
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 rts

v663
v664
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$B5
 sta hposp2
 rts

v665
v666
v667
v668
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$88
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$BB
 sta hposp2
 rts

v669
v670
v671
 lda #$00
 sta colbak
 sta sizep0
 sta sizep1
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$7D
 sta hposp1
 lda #$84
 sta hposp0
 lda #$86
 sta colpm1
 lda #$AA
 sta colpm3
 lda #$BB
 sta hposp2
 rts

v672
v673
v674
v675
v676
v677
v678
v679
v680
v681
v682
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$56
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$84
 sta hposp0
 lda #$AA
 sta colpm3
 lda #$BB
 sta hposp2
 rts

v683
v684
 lda #$00
 sta colbak
 sta sizep0
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$57
 sta hposm2
 lda #$66
 sta colpm0
 lda #$74
 sta color1
 lda #$84
 sta hposp0
 lda #$AA
 sta colpm3
 lda #$BB
 sta hposp2
 rts

v685
v686
v687
v688
v689
v690
v691
v692
v693
v694
v695
v696
v697
v698
v699
v700
v701
v702
v703
v704
v705
v706
v707
 lda #$00
 sta colbak
 sta sizep2
 sta sizep3
 sta sizem
 lda #$04
 sta gtictl
 lda #$24
 sta color0
 lda #$2A
 sta colpm2
 lda #$32
 sta color2
 lda #$42
 sta color3
 lda #$48
 sta hposp3
 lda #$57
 sta hposm2
 lda #$74
 sta color1
 lda #$AA
 sta colpm3
 lda #$BB
 sta hposp2
 rts

v708
v709
v710
v711
v712
v713
v714
v715
v716
v717
v718
v719

l_vbl	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v48,v48,v48,v48,v48,v48,v48,v48)
	dta l(v48,v48,v48,v48,v48,v48,v48,v48)
	dta l(v48,v48,v48,v48,v48,v48,v48,v48)
	dta l(v48,v48,v48,v48,v48,v48,v48,v48)
	dta l(v48,v48,v48,v48,v48,v48,v48,v48)
	dta l(v48,v48,v48,v48,v48,v48,v48,v95)
	dta l(v96,v96,v96,v96,v96,v96,v96,v96)
	dta l(v96,v96,v96,v96,v96,v96,v96,v96)
	dta l(v96,v96,v96,v96,v96,v96,v96,v96)
	dta l(v96,v96,v96,v96,v96,v96,v126,v127)
	dta l(v127,v127,v127,v127,v127,v127,v134,v134)
	dta l(v134,v134,v134,v134,v134,v134,v134,v134)
	dta l(v134,v134,v134,v134,v134,v134,v134,v134)
	dta l(v134,v134,v134,v134,v134,v134,v158,v159)
	dta l(v159,v159,v159,v159,v159,v165,v165,v165)
	dta l(v165,v165,v165,v165,v165,v165,v165,v165)
	dta l(v165,v165,v165,v165,v165,v165,v165,v165)
	dta l(v165,v165,v165,v165,v165,v189,v189,v191)
	dta l(v191,v191,v191,v191,v196,v196,v198,v199)
	dta l(v199,v199,v199,v199,v204,v205,v205,v205)
	dta l(v205,v205,v205,v205,v205,v205,v205,v205)
	dta l(v205,v205,v205,v205,v205,v205,v205,v205)
	dta l(v205,v205,v205,v205,v228,v229,v229,v229)
	dta l(v229,v229,v229,v229,v236,v237,v238,v238)
	dta l(v240,v240,v240,v240,v240,v240,v240,v240)
	dta l(v240,v240,v240,v240,v240,v240,v240,v240)
	dta l(v240,v240,v240,v240,v240,v261,v262,v262)
	dta l(v262,v262,v262,v262,v262,v269,v269,v269)
	dta l(v269,v269,v269,v269,v269,v269,v269,v269)
	dta l(v269,v269,v269,v269,v269,v269,v269,v269)
	dta l(v269,v269,v269,v269,v269,v269,v269,v269)
	dta l(v269,v269,v269,v269,v300,v301,v302,v301)
	dta l(v304,v305,v306,v307,v307,v307,v307,v307)
	dta l(v307,v307,v307,v307,v307,v307,v307,v307)
	dta l(v307,v307,v307,v323,v324,v324,v324,v327)
	dta l(v327,v327,v327,v327,v327,v327,v327,v335)
	dta l(v336,v337,v338,v338,v338,v338,v338,v343)
	dta l(v343,v343,v343,v343,v343,v343,v343,v343)
	dta l(v343,v343,v343,v343,v343,v343,v343,v343)
	dta l(v343,v361,v361,v361,v361,v361,v361,v361)
	dta l(v361,v361,v361,v361,v361,v373,v374,v375)
	dta l(v375,v375,v375,v375,v375,v375,v375,v375)
	dta l(v375,v385,v385,v385,v385,v385,v385,v385)
	dta l(v385,v385,v385,v385,v385,v385,v385,v385)
	dta l(v385,v385,v402,v403,v403,v403,v403,v403)
	dta l(v403,v403,v403,v403,v403,v403,v403,v403)
	dta l(v403,v403,v418,v418,v418,v418,v422,v423)
	dta l(v424,v425,v425,v425,v425,v425,v425,v425)
	dta l(v425,v433,v434,v435,v435,v435,v435,v435)
	dta l(v435,v435,v435,v435,v435,v445,v446,v447)
	dta l(v448,v449,v449,v449,v449,v453,v453,v453)
	dta l(v453,v453,v458,v458,v458,v458,v462,v462)
	dta l(v462,v462,v462,v458,v458,v469,v469,v469)
	dta l(v469,v469,v474,v474,v476,v476,v476,v479)
	dta l(v480,v480,v480,v480,v480,v480,v486,v486)
	dta l(v486,v486,v486,v491,v491,v491,v491,v495)
	dta l(v495,v495,v495,v495,v495,v495,v495,v503)
	dta l(v503,v503,v503,v503,v503,v503,v503,v503)
	dta l(v503,v503,v503,v503,v503,v503,v518,v518)
	dta l(v518,v518,v518,v518,v518,v525,v526,v526)
	dta l(v528,v528,v530,v531,v532,v532,v532,v532)
	dta l(v532,v532,v532,v532,v532,v541,v541,v541)
	dta l(v541,v541,v541,v541,v541,v541,v541,v541)
	dta l(v541,v541,v541,v555,v555,v557,v557,v557)
	dta l(v557,v557,v557,v557,v557,v557,v557,v557)
	dta l(v557,v557,v557,v557,v557,v557,v557,v557)
	dta l(v557,v557,v557,v557,v557,v557,v557,v557)
	dta l(v584,v584,v586,v586,v586,v589,v589,v589)
	dta l(v589,v589,v589,v589,v589,v589,v598,v598)
	dta l(v598,v598,v598,v598,v598,v598,v598,v598)
	dta l(v598,v598,v598,v611,v611,v611,v611,v611)
	dta l(v611,v611,v611,v611,v611,v611,v611,v611)
	dta l(v611,v611,v626,v626,v628,v629,v629,v629)
	dta l(v629,v629,v629,v635,v635,v637,v638,v639)
	dta l(v640,v640,v640,v640,v644,v645,v645,v645)
	dta l(v648,v648,v650,v650,v652,v652,v652,v652)
	dta l(v652,v652,v658,v658,v658,v658,v662,v662)
	dta l(v664,v664,v664,v664,v668,v668,v668,v671)
	dta l(v671,v671,v671,v671,v671,v671,v671,v671)
	dta l(v671,v671,v682,v682,v684,v684,v684,v684)
	dta l(v684,v684,v684,v684,v684,v684,v684,v684)
	dta l(v684,v684,v684,v684,v684,v684,v684,v684)
	dta l(v684,v684,v684,v707,v707,v707,v707,v707)
	dta l(v707,v707,v707,v707,v707,v707,v707,v707)

h_vbl	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v48,v48,v48,v48,v48,v48,v48,v48)
	dta h(v48,v48,v48,v48,v48,v48,v48,v48)
	dta h(v48,v48,v48,v48,v48,v48,v48,v48)
	dta h(v48,v48,v48,v48,v48,v48,v48,v48)
	dta h(v48,v48,v48,v48,v48,v48,v48,v48)
	dta h(v48,v48,v48,v48,v48,v48,v48,v95)
	dta h(v96,v96,v96,v96,v96,v96,v96,v96)
	dta h(v96,v96,v96,v96,v96,v96,v96,v96)
	dta h(v96,v96,v96,v96,v96,v96,v96,v96)
	dta h(v96,v96,v96,v96,v96,v96,v126,v127)
	dta h(v127,v127,v127,v127,v127,v127,v134,v134)
	dta h(v134,v134,v134,v134,v134,v134,v134,v134)
	dta h(v134,v134,v134,v134,v134,v134,v134,v134)
	dta h(v134,v134,v134,v134,v134,v134,v158,v159)
	dta h(v159,v159,v159,v159,v159,v165,v165,v165)
	dta h(v165,v165,v165,v165,v165,v165,v165,v165)
	dta h(v165,v165,v165,v165,v165,v165,v165,v165)
	dta h(v165,v165,v165,v165,v165,v189,v189,v191)
	dta h(v191,v191,v191,v191,v196,v196,v198,v199)
	dta h(v199,v199,v199,v199,v204,v205,v205,v205)
	dta h(v205,v205,v205,v205,v205,v205,v205,v205)
	dta h(v205,v205,v205,v205,v205,v205,v205,v205)
	dta h(v205,v205,v205,v205,v228,v229,v229,v229)
	dta h(v229,v229,v229,v229,v236,v237,v238,v238)
	dta h(v240,v240,v240,v240,v240,v240,v240,v240)
	dta h(v240,v240,v240,v240,v240,v240,v240,v240)
	dta h(v240,v240,v240,v240,v240,v261,v262,v262)
	dta h(v262,v262,v262,v262,v262,v269,v269,v269)
	dta h(v269,v269,v269,v269,v269,v269,v269,v269)
	dta h(v269,v269,v269,v269,v269,v269,v269,v269)
	dta h(v269,v269,v269,v269,v269,v269,v269,v269)
	dta h(v269,v269,v269,v269,v300,v301,v302,v301)
	dta h(v304,v305,v306,v307,v307,v307,v307,v307)
	dta h(v307,v307,v307,v307,v307,v307,v307,v307)
	dta h(v307,v307,v307,v323,v324,v324,v324,v327)
	dta h(v327,v327,v327,v327,v327,v327,v327,v335)
	dta h(v336,v337,v338,v338,v338,v338,v338,v343)
	dta h(v343,v343,v343,v343,v343,v343,v343,v343)
	dta h(v343,v343,v343,v343,v343,v343,v343,v343)
	dta h(v343,v361,v361,v361,v361,v361,v361,v361)
	dta h(v361,v361,v361,v361,v361,v373,v374,v375)
	dta h(v375,v375,v375,v375,v375,v375,v375,v375)
	dta h(v375,v385,v385,v385,v385,v385,v385,v385)
	dta h(v385,v385,v385,v385,v385,v385,v385,v385)
	dta h(v385,v385,v402,v403,v403,v403,v403,v403)
	dta h(v403,v403,v403,v403,v403,v403,v403,v403)
	dta h(v403,v403,v418,v418,v418,v418,v422,v423)
	dta h(v424,v425,v425,v425,v425,v425,v425,v425)
	dta h(v425,v433,v434,v435,v435,v435,v435,v435)
	dta h(v435,v435,v435,v435,v435,v445,v446,v447)
	dta h(v448,v449,v449,v449,v449,v453,v453,v453)
	dta h(v453,v453,v458,v458,v458,v458,v462,v462)
	dta h(v462,v462,v462,v458,v458,v469,v469,v469)
	dta h(v469,v469,v474,v474,v476,v476,v476,v479)
	dta h(v480,v480,v480,v480,v480,v480,v486,v486)
	dta h(v486,v486,v486,v491,v491,v491,v491,v495)
	dta h(v495,v495,v495,v495,v495,v495,v495,v503)
	dta h(v503,v503,v503,v503,v503,v503,v503,v503)
	dta h(v503,v503,v503,v503,v503,v503,v518,v518)
	dta h(v518,v518,v518,v518,v518,v525,v526,v526)
	dta h(v528,v528,v530,v531,v532,v532,v532,v532)
	dta h(v532,v532,v532,v532,v532,v541,v541,v541)
	dta h(v541,v541,v541,v541,v541,v541,v541,v541)
	dta h(v541,v541,v541,v555,v555,v557,v557,v557)
	dta h(v557,v557,v557,v557,v557,v557,v557,v557)
	dta h(v557,v557,v557,v557,v557,v557,v557,v557)
	dta h(v557,v557,v557,v557,v557,v557,v557,v557)
	dta h(v584,v584,v586,v586,v586,v589,v589,v589)
	dta h(v589,v589,v589,v589,v589,v589,v598,v598)
	dta h(v598,v598,v598,v598,v598,v598,v598,v598)
	dta h(v598,v598,v598,v611,v611,v611,v611,v611)
	dta h(v611,v611,v611,v611,v611,v611,v611,v611)
	dta h(v611,v611,v626,v626,v628,v629,v629,v629)
	dta h(v629,v629,v629,v635,v635,v637,v638,v639)
	dta h(v640,v640,v640,v640,v644,v645,v645,v645)
	dta h(v648,v648,v650,v650,v652,v652,v652,v652)
	dta h(v652,v652,v658,v658,v658,v658,v662,v662)
	dta h(v664,v664,v664,v664,v668,v668,v668,v671)
	dta h(v671,v671,v671,v671,v671,v671,v671,v671)
	dta h(v671,v671,v682,v682,v684,v684,v684,v684)
	dta h(v684,v684,v684,v684,v684,v684,v684,v684)
	dta h(v684,v684,v684,v684,v684,v684,v684,v684)
	dta h(v684,v684,v684,v707,v707,v707,v707,v707)
	dta h(v707,v707,v707,v707,v707,v707,v707,v707)



	ift rows

l_scr	dta l(screen+0,screen+40,screen+80,screen+120,screen+160,screen+200,screen+240,screen+280)
	dta l(screen+320,screen+360,screen+400,screen+440,screen+480,screen+520,screen+560,screen+600)
	dta l(screen+640,screen+680,screen+720,screen+760,screen+800,screen+840,screen+880,screen+920)
	dta l(screen+960,screen+1000,screen+1040,screen+1080,screen+1120,screen+1160,screen+1200,screen+1240)
	dta l(screen+1280,screen+1320,screen+1360,screen+1400,screen+1440,screen+1480,screen+1520,screen+1560)
	dta l(screen+1600,screen+1640,screen+1680,screen+1720,screen+1760,screen+1800,screen+1840,screen+1880)
	dta l(screen+1920,screen+1960,screen+2000,screen+2040,screen+2080,screen+2120,screen+2160,screen+2200)
	dta l(screen+2240,screen+2280,screen+2320,screen+2360,screen+2400,screen+2440,screen+2480,screen+2520)
	dta l(screen+2560,screen+2600,screen+2640,screen+2680,screen+2720,screen+2760,screen+2800,screen+2840)
	dta l(screen+2880,screen+2920,screen+2960,screen+3000,screen+3040,screen+3080,screen+3120,screen+3160)
	dta l(screen+3200,screen+3240,screen+3280,screen+3320,screen+3360,screen+3400,screen+3440,screen+3480)
	dta l(screen+3520,screen+3560)

h_scr	dta h(screen+0,screen+40,screen+80,screen+120,screen+160,screen+200,screen+240,screen+280)
	dta h(screen+320,screen+360,screen+400,screen+440,screen+480,screen+520,screen+560,screen+600)
	dta h(screen+640,screen+680,screen+720,screen+760,screen+800,screen+840,screen+880,screen+920)
	dta h(screen+960,screen+1000,screen+1040,screen+1080,screen+1120,screen+1160,screen+1200,screen+1240)
	dta h(screen+1280,screen+1320,screen+1360,screen+1400,screen+1440,screen+1480,screen+1520,screen+1560)
	dta h(screen+1600,screen+1640,screen+1680,screen+1720,screen+1760,screen+1800,screen+1840,screen+1880)
	dta h(screen+1920,screen+1960,screen+2000,screen+2040,screen+2080,screen+2120,screen+2160,screen+2200)
	dta h(screen+2240,screen+2280,screen+2320,screen+2360,screen+2400,screen+2440,screen+2480,screen+2520)
	dta h(screen+2560,screen+2600,screen+2640,screen+2680,screen+2720,screen+2760,screen+2800,screen+2840)
	dta h(screen+2880,screen+2920,screen+2960,screen+3000,screen+3040,screen+3080,screen+3120,screen+3160)
	dta h(screen+3200,screen+3240,screen+3280,screen+3320,screen+3360,screen+3400,screen+3440,screen+3480)
	dta h(screen+3520,screen+3560)

	eif

	icl "hvscrol.asm"

	.ALIGN $100
mis	ins "data\fin.mis"

	.ALIGN $100
pm0	ins "data\fin.pm0"

	.ALIGN $100
pm1	ins "data\fin.pm1"

	.ALIGN $100
pm2	ins "data\fin.pm2"

	.ALIGN $100
pm3	ins "data\fin.pm3"


end_mem_part
.if PGENE = 1
	run RUN_ADDRESS
.endif	
