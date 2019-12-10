PGENE = 0	//0-demo build, 1-standalone part

LOAD_ADDRESS	equ	$3000-3
RUN_ADDRESS		equ	main

.if PGENE = 0
	icl 'sls.hea'
	icl 'pd_macro.hea'
	part_header
.else
	org LOAD_ADDRESS-$400
	icl 'atari.hea'
	icl '..\..\lib\stdlib.asm'
	.align $400	
.endif



scr48	= %00111111	;screen 48b
scr40	= %00111110	;screen 40b
scr32	= %00111101	;screen 32b

temp	= first_free_zp
clock	= temp+2

pmg	= $c000

hposp0	= $D000
hposp1	= $D001
hposp2	= $D002
hposp3	= $D003
hposm0	= $D004
hposm1	= $D005
hposm2	= $D006
hposm3	= $D007
sizep0	= $D008
sizep1	= $D009
sizep2	= $D00A
sizep3	= $D00B
sizem	= $D00C
colpm0	= $D012
colpm1	= $D013
colpm2	= $D014
colpm3	= $D015
color0	= $D016
color1	= $D017
color2	= $D018
color3	= $D019
colbak	= $D01A
gtictl	= $D01B
chbase	= $D409
vscrol	= $d405

width	= 40
height	= 22

ile	= 60-height

rows	= 60*width>$1000

*---

screen
	ift rows
	ins "data\credits.row"
	els
	ins "data\credits.scr"
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

gfxmode	ins "data\credits.gfx"

	.ALIGN	$400
fnt	ins "data\credits.fnt"

	.get "data\credits.tab"

	ert *>$BFFF,"no ram"

	utils_wait_one_frame
	utils_wait_end_frame
	utils_wait_x_frame

main	.local
.if PGENE = 1
	jsr rom_off
.endif
	jsr wait_one_frame

	mva #0 clock
	INIT:UPDATE
	jsr wait_end_frame
	ldy	#0
	jsr	CREATE._nxt

	jsr wait_end_frame

	set_vbl vbl


	jsr prg

	mva #0 dmactl
	restore_nmi
.if PGENE = 0
 	lda #<trans
	ldy #>trans
	jsr OS_DECRUNCH
	jmp $400-3
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
	inc	clock
	set_dli dli	
	mva	>pmg	$d407
	mva	#3	$d01d
	mwa	#ant	$d402
	mva	#scr40	$d400

ffnt	mva	>fnt	$d409

ivbl	jsr	v0

ldli	mva	<d0	dliv+1
hdli	mva	>d0	dliv+2

	plr:rti

*---

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
 lda #$83
 sta $d40a	;17
 sta hposp3
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
 lda >fnt+.get[40/8]*$400
 sta $d40a	;40
 sta chbase
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
 lda >fnt+.get[48/8]*$400
 sta $d40a	;48
 sta chbase
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
 lda >fnt+.get[56/8]*$400
 sta $d40a	;56
 sta chbase
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
 lda #$88
 sta $d40a	;62
 sta colpm3
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
 lda #$00
 ldx #$A1
 sta $d40a	;68
 sta sizep3
 stx hposp3
d69
 sta $d40a	;69
d70
 lda #$00
 ldx #$A0
 sta $d40a	;70
 sta sizep2
 stx hposp2
d71
 lda #$1A
 ldx #$64
 sta $d40a	;71
 sta color1
 stx colpm2
d72
 lda >fnt+.get[72/8]*$400
 ldx #$16
 sta $d40a	;72
 sta chbase
 stx color0
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
 lda >fnt+.get[80/8]*$400
 sta $d40a	;80
 sta chbase
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
 lda #$64
 sta $d40a	;88
 sta color0
d89
 lda #$88
 ldx #$0E
 sta $d40a	;89
 sta color1
 stx colpm2
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
 lda #$66
 sta $d40a	;103
 sta hposp2
d104
 sta $d40a	;104
d105
 sta $d40a	;105
d106
 sta $d40a	;106
d107
 sta $d40a	;107
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
 lda #$6E
 sta $d40a	;126
 sta hposp2
d127
 lda #$01
 sta $d40a	;127
 sta sizep2
d128
 lda >fnt+.get[128/8]*$400
 sta $d40a	;128
 sta chbase
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
 lda #$10
 sta $d40a	;135
 sta sizem
d136
 sta $d40a	;136
d137
 lda #$8C
 sta $d40a	;137
 sta hposm2
d138
 sta $d40a	;138
d139
 sta $d40a	;139
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
 lda >fnt+.get[152/8]*$400
 sta $d40a	;152
 sta chbase
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
 lda >fnt+.get[160/8]*$400
 sta $d40a	;160
 sta chbase
d161
 sta $d40a	;161
d162
 sta $d40a	;162
d163
 sta $d40a	;163
d164
 sta $d40a	;164
d165
 sta $d40a	;165
d166
 sta $d40a	;166
d167
 sta $d40a	;167
d168
 lda >fnt+.get[168/8]*$400
 sta $d40a	;168
 sta chbase
d169
 sta $d40a	;169
d170
 sta $d40a	;170
d171
 sta $d40a	;171
d172
 sta $d40a	;172
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
 sta $d40a	;184
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
 sta $d40a	;195
d196
 sta $d40a	;196
d197
 sta $d40a	;197
d198
 sta $d40a	;198
d199
 sta $d40a	;199
d200
 sta $d40a	;200
d201
 sta $d40a	;201
d202
 sta $d40a	;202
d203
 sta $d40a	;203
d204
 sta $d40a	;204
d205
 sta $d40a	;205
d206
 sta $d40a	;206
d207
 sta $d40a	;207
d208
 lda #$04
 sta $d40a	;208
 sta gtictl
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
 sta $d40a	;228
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
 sta $d40a	;236
d237
 sta $d40a	;237
d238
 sta $d40a	;238
d239
 sta $d40a	;239
d240
 lda >fnt+.get[240/8]*$400
 ldx #$02
 sta $d40a	;240
 sta chbase
 stx gtictl
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
 sta $d40a	;261
d262
 sta $d40a	;262
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
 sta $d40a	;279
d280
 sta $d40a	;280
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
 sta $d40a	;301
d302
 sta $d40a	;302
d303
 sta $d40a	;303
d304
 sta $d40a	;304
d305
 sta $d40a	;305
d306
 sta $d40a	;306
d307
 sta $d40a	;307
d308
 sta $d40a	;308
d309
 sta $d40a	;309
d310
 sta $d40a	;310
d311
 sta $d40a	;311
d312
 sta $d40a	;312
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
 sta $d40a	;323
d324
 sta $d40a	;324
d325
 sta $d40a	;325
d326
 sta $d40a	;326
d327
 sta $d40a	;327
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
 sta $d40a	;335
d336
 sta $d40a	;336
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
 sta $d40a	;343
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
 sta $d40a	;360
d361
 sta $d40a	;361
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
 sta $d40a	;373
d374
 sta $d40a	;374
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
 sta $d40a	;384
d385
 sta $d40a	;385
d386
 sta $d40a	;386
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
 sta $d40a	;402
d403
 sta $d40a	;403
d404
 sta $d40a	;404
d405
 sta $d40a	;405
d406
 sta $d40a	;406
d407
 sta $d40a	;407
d408
 sta $d40a	;408
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
 sta $d40a	;418
d419
 sta $d40a	;419
d420
 sta $d40a	;420
d421
 sta $d40a	;421
d422
 sta $d40a	;422
d423
 sta $d40a	;423
d424
 sta $d40a	;424
d425
 sta $d40a	;425
d426
 sta $d40a	;426
d427
 sta $d40a	;427
d428
 sta $d40a	;428
d429
 sta $d40a	;429
d430
 sta $d40a	;430
d431
 sta $d40a	;431
d432
 sta $d40a	;432
d433
 sta $d40a	;433
d434
 sta $d40a	;434
d435
 sta $d40a	;435
d436
 sta $d40a	;436
d437
 sta $d40a	;437
d438
 sta $d40a	;438
d439
 sta $d40a	;439
d440
 sta $d40a	;440
d441
 sta $d40a	;441
d442
 sta $d40a	;442
d443
 sta $d40a	;443
d444
 sta $d40a	;444
d445
 sta $d40a	;445
d446
 sta $d40a	;446
d447
 sta $d40a	;447
d448
 sta $d40a	;448
d449
 sta $d40a	;449
d450
 sta $d40a	;450
d451
 sta $d40a	;451
d452
 sta $d40a	;452
d453
 sta $d40a	;453
d454
 sta $d40a	;454
d455
 sta $d40a	;455
d456
 sta $d40a	;456
d457
 sta $d40a	;457
d458
 sta $d40a	;458
d459
 sta $d40a	;459
d460
 sta $d40a	;460
d461
 sta $d40a	;461
d462
 sta $d40a	;462
d463
 sta $d40a	;463
d464
 sta $d40a	;464
d465
 sta $d40a	;465
d466
 sta $d40a	;466
d467
 sta $d40a	;467
d468
 sta $d40a	;468
d469
 sta $d40a	;469
d470
 sta $d40a	;470
d471
 sta $d40a	;471
d472
 sta $d40a	;472
d473
 sta $d40a	;473
d474
 sta $d40a	;474
d475
 sta $d40a	;475
d476
 sta $d40a	;476
d477
 sta $d40a	;477
d478
 sta $d40a	;478
d479
 sta $d40a	;479
d480
 sta $d40a	;480
d481
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
	dta l(d480,d481)

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
	dta h(d480,d481)

v0
 lda #$00
 sta colbak
 sta sizep1
 lda #$02
 sta gtictl
 lda #$03
 sta sizep3
 sta sizep2
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5C
 sta hposp2
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$7B
 sta hposp3
 lda #$88
 sta color1
 lda #$8A
 sta colpm3
 sta colpm2
 lda #$8F
 sta hposm2
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
 lda #$00
 sta colbak
 sta sizep1
 lda #$02
 sta gtictl
 lda #$03
 sta sizep2
 sta sizep3
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5C
 sta hposp2
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$7B
 sta hposp3
 lda #$88
 sta color1
 lda #$8A
 sta colpm2
 sta colpm3
 lda #$8F
 sta hposm2
 rts

v14
v15
v16
v17
 lda #$00
 sta colbak
 sta sizep1
 lda #$02
 sta gtictl
 lda #$03
 sta sizep2
 sta sizep3
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5C
 sta hposp2
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$83
 sta hposp3
 lda #$88
 sta color1
 lda #$8A
 sta colpm2
 sta colpm3
 lda #$8F
 sta hposm2
 rts

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
 lda #$00
 sta colbak
 sta sizep1
 lda #$02
 sta gtictl
 lda #$03
 sta sizep2
 sta sizep3
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5C
 sta hposp2
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$83
 sta hposp3
 lda #$88
 sta color1
 sta colpm3
 lda #$8A
 sta colpm2
 lda #$8F
 sta hposm2
 rts

v63
 lda #$00
 sta colbak
 sta sizep1
 sta sizep3
 lda #$02
 sta gtictl
 lda #$03
 sta sizep2
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5C
 sta hposp2
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$88
 sta color1
 sta colpm3
 lda #$8A
 sta colpm2
 lda #$8F
 sta hposm2
 lda #$A1
 sta hposp3
 rts

v64
v65
v66
v67
v68
v69
v70
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 lda #$40
 sta sizem
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$88
 sta color1
 sta colpm3
 lda #$8A
 sta colpm2
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 lda #$A1
 sta hposp3
 rts

v71
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 lda #$1A
 sta color1
 lda #$40
 sta sizem
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 sta colpm2
 lda #$88
 sta colpm3
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 lda #$A1
 sta hposp3
 rts

v72
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 lda #$16
 sta color0
 lda #$1A
 sta color1
 lda #$40
 sta sizem
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta colpm1
 sta colpm2
 lda #$88
 sta colpm3
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 lda #$A1
 sta hposp3
 rts

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
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 sta sizep3
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$40
 sta sizem
 lda #$5D
 sta hposp1
 lda #$60
 sta hposm3
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$88
 sta color1
 sta colpm3
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 lda #$A1
 sta hposp3
 rts

v90
v91
v92
 lda #$00
 sta colbak
 sta sizep1
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$5D
 sta hposp1
 lda #$62
 sta color3
 lda #$64
 sta color0
 sta colpm1
 lda #$88
 sta color1
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 rts

v93
 lda #$00
 sta colbak
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$88
 sta color1
 lda #$8F
 sta hposm2
 lda #$A0
 sta hposp2
 rts

v94
v95
v96
v97
v98
 lda #$00
 sta colbak
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$66
 sta hposp2
 lda #$88
 sta color1
 lda #$8F
 sta hposm2
 rts

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
 lda #$00
 sta colbak
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$6E
 sta hposp2
 lda #$88
 sta color1
 lda #$8F
 sta hposm2
 rts

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
v127
 lda #$00
 sta colbak
 lda #$01
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$6E
 sta hposp2
 lda #$88
 sta color1
 lda #$8F
 sta hposm2
 rts

v128
v129
v130
v131
v132
v133
v134
v135
v136
v137
 lda #$00
 sta colbak
 lda #$01
 sta sizep2
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$6E
 sta hposp2
 lda #$88
 sta color1
 lda #$8C
 sta hposm2
 rts

v138
v139
 lda #$00
 sta colbak
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 sta colpm2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$88
 sta color1
 lda #$8C
 sta hposm2
 rts

v140
 lda #$00
 sta colbak
 lda #$02
 sta gtictl
 lda #$0E
 sta color2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$88
 sta color1
 rts

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
v159
v160
v161
v162
v163
v164
v165
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
v190
v191
v192
v193
v194
v195
v196
v197
v198
v199
v200
v201
v202
v203
v204
v205
v206
v207
v208
 lda #$00
 sta colbak
 lda #$04
 sta gtictl
 lda #$0E
 sta color2
 lda #$62
 sta color3
 lda #$64
 sta color0
 lda #$88
 sta color1
 rts

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
v229
v230
v231
v232
v233
v234
v235
v236
v237
v238
v239
v240
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
v262
v263
v264
v265
v266
v267
v268
v269
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
v301
v302
v303
v304
v305
v306
v307
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
v324
v325
v326
v327
v328
v329
v330
v331
v332
v333
v334
v335
v336
v337
v338
v339
v340
v341
v342
v343
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
v374
v375
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
v403
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
v419
v420
v421
v422
v423
v424
v425
v426
v427
v428
v429
v430
v431
v432
v433
v434
v435
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
v446
v447
v448
v449
v450
v451
v452
v453
v454
v455
v456
v457
v458
v459
v460
v461
v462
v463
v464
v465
v466
v467
v468
v469
v470
v471
v472
v473
v474
v475
v476
v477
v478
v479

l_vbl	dta l(v0,v0,v0,v0,v0,v0,v0,v0)
	dta l(v0,v0,v0,v0,v0,v13,v13,v13)
	dta l(v13,v17,v17,v17,v17,v17,v17,v17)
	dta l(v17,v17,v17,v17,v17,v17,v17,v17)
	dta l(v17,v17,v17,v17,v17,v17,v17,v17)
	dta l(v17,v17,v17,v17,v17,v17,v17,v17)
	dta l(v17,v17,v17,v17,v17,v17,v17,v17)
	dta l(v17,v17,v17,v17,v17,v17,v62,v63)
	dta l(v63,v63,v63,v63,v63,v63,v70,v71)
	dta l(v72,v72,v72,v72,v72,v72,v72,v72)
	dta l(v72,v72,v72,v72,v72,v72,v72,v72)
	dta l(v71,v89,v89,v89,v92,v93,v93,v93)
	dta l(v93,v93,v98,v98,v98,v98,v98,v98)
	dta l(v98,v98,v98,v98,v98,v98,v98,v98)
	dta l(v112,v112,v112,v112,v112,v112,v112,v112)
	dta l(v112,v112,v112,v112,v112,v112,v112,v127)
	dta l(v127,v127,v127,v127,v127,v127,v127,v127)
	dta l(v127,v137,v137,v139,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v208,v208,v208,v208,v208,v208,v208,v208)
	dta l(v208,v208,v208,v208,v208,v208,v208,v208)
	dta l(v208,v208,v208,v208,v208,v208,v208,v208)
	dta l(v208,v208,v208,v208,v208,v208,v208,v208)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)
	dta l(v140,v140,v140,v140,v140,v140,v140,v140)

h_vbl	dta h(v0,v0,v0,v0,v0,v0,v0,v0)
	dta h(v0,v0,v0,v0,v0,v13,v13,v13)
	dta h(v13,v17,v17,v17,v17,v17,v17,v17)
	dta h(v17,v17,v17,v17,v17,v17,v17,v17)
	dta h(v17,v17,v17,v17,v17,v17,v17,v17)
	dta h(v17,v17,v17,v17,v17,v17,v17,v17)
	dta h(v17,v17,v17,v17,v17,v17,v17,v17)
	dta h(v17,v17,v17,v17,v17,v17,v62,v63)
	dta h(v63,v63,v63,v63,v63,v63,v70,v71)
	dta h(v72,v72,v72,v72,v72,v72,v72,v72)
	dta h(v72,v72,v72,v72,v72,v72,v72,v72)
	dta h(v71,v89,v89,v89,v92,v93,v93,v93)
	dta h(v93,v93,v98,v98,v98,v98,v98,v98)
	dta h(v98,v98,v98,v98,v98,v98,v98,v98)
	dta h(v112,v112,v112,v112,v112,v112,v112,v112)
	dta h(v112,v112,v112,v112,v112,v112,v112,v127)
	dta h(v127,v127,v127,v127,v127,v127,v127,v127)
	dta h(v127,v137,v137,v139,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v208,v208,v208,v208,v208,v208,v208,v208)
	dta h(v208,v208,v208,v208,v208,v208,v208,v208)
	dta h(v208,v208,v208,v208,v208,v208,v208,v208)
	dta h(v208,v208,v208,v208,v208,v208,v208,v208)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)
	dta h(v140,v140,v140,v140,v140,v140,v140,v140)



	ift rows

l_scr	dta l(screen+0,screen+40,screen+80,screen+120,screen+160,screen+200,screen+240,screen+280)
	dta l(screen+320,screen+360,screen+400,screen+440,screen+480,screen+520,screen+560,screen+600)
	dta l(screen+640,screen+680,screen+720,screen+760,screen+800,screen+840,screen+880,screen+880)
	dta l(screen+880,screen+880,screen+880,screen+880,screen+880,screen+880,screen+880,screen+880)
	dta l(screen+920,screen+960,screen+1000,screen+1040,screen+1080,screen+1120,screen+1160,screen+1200)
	dta l(screen+1240,screen+1280,screen+1320,screen+1360,screen+1400,screen+1440,screen+1480,screen+1520)
	dta l(screen+1560,screen+1600,screen+1640,screen+1680,screen+1720,screen+1760,screen+1800,screen+1840)
	dta l(screen+880,screen+880,screen+880,screen+880)

h_scr	dta h(screen+0,screen+40,screen+80,screen+120,screen+160,screen+200,screen+240,screen+280)
	dta h(screen+320,screen+360,screen+400,screen+440,screen+480,screen+520,screen+560,screen+600)
	dta h(screen+640,screen+680,screen+720,screen+760,screen+800,screen+840,screen+880,screen+880)
	dta h(screen+880,screen+880,screen+880,screen+880,screen+880,screen+880,screen+880,screen+880)
	dta h(screen+920,screen+960,screen+1000,screen+1040,screen+1080,screen+1120,screen+1160,screen+1200)
	dta h(screen+1240,screen+1280,screen+1320,screen+1360,screen+1400,screen+1440,screen+1480,screen+1520)
	dta h(screen+1560,screen+1600,screen+1640,screen+1680,screen+1720,screen+1760,screen+1800,screen+1840)
	dta h(screen+880,screen+880,screen+880,screen+880)

	eif

	icl "hvscrol.asm"

	.ALIGN $100
mis	ins "data\credits.mis"

	.ALIGN $100
pm0	ins "data\credits.pm0"

	.ALIGN $100
pm1	ins "data\credits.pm1"

	.ALIGN $100
pm2	ins "data\credits.pm2"

	.ALIGN $100
pm3	ins "data\credits.pm3"

trans ins "19_go_to_vscroll2.obx.bc"

.if PGENE = 1
	run RUN_ADDRESS
.endif	
