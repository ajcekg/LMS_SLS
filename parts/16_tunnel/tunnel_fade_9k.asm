// frame 0
    cpw anim_loop_step #0
    beq fx_fade_before0
    jmp fx_fade_after0
fx_fade_before0
    lda bg+33
    sta screen+33
    lda bg+73
    sta screen+73
    lda bg+34
    sta screen+34
    lda bg+74
    sta screen+74
    lda bg+114
    sta screen+114
    lda bg+154
    sta screen+154
    lda bg+434
    sta screen+434
    lda bg+474
    sta screen+474
    lda bg+514
    sta screen+514
    lda bg+554
    sta screen+554
    lda bg+594
    sta screen+594
    lda bg+634
    sta screen+634
    lda bg+674
    sta screen+674
    lda bg+714
    sta screen+714
    lda bg+35
    sta screen+35
    lda bg+75
    sta screen+75
    lda bg+115
    sta screen+115
    lda bg+155
    sta screen+155
    lda bg+435
    sta screen+435
    lda bg+475
    sta screen+475
    lda bg+515
    sta screen+515
    lda bg+555
    sta screen+555
    lda bg+595
    sta screen+595
    lda bg+635
    sta screen+635
    lda bg+675
    sta screen+675
    lda bg+715
    sta screen+715
    lda bg+36
    sta screen+36
    lda bg+76
    sta screen+76
    lda bg+116
    sta screen+116
    lda bg+156
    sta screen+156
    lda bg+596
    sta screen+596
    lda bg+636
    sta screen+636
    lda bg+37
    sta screen+37
    lda bg+77
    sta screen+77
    lda bg+38
    sta screen+38
    lda bg+78
    sta screen+78
    lda bg+39
    sta screen+39
    lda bg+79
    sta screen+79
    lda bg+119
    sta screen+119
    lda bg+159
    sta screen+159
fx_fade_after0
// frame 1
    cpw anim_loop_step #1
    beq fx_fade_before1
    jmp fx_fade_after1
fx_fade_before1
    lda bg+593
    sta screen+593
    lda bg+633
    sta screen+633
    lda bg+195
    sta screen+195
    lda bg+235
    sta screen+235
    lda bg+355
    sta screen+355
    lda bg+395
    sta screen+395
    lda bg+436
    sta screen+436
    lda bg+476
    sta screen+476
    lda bg+516
    sta screen+516
    lda bg+556
    sta screen+556
    lda bg+676
    sta screen+676
    lda bg+716
    sta screen+716
    lda bg+117
    sta screen+117
    lda bg+157
    sta screen+157
    lda bg+118
    sta screen+118
    lda bg+158
    sta screen+158
    lda bg+439
    sta screen+439
    lda bg+479
    sta screen+479
fx_fade_after1
// frame 2
    cpw anim_loop_step #2
    beq fx_fade_before2
    jmp fx_fade_after2
fx_fade_before2
    lda bg+28
    sta screen+28
    lda bg+68
    sta screen+68
    lda bg+29
    sta screen+29
    lda bg+69
    sta screen+69
    lda bg+32
    sta screen+32
    lda bg+72
    sta screen+72
    lda bg+113
    sta screen+113
    lda bg+153
    sta screen+153
    lda bg+513
    sta screen+513
    lda bg+553
    sta screen+553
    lda bg+194
    sta screen+194
    lda bg+234
    sta screen+234
    lda bg+354
    sta screen+354
    lda bg+394
    sta screen+394
    lda bg+275
    sta screen+275
    lda bg+315
    sta screen+315
    lda bg+755
    sta screen+755
    lda bg+795
    sta screen+795
    lda bg+196
    sta screen+196
    lda bg+236
    sta screen+236
    lda bg+517
    sta screen+517
    lda bg+557
    sta screen+557
    lda bg+597
    sta screen+597
    lda bg+637
    sta screen+637
    lda bg+199
    sta screen+199
    lda bg+239
    sta screen+239
fx_fade_after2
// frame 3
    cpw anim_loop_step #3
    beq fx_fade_before3
    jmp fx_fade_after3
fx_fade_before3
    lda bg+27
    sta screen+27
    lda bg+67
    sta screen+67
    lda bg+508
    sta screen+508
    lda bg+548
    sta screen+548
    lda bg+588
    sta screen+588
    lda bg+628
    sta screen+628
    lda bg+30
    sta screen+30
    lda bg+70
    sta screen+70
    lda bg+673
    sta screen+673
    lda bg+713
    sta screen+713
    lda bg+274
    sta screen+274
    lda bg+314
    sta screen+314
    lda bg+754
    sta screen+754
    lda bg+794
    sta screen+794
    lda bg+1235
    sta screen+1235
    lda bg+1275
    sta screen+1275
    lda bg+276
    sta screen+276
    lda bg+316
    sta screen+316
    lda bg+356
    sta screen+356
    lda bg+396
    sta screen+396
    lda bg+197
    sta screen+197
    lda bg+237
    sta screen+237
    lda bg+437
    sta screen+437
    lda bg+477
    sta screen+477
    lda bg+677
    sta screen+677
    lda bg+717
    sta screen+717
    lda bg+518
    sta screen+518
    lda bg+558
    sta screen+558
    lda bg+279
    sta screen+279
    lda bg+319
    sta screen+319
    lda bg+359
    sta screen+359
    lda bg+399
    sta screen+399
fx_fade_after3
// frame 4
    cpw anim_loop_step #4
    beq fx_fade_before4
    jmp fx_fade_after4
fx_fade_before4
    lda bg+507
    sta screen+507
    lda bg+547
    sta screen+547
    lda bg+587
    sta screen+587
    lda bg+627
    sta screen+627
    lda bg+109
    sta screen+109
    lda bg+149
    sta screen+149
    lda bg+509
    sta screen+509
    lda bg+549
    sta screen+549
    lda bg+589
    sta screen+589
    lda bg+629
    sta screen+629
    lda bg+31
    sta screen+31
    lda bg+71
    sta screen+71
    lda bg+193
    sta screen+193
    lda bg+233
    sta screen+233
    lda bg+433
    sta screen+433
    lda bg+473
    sta screen+473
    lda bg+1234
    sta screen+1234
    lda bg+1274
    sta screen+1274
    lda bg+1155
    sta screen+1155
    lda bg+1195
    sta screen+1195
    lda bg+1315
    sta screen+1315
    lda bg+1355
    sta screen+1355
    lda bg+756
    sta screen+756
    lda bg+796
    sta screen+796
    lda bg+198
    sta screen+198
    lda bg+238
    sta screen+238
    lda bg+438
    sta screen+438
    lda bg+478
    sta screen+478
fx_fade_after4
// frame 5
    cpw anim_loop_step #5
    beq fx_fade_before5
    jmp fx_fade_after5
fx_fade_before5
    lda bg+26
    sta screen+26
    lda bg+66
    sta screen+66
    lda bg+108
    sta screen+108
    lda bg+148
    sta screen+148
    lda bg+428
    sta screen+428
    lda bg+468
    sta screen+468
    lda bg+668
    sta screen+668
    lda bg+708
    sta screen+708
    lda bg+112
    sta screen+112
    lda bg+152
    sta screen+152
    lda bg+592
    sta screen+592
    lda bg+632
    sta screen+632
    lda bg+353
    sta screen+353
    lda bg+393
    sta screen+393
    lda bg+1154
    sta screen+1154
    lda bg+1194
    sta screen+1194
    lda bg+1314
    sta screen+1314
    lda bg+1354
    sta screen+1354
    lda bg+835
    sta screen+835
    lda bg+875
    sta screen+875
    lda bg+277
    sta screen+277
    lda bg+317
    sta screen+317
    lda bg+358
    sta screen+358
    lda bg+398
    sta screen+398
fx_fade_after5
// frame 6
    cpw anim_loop_step #6
    beq fx_fade_before6
    jmp fx_fade_after6
fx_fade_before6
    lda bg+107
    sta screen+107
    lda bg+147
    sta screen+147
    lda bg+669
    sta screen+669
    lda bg+709
    sta screen+709
    lda bg+512
    sta screen+512
    lda bg+552
    sta screen+552
    lda bg+273
    sta screen+273
    lda bg+313
    sta screen+313
    lda bg+753
    sta screen+753
    lda bg+793
    sta screen+793
    lda bg+1075
    sta screen+1075
    lda bg+1115
    sta screen+1115
    lda bg+1156
    sta screen+1156
    lda bg+1196
    sta screen+1196
    lda bg+1316
    sta screen+1316
    lda bg+1356
    sta screen+1356
    lda bg+278
    sta screen+278
    lda bg+318
    sta screen+318
fx_fade_after6
// frame 7
    cpw anim_loop_step #7
    beq fx_fade_before7
    jmp fx_fade_after7
fx_fade_before7
    lda bg+427
    sta screen+427
    lda bg+467
    sta screen+467
    lda bg+429
    sta screen+429
    lda bg+469
    sta screen+469
    lda bg+110
    sta screen+110
    lda bg+150
    sta screen+150
    lda bg+590
    sta screen+590
    lda bg+630
    sta screen+630
    lda bg+1074
    sta screen+1074
    lda bg+1114
    sta screen+1114
    lda bg+1395
    sta screen+1395
    lda bg+1435
    sta screen+1435
    lda bg+836
    sta screen+836
    lda bg+876
    sta screen+876
fx_fade_after7
// frame 8
    cpw anim_loop_step #8
    beq fx_fade_before8
    jmp fx_fade_after8
fx_fade_before8
    lda bg+188
    sta screen+188
    lda bg+228
    sta screen+228
    lda bg+189
    sta screen+189
    lda bg+229
    sta screen+229
    lda bg+510
    sta screen+510
    lda bg+550
    sta screen+550
    lda bg+111
    sta screen+111
    lda bg+151
    sta screen+151
    lda bg+591
    sta screen+591
    lda bg+631
    sta screen+631
    lda bg+672
    sta screen+672
    lda bg+712
    sta screen+712
    lda bg+1233
    sta screen+1233
    lda bg+1273
    sta screen+1273
    lda bg+995
    sta screen+995
    lda bg+1035
    sta screen+1035
    lda bg+1076
    sta screen+1076
    lda bg+1116
    sta screen+1116
fx_fade_after8
// frame 9
    cpw anim_loop_step #9
    beq fx_fade_before9
    jmp fx_fade_after9
fx_fade_before9
    lda bg+22
    sta screen+22
    lda bg+62
    sta screen+62
    lda bg+106
    sta screen+106
    lda bg+146
    sta screen+146
    lda bg+187
    sta screen+187
    lda bg+227
    sta screen+227
    lda bg+268
    sta screen+268
    lda bg+308
    sta screen+308
    lda bg+748
    sta screen+748
    lda bg+788
    sta screen+788
    lda bg+511
    sta screen+511
    lda bg+551
    sta screen+551
    lda bg+192
    sta screen+192
    lda bg+232
    sta screen+232
    lda bg+432
    sta screen+432
    lda bg+472
    sta screen+472
    lda bg+1153
    sta screen+1153
    lda bg+1193
    sta screen+1193
    lda bg+914
    sta screen+914
    lda bg+954
    sta screen+954
    lda bg+1394
    sta screen+1394
    lda bg+1434
    sta screen+1434
    lda bg+1157
    sta screen+1157
    lda bg+1197
    sta screen+1197
    lda bg+1237
    sta screen+1237
    lda bg+1277
    sta screen+1277
fx_fade_after9
// frame 10
    cpw anim_loop_step #10
    beq fx_fade_before10
    jmp fx_fade_after10
fx_fade_before10
    lda bg+21
    sta screen+21
    lda bg+61
    sta screen+61
    lda bg+23
    sta screen+23
    lda bg+63
    sta screen+63
    lda bg+25
    sta screen+25
    lda bg+65
    sta screen+65
    lda bg+347
    sta screen+347
    lda bg+387
    sta screen+387
    lda bg+269
    sta screen+269
    lda bg+309
    sta screen+309
    lda bg+349
    sta screen+349
    lda bg+389
    sta screen+389
    lda bg+670
    sta screen+670
    lda bg+710
    sta screen+710
    lda bg+1313
    sta screen+1313
    lda bg+1353
    sta screen+1353
    lda bg+994
    sta screen+994
    lda bg+1034
    sta screen+1034
    lda bg+1875
    sta screen+1875
    lda bg+1915
    sta screen+1915
    lda bg+1396
    sta screen+1396
    lda bg+1436
    sta screen+1436
fx_fade_after10
// frame 11
    cpw anim_loop_step #11
    beq fx_fade_before11
    jmp fx_fade_after11
fx_fade_before11
    lda bg+267
    sta screen+267
    lda bg+307
    sta screen+307
    lda bg+1228
    sta screen+1228
    lda bg+1268
    sta screen+1268
    lda bg+749
    sta screen+749
    lda bg+789
    sta screen+789
    lda bg+430
    sta screen+430
    lda bg+470
    sta screen+470
    lda bg+671
    sta screen+671
    lda bg+711
    sta screen+711
    lda bg+916
    sta screen+916
    lda bg+956
    sta screen+956
    lda bg+996
    sta screen+996
    lda bg+1036
    sta screen+1036
    lda bg+1317
    sta screen+1317
    lda bg+1357
    sta screen+1357
fx_fade_after11
// frame 12
    cpw anim_loop_step #12
    beq fx_fade_before12
    jmp fx_fade_after12
fx_fade_before12
    lda bg+20
    sta screen+20
    lda bg+60
    sta screen+60
    lda bg+190
    sta screen+190
    lda bg+230
    sta screen+230
    lda bg+352
    sta screen+352
    lda bg+392
    sta screen+392
    lda bg+833
    sta screen+833
    lda bg+873
    sta screen+873
    lda bg+1955
    sta screen+1955
    lda bg+1995
    sta screen+1995
    lda bg+1077
    sta screen+1077
    lda bg+1117
    sta screen+1117
fx_fade_after12
// frame 13
    cpw anim_loop_step #13
    beq fx_fade_before13
    jmp fx_fade_after13
fx_fade_before13
    lda bg+24
    sta screen+24
    lda bg+64
    sta screen+64
    lda bg+1148
    sta screen+1148
    lda bg+1188
    sta screen+1188
    lda bg+1308
    sta screen+1308
    lda bg+1348
    sta screen+1348
    lda bg+191
    sta screen+191
    lda bg+231
    sta screen+231
    lda bg+431
    sta screen+431
    lda bg+471
    sta screen+471
    lda bg+272
    sta screen+272
    lda bg+312
    sta screen+312
    lda bg+752
    sta screen+752
    lda bg+792
    sta screen+792
    lda bg+1073
    sta screen+1073
    lda bg+1113
    sta screen+1113
    lda bg+1874
    sta screen+1874
    lda bg+1914
    sta screen+1914
fx_fade_after13
// frame 14
    cpw anim_loop_step #14
    beq fx_fade_before14
    jmp fx_fade_after14
fx_fade_before14
    lda bg+102
    sta screen+102
    lda bg+142
    sta screen+142
    lda bg+426
    sta screen+426
    lda bg+466
    sta screen+466
    lda bg+1227
    sta screen+1227
    lda bg+1267
    sta screen+1267
    lda bg+1229
    sta screen+1229
    lda bg+1269
    sta screen+1269
    lda bg+1954
    sta screen+1954
    lda bg+1994
    sta screen+1994
    lda bg+1475
    sta screen+1475
    lda bg+1515
    sta screen+1515
    lda bg+1795
    sta screen+1795
    lda bg+1835
    sta screen+1835
    lda bg+1318
    sta screen+1318
    lda bg+1358
    sta screen+1358
fx_fade_after14
// frame 15
    cpw anim_loop_step #15
    beq fx_fade_before15
    jmp fx_fade_after15
fx_fade_before15
    lda bg+101
    sta screen+101
    lda bg+141
    sta screen+141
    lda bg+186
    sta screen+186
    lda bg+226
    sta screen+226
    lda bg+1147
    sta screen+1147
    lda bg+1187
    sta screen+1187
    lda bg+828
    sta screen+828
    lda bg+868
    sta screen+868
    lda bg+1149
    sta screen+1149
    lda bg+1189
    sta screen+1189
    lda bg+270
    sta screen+270
    lda bg+310
    sta screen+310
    lda bg+350
    sta screen+350
    lda bg+390
    sta screen+390
    lda bg+1876
    sta screen+1876
    lda bg+1916
    sta screen+1916
    lda bg+1397
    sta screen+1397
    lda bg+1437
    sta screen+1437
fx_fade_after15
// frame 16
    cpw anim_loop_step #16
    beq fx_fade_before16
    jmp fx_fade_after16
fx_fade_before16
    lda bg+19
    sta screen+19
    lda bg+59
    sta screen+59
    lda bg+1307
    sta screen+1307
    lda bg+1347
    sta screen+1347
    lda bg+1309
    sta screen+1309
    lda bg+1349
    sta screen+1349
    lda bg+1393
    sta screen+1393
    lda bg+1433
    sta screen+1433
    lda bg+1474
    sta screen+1474
    lda bg+1514
    sta screen+1514
    lda bg+1794
    sta screen+1794
    lda bg+1834
    sta screen+1834
    lda bg+997
    sta screen+997
    lda bg+1037
    sta screen+1037
fx_fade_after16
// frame 17
    cpw anim_loop_step #17
    beq fx_fade_before17
    jmp fx_fade_after17
fx_fade_before17
    lda bg+105
    sta screen+105
    lda bg+145
    sta screen+145
    lda bg+750
    sta screen+750
    lda bg+790
    sta screen+790
    lda bg+351
    sta screen+351
    lda bg+391
    sta screen+391
    lda bg+1232
    sta screen+1232
    lda bg+1272
    sta screen+1272
    lda bg+913
    sta screen+913
    lda bg+953
    sta screen+953
    lda bg+993
    sta screen+993
    lda bg+1033
    sta screen+1033
    lda bg+1956
    sta screen+1956
    lda bg+1996
    sta screen+1996
    lda bg+1398
    sta screen+1398
    lda bg+1438
    sta screen+1438
fx_fade_after17
// frame 18
    cpw anim_loop_step #18
    beq fx_fade_before18
    jmp fx_fade_after18
fx_fade_before18
    lda bg+100
    sta screen+100
    lda bg+140
    sta screen+140
    lda bg+103
    sta screen+103
    lda bg+143
    sta screen+143
    lda bg+346
    sta screen+346
    lda bg+386
    sta screen+386
    lda bg+1068
    sta screen+1068
    lda bg+1108
    sta screen+1108
    lda bg+271
    sta screen+271
    lda bg+311
    sta screen+311
    lda bg+1152
    sta screen+1152
    lda bg+1192
    sta screen+1192
    lda bg+1715
    sta screen+1715
    lda bg+1755
    sta screen+1755
    lda bg+2035
    sta screen+2035
    lda bg+2075
    sta screen+2075
    lda bg+1476
    sta screen+1476
    lda bg+1516
    sta screen+1516
    lda bg+1796
    sta screen+1796
    lda bg+1836
    sta screen+1836
    lda bg+1479
    sta screen+1479
    lda bg+1519
    sta screen+1519
fx_fade_after18
// frame 19
    cpw anim_loop_step #19
    beq fx_fade_before19
    jmp fx_fade_after19
fx_fade_before19
    lda bg+266
    sta screen+266
    lda bg+306
    sta screen+306
    lda bg+829
    sta screen+829
    lda bg+869
    sta screen+869
    lda bg+751
    sta screen+751
    lda bg+791
    sta screen+791
    lda bg+1312
    sta screen+1312
    lda bg+1352
    sta screen+1352
fx_fade_after19
// frame 20
    cpw anim_loop_step #20
    beq fx_fade_before20
    jmp fx_fade_after20
fx_fade_before20
    lda bg+182
    sta screen+182
    lda bg+222
    sta screen+222
    lda bg+104
    sta screen+104
    lda bg+144
    sta screen+144
    lda bg+908
    sta screen+908
    lda bg+948
    sta screen+948
    lda bg+988
    sta screen+988
    lda bg+1028
    sta screen+1028
    lda bg+1388
    sta screen+1388
    lda bg+1428
    sta screen+1428
    lda bg+1069
    sta screen+1069
    lda bg+1109
    sta screen+1109
    lda bg+1230
    sta screen+1230
    lda bg+1270
    sta screen+1270
    lda bg+832
    sta screen+832
    lda bg+872
    sta screen+872
    lda bg+1714
    sta screen+1714
    lda bg+1754
    sta screen+1754
    lda bg+2034
    sta screen+2034
    lda bg+2074
    sta screen+2074
    lda bg+1555
    sta screen+1555
    lda bg+1595
    sta screen+1595
    lda bg+1799
    sta screen+1799
    lda bg+1839
    sta screen+1839
fx_fade_after20
// frame 21
    cpw anim_loop_step #21
    beq fx_fade_before21
    jmp fx_fade_after21
fx_fade_before21
    lda bg+15
    sta screen+15
    lda bg+55
    sta screen+55
    lda bg+181
    sta screen+181
    lda bg+221
    sta screen+221
    lda bg+504
    sta screen+504
    lda bg+544
    sta screen+544
    lda bg+584
    sta screen+584
    lda bg+624
    sta screen+624
    lda bg+1150
    sta screen+1150
    lda bg+1190
    sta screen+1190
    lda bg+1310
    sta screen+1310
    lda bg+1350
    sta screen+1350
    lda bg+1231
    sta screen+1231
    lda bg+1271
    sta screen+1271
    lda bg+1873
    sta screen+1873
    lda bg+1913
    sta screen+1913
    lda bg+1554
    sta screen+1554
    lda bg+1594
    sta screen+1594
    lda bg+1635
    sta screen+1635
    lda bg+1675
    sta screen+1675
    lda bg+1879
    sta screen+1879
    lda bg+1919
    sta screen+1919
fx_fade_after21
// frame 22
    cpw anim_loop_step #22
    beq fx_fade_before22
    jmp fx_fade_after22
fx_fade_before22
    lda bg+99
    sta screen+99
    lda bg+139
    sta screen+139
    lda bg+261
    sta screen+261
    lda bg+301
    sta screen+301
    lda bg+663
    sta screen+663
    lda bg+703
    sta screen+703
    lda bg+1387
    sta screen+1387
    lda bg+1427
    sta screen+1427
    lda bg+1389
    sta screen+1389
    lda bg+1429
    sta screen+1429
    lda bg+1072
    sta screen+1072
    lda bg+1112
    sta screen+1112
    lda bg+1953
    sta screen+1953
    lda bg+1993
    sta screen+1993
    lda bg+1716
    sta screen+1716
    lda bg+1756
    sta screen+1756
    lda bg+2036
    sta screen+2036
    lda bg+2076
    sta screen+2076
    lda bg+1877
    sta screen+1877
    lda bg+1917
    sta screen+1917
    lda bg+1719
    sta screen+1719
    lda bg+1759
    sta screen+1759
fx_fade_after22
// frame 23
    cpw anim_loop_step #23
    beq fx_fade_before23
    jmp fx_fade_after23
fx_fade_before23
    lda bg+18
    sta screen+18
    lda bg+58
    sta screen+58
    lda bg+180
    sta screen+180
    lda bg+220
    sta screen+220
    lda bg+262
    sta screen+262
    lda bg+302
    sta screen+302
    lda bg+425
    sta screen+425
    lda bg+465
    sta screen+465
    lda bg+1151
    sta screen+1151
    lda bg+1191
    sta screen+1191
    lda bg+1634
    sta screen+1634
    lda bg+1674
    sta screen+1674
    lda bg+1556
    sta screen+1556
    lda bg+1596
    sta screen+1596
    lda bg+1477
    sta screen+1477
    lda bg+1517
    sta screen+1517
    lda bg+1797
    sta screen+1797
    lda bg+1837
    sta screen+1837
fx_fade_after23
// frame 24
    cpw anim_loop_step #24
    beq fx_fade_before24
    jmp fx_fade_after24
fx_fade_before24
    lda bg+16
    sta screen+16
    lda bg+56
    sta screen+56
    lda bg+185
    sta screen+185
    lda bg+225
    sta screen+225
    lda bg+909
    sta screen+909
    lda bg+949
    sta screen+949
    lda bg+830
    sta screen+830
    lda bg+870
    sta screen+870
    lda bg+1311
    sta screen+1311
    lda bg+1351
    sta screen+1351
    lda bg+1957
    sta screen+1957
    lda bg+1997
    sta screen+1997
    lda bg+1478
    sta screen+1478
    lda bg+1518
    sta screen+1518
    lda bg+1959
    sta screen+1959
    lda bg+1999
    sta screen+1999
fx_fade_after24
// frame 25
    cpw anim_loop_step #25
    beq fx_fade_before25
    jmp fx_fade_after25
fx_fade_before25
    lda bg+14
    sta screen+14
    lda bg+54
    sta screen+54
    lda bg+1221
    sta screen+1221
    lda bg+1261
    sta screen+1261
    lda bg+1868
    sta screen+1868
    lda bg+1908
    sta screen+1908
    lda bg+1473
    sta screen+1473
    lda bg+1513
    sta screen+1513
    lda bg+1793
    sta screen+1793
    lda bg+1833
    sta screen+1833
    lda bg+1559
    sta screen+1559
    lda bg+1599
    sta screen+1599
fx_fade_after25
// frame 26
    cpw anim_loop_step #26
    beq fx_fade_before26
    jmp fx_fade_after26
fx_fade_before26
    lda bg+1146
    sta screen+1146
    lda bg+1186
    sta screen+1186
fx_fade_after26
// frame 27
    cpw anim_loop_step #27
    beq fx_fade_before27
    jmp fx_fade_after27
fx_fade_before27
    lda bg+260
    sta screen+260
    lda bg+300
    sta screen+300
    lda bg+183
    sta screen+183
    lda bg+223
    sta screen+223
    lda bg+1948
    sta screen+1948
    lda bg+1988
    sta screen+1988
    lda bg+1070
    sta screen+1070
    lda bg+1110
    sta screen+1110
    lda bg+831
    sta screen+831
    lda bg+871
    sta screen+871
    lda bg+1392
    sta screen+1392
    lda bg+1432
    sta screen+1432
    lda bg+1636
    sta screen+1636
    lda bg+1676
    sta screen+1676
    lda bg+1798
    sta screen+1798
    lda bg+1838
    sta screen+1838
    lda bg+1878
    sta screen+1878
    lda bg+1918
    sta screen+1918
    lda bg+1639
    sta screen+1639
    lda bg+1679
    sta screen+1679
    lda bg+2039
    sta screen+2039
    lda bg+2079
    sta screen+2079
fx_fade_after27
// frame 28
    cpw anim_loop_step #28
    beq fx_fade_before28
    jmp fx_fade_after28
fx_fade_before28
    lda bg+13
    sta screen+13
    lda bg+53
    sta screen+53
    lda bg+1141
    sta screen+1141
    lda bg+1181
    sta screen+1181
    lda bg+912
    sta screen+912
    lda bg+952
    sta screen+952
    lda bg+2115
    sta screen+2115
    lda bg+2155
    sta screen+2155
    lda bg+1958
    sta screen+1958
    lda bg+1998
    sta screen+1998
fx_fade_after28
// frame 29
    cpw anim_loop_step #29
    beq fx_fade_before29
    jmp fx_fade_after29
fx_fade_before29
    lda bg+495
    sta screen+495
    lda bg+535
    sta screen+535
    lda bg+17
    sta screen+17
    lda bg+57
    sta screen+57
    lda bg+1301
    sta screen+1301
    lda bg+1341
    sta screen+1341
    lda bg+1222
    sta screen+1222
    lda bg+1262
    sta screen+1262
    lda bg+345
    sta screen+345
    lda bg+385
    sta screen+385
    lda bg+1788
    sta screen+1788
    lda bg+1828
    sta screen+1828
    lda bg+992
    sta screen+992
    lda bg+1032
    sta screen+1032
    lda bg+1717
    sta screen+1717
    lda bg+1757
    sta screen+1757
    lda bg+2037
    sta screen+2037
    lda bg+2077
    sta screen+2077
    lda bg+2038
    sta screen+2038
    lda bg+2078
    sta screen+2078
fx_fade_after29
// frame 30
    cpw anim_loop_step #30
    beq fx_fade_before30
    jmp fx_fade_after30
fx_fade_before30
    lda bg+184
    sta screen+184
    lda bg+224
    sta screen+224
    lda bg+265
    sta screen+265
    lda bg+305
    sta screen+305
    lda bg+1867
    sta screen+1867
    lda bg+1907
    sta screen+1907
    lda bg+1468
    sta screen+1468
    lda bg+1508
    sta screen+1508
    lda bg+1869
    sta screen+1869
    lda bg+1909
    sta screen+1909
    lda bg+1071
    sta screen+1071
    lda bg+1111
    sta screen+1111
fx_fade_after30
// frame 31
    cpw anim_loop_step #31
    beq fx_fade_before31
    jmp fx_fade_after31
fx_fade_before31
    lda bg+95
    sta screen+95
    lda bg+135
    sta screen+135
    lda bg+1220
    sta screen+1220
    lda bg+1260
    sta screen+1260
    lda bg+1142
    sta screen+1142
    lda bg+1182
    sta screen+1182
    lda bg+263
    sta screen+263
    lda bg+303
    sta screen+303
    lda bg+343
    sta screen+343
    lda bg+383
    sta screen+383
    lda bg+1947
    sta screen+1947
    lda bg+1987
    sta screen+1987
    lda bg+910
    sta screen+910
    lda bg+950
    sta screen+950
    lda bg+1390
    sta screen+1390
    lda bg+1430
    sta screen+1430
    lda bg+1713
    sta screen+1713
    lda bg+1753
    sta screen+1753
    lda bg+2033
    sta screen+2033
    lda bg+2073
    sta screen+2073
    lda bg+2114
    sta screen+2114
    lda bg+2154
    sta screen+2154
    lda bg+1718
    sta screen+1718
    lda bg+1758
    sta screen+1758
fx_fade_after31
// frame 32
    cpw anim_loop_step #32
    beq fx_fade_before32
    jmp fx_fade_after32
fx_fade_before32
    lda bg+94
    sta screen+94
    lda bg+134
    sta screen+134
    lda bg+179
    sta screen+179
    lda bg+219
    sta screen+219
    lda bg+1302
    sta screen+1302
    lda bg+1342
    sta screen+1342
    lda bg+743
    sta screen+743
    lda bg+783
    sta screen+783
    lda bg+1949
    sta screen+1949
    lda bg+1989
    sta screen+1989
    lda bg+990
    sta screen+990
    lda bg+1030
    sta screen+1030
    lda bg+1391
    sta screen+1391
    lda bg+1431
    sta screen+1431
    lda bg+1872
    sta screen+1872
    lda bg+1912
    sta screen+1912
    lda bg+1553
    sta screen+1553
    lda bg+1593
    sta screen+1593
    lda bg+2116
    sta screen+2116
    lda bg+2156
    sta screen+2156
    lda bg+1557
    sta screen+1557
    lda bg+1597
    sta screen+1597
    lda bg+1637
    sta screen+1637
    lda bg+1677
    sta screen+1677
    lda bg+1558
    sta screen+1558
    lda bg+1598
    sta screen+1598
    lda bg+2119
    sta screen+2119
    lda bg+2159
    sta screen+2159
fx_fade_after32
// frame 33
    cpw anim_loop_step #33
    beq fx_fade_before33
    jmp fx_fade_after33
fx_fade_before33
    lda bg+96
    sta screen+96
    lda bg+136
    sta screen+136
    lda bg+1140
    sta screen+1140
    lda bg+1180
    sta screen+1180
    lda bg+1061
    sta screen+1061
    lda bg+1101
    sta screen+1101
    lda bg+344
    sta screen+344
    lda bg+384
    sta screen+384
    lda bg+1467
    sta screen+1467
    lda bg+1507
    sta screen+1507
    lda bg+1787
    sta screen+1787
    lda bg+1827
    sta screen+1827
    lda bg+1789
    sta screen+1789
    lda bg+1829
    sta screen+1829
fx_fade_after33
// frame 34
    cpw anim_loop_step #34
    beq fx_fade_before34
    jmp fx_fade_after34
fx_fade_before34
    lda bg+12
    sta screen+12
    lda bg+52
    sta screen+52
    lda bg+93
    sta screen+93
    lda bg+133
    sta screen+133
    lda bg+415
    sta screen+415
    lda bg+455
    sta screen+455
    lda bg+98
    sta screen+98
    lda bg+138
    sta screen+138
    lda bg+1300
    sta screen+1300
    lda bg+1340
    sta screen+1340
    lda bg+822
    sta screen+822
    lda bg+862
    sta screen+862
    lda bg+264
    sta screen+264
    lda bg+304
    sta screen+304
    lda bg+1386
    sta screen+1386
    lda bg+1426
    sta screen+1426
    lda bg+1708
    sta screen+1708
    lda bg+1748
    sta screen+1748
    lda bg+2028
    sta screen+2028
    lda bg+2068
    sta screen+2068
    lda bg+1469
    sta screen+1469
    lda bg+1509
    sta screen+1509
    lda bg+911
    sta screen+911
    lda bg+951
    sta screen+951
    lda bg+991
    sta screen+991
    lda bg+1031
    sta screen+1031
    lda bg+1952
    sta screen+1952
    lda bg+1992
    sta screen+1992
    lda bg+1633
    sta screen+1633
    lda bg+1673
    sta screen+1673
    lda bg+1638
    sta screen+1638
    lda bg+1678
    sta screen+1678
    lda bg+2118
    sta screen+2118
    lda bg+2158
    sta screen+2158
fx_fade_after34
// frame 35
    cpw anim_loop_step #35
    beq fx_fade_before35
    jmp fx_fade_after35
fx_fade_before35
    lda bg+576
    sta screen+576
    lda bg+616
    sta screen+616
    lda bg+1223
    sta screen+1223
    lda bg+1263
    sta screen+1263
    lda bg+1145
    sta screen+1145
    lda bg+1185
    sta screen+1185
    lda bg+1870
    sta screen+1870
    lda bg+1910
    sta screen+1910
    lda bg+2195
    sta screen+2195
    lda bg+2235
    sta screen+2235
    lda bg+2117
    sta screen+2117
    lda bg+2157
    sta screen+2157
fx_fade_after35
// frame 36
    cpw anim_loop_step #36
    beq fx_fade_before36
    jmp fx_fade_after36
fx_fade_before36
    lda bg+1381
    sta screen+1381
    lda bg+1421
    sta screen+1421
    lda bg+1062
    sta screen+1062
    lda bg+1102
    sta screen+1102
    lda bg+1472
    sta screen+1472
    lda bg+1512
    sta screen+1512
    lda bg+1792
    sta screen+1792
    lda bg+1832
    sta screen+1832
    lda bg+2199
    sta screen+2199
    lda bg+2239
    sta screen+2239
fx_fade_after36
// frame 37
    cpw anim_loop_step #37
    beq fx_fade_before37
    jmp fx_fade_after37
fx_fade_before37
    lda bg+175
    sta screen+175
    lda bg+215
    sta screen+215
    lda bg+97
    sta screen+97
    lda bg+137
    sta screen+137
    lda bg+259
    sta screen+259
    lda bg+299
    sta screen+299
    lda bg+901
    sta screen+901
    lda bg+941
    sta screen+941
    lda bg+981
    sta screen+981
    lda bg+1021
    sta screen+1021
    lda bg+1143
    sta screen+1143
    lda bg+1183
    sta screen+1183
    lda bg+1548
    sta screen+1548
    lda bg+1588
    sta screen+1588
    lda bg+1950
    sta screen+1950
    lda bg+1990
    sta screen+1990
    lda bg+2194
    sta screen+2194
    lda bg+2234
    sta screen+2234
    lda bg+2355
    sta screen+2355
    lda bg+2395
    sta screen+2395
fx_fade_after37
// frame 38
    cpw anim_loop_step #38
    beq fx_fade_before38
    jmp fx_fade_after38
fx_fade_before38
    lda bg+174
    sta screen+174
    lda bg+214
    sta screen+214
    lda bg+1060
    sta screen+1060
    lda bg+1100
    sta screen+1100
    lda bg+1707
    sta screen+1707
    lda bg+1747
    sta screen+1747
    lda bg+2027
    sta screen+2027
    lda bg+2067
    sta screen+2067
    lda bg+1628
    sta screen+1628
    lda bg+1668
    sta screen+1668
    lda bg+1709
    sta screen+1709
    lda bg+1749
    sta screen+1749
    lda bg+2029
    sta screen+2029
    lda bg+2069
    sta screen+2069
    lda bg+1871
    sta screen+1871
    lda bg+1911
    sta screen+1911
    lda bg+1951
    sta screen+1951
    lda bg+1991
    sta screen+1991
    lda bg+2275
    sta screen+2275
    lda bg+2315
    sta screen+2315
    lda bg+2279
    sta screen+2279
    lda bg+2319
    sta screen+2319
    lda bg+2359
    sta screen+2359
    lda bg+2399
    sta screen+2399
fx_fade_after38
// frame 39
    cpw anim_loop_step #39
    beq fx_fade_before39
    jmp fx_fade_after39
fx_fade_before39
    lda bg+656
    sta screen+656
    lda bg+696
    sta screen+696
    lda bg+2198
    sta screen+2198
    lda bg+2238
    sta screen+2238
fx_fade_after39
// frame 40
    cpw anim_loop_step #40
    beq fx_fade_before40
    jmp fx_fade_after40
fx_fade_before40
    lda bg+8
    sta screen+8
    lda bg+48
    sta screen+48
    lda bg+9
    sta screen+9
    lda bg+49
    sta screen+49
    lda bg+255
    sta screen+255
    lda bg+295
    sta screen+295
    lda bg+902
    sta screen+902
    lda bg+942
    sta screen+942
    lda bg+1382
    sta screen+1382
    lda bg+1422
    sta screen+1422
    lda bg+1866
    sta screen+1866
    lda bg+1906
    sta screen+1906
    lda bg+1547
    sta screen+1547
    lda bg+1587
    sta screen+1587
    lda bg+1549
    sta screen+1549
    lda bg+1589
    sta screen+1589
    lda bg+1470
    sta screen+1470
    lda bg+1510
    sta screen+1510
    lda bg+1790
    sta screen+1790
    lda bg+1830
    sta screen+1830
    lda bg+2032
    sta screen+2032
    lda bg+2072
    sta screen+2072
    lda bg+2113
    sta screen+2113
    lda bg+2153
    sta screen+2153
    lda bg+2354
    sta screen+2354
    lda bg+2394
    sta screen+2394
    lda bg+2196
    sta screen+2196
    lda bg+2236
    sta screen+2236
fx_fade_after40
// frame 41
    cpw anim_loop_step #41
    beq fx_fade_before41
    jmp fx_fade_after41
fx_fade_before41
    lda bg+92
    sta screen+92
    lda bg+132
    sta screen+132
    lda bg+173
    sta screen+173
    lda bg+213
    sta screen+213
    lda bg+254
    sta screen+254
    lda bg+294
    sta screen+294
    lda bg+1219
    sta screen+1219
    lda bg+1259
    sta screen+1259
    lda bg+1380
    sta screen+1380
    lda bg+1420
    sta screen+1420
    lda bg+982
    sta screen+982
    lda bg+1022
    sta screen+1022
    lda bg+1144
    sta screen+1144
    lda bg+1184
    sta screen+1184
    lda bg+1946
    sta screen+1946
    lda bg+1986
    sta screen+1986
    lda bg+1627
    sta screen+1627
    lda bg+1667
    sta screen+1667
    lda bg+2274
    sta screen+2274
    lda bg+2314
    sta screen+2314
    lda bg+2278
    sta screen+2278
    lda bg+2318
    sta screen+2318
    lda bg+2358
    sta screen+2358
    lda bg+2398
    sta screen+2398
fx_fade_after41
// frame 42
    cpw anim_loop_step #42
    beq fx_fade_before42
    jmp fx_fade_after42
fx_fade_before42
    lda bg+7
    sta screen+7
    lda bg+47
    sta screen+47
    lda bg+11
    sta screen+11
    lda bg+51
    sta screen+51
    lda bg+176
    sta screen+176
    lda bg+216
    sta screen+216
    lda bg+178
    sta screen+178
    lda bg+218
    sta screen+218
    lda bg+900
    sta screen+900
    lda bg+940
    sta screen+940
    lda bg+980
    sta screen+980
    lda bg+1020
    sta screen+1020
    lda bg+1629
    sta screen+1629
    lda bg+1669
    sta screen+1669
    lda bg+1471
    sta screen+1471
    lda bg+1511
    sta screen+1511
    lda bg+1791
    sta screen+1791
    lda bg+1831
    sta screen+1831
    lda bg+1712
    sta screen+1712
    lda bg+1752
    sta screen+1752
    lda bg+2276
    sta screen+2276
    lda bg+2316
    sta screen+2316
    lda bg+2356
    sta screen+2356
    lda bg+2396
    sta screen+2396
    lda bg+2197
    sta screen+2197
    lda bg+2237
    sta screen+2237
fx_fade_after42
// frame 43
    cpw anim_loop_step #43
    beq fx_fade_before43
    jmp fx_fade_after43
fx_fade_before43
    lda bg+1139
    sta screen+1139
    lda bg+1179
    sta screen+1179
    lda bg+1299
    sta screen+1299
    lda bg+1339
    sta screen+1339
    lda bg+1466
    sta screen+1466
    lda bg+1506
    sta screen+1506
    lda bg+1786
    sta screen+1786
    lda bg+1826
    sta screen+1826
    lda bg+2108
    sta screen+2108
    lda bg+2148
    sta screen+2148
    lda bg+2031
    sta screen+2031
    lda bg+2071
    sta screen+2071
    lda bg+1552
    sta screen+1552
    lda bg+1592
    sta screen+1592
    lda bg+2277
    sta screen+2277
    lda bg+2317
    sta screen+2317
    lda bg+2357
    sta screen+2357
    lda bg+2397
    sta screen+2397
fx_fade_after43
// frame 44
    cpw anim_loop_step #44
    beq fx_fade_before44
    jmp fx_fade_after44
fx_fade_before44
    lda bg+6
    sta screen+6
    lda bg+46
    sta screen+46
    lda bg+10
    sta screen+10
    lda bg+50
    sta screen+50
    lda bg+2030
    sta screen+2030
    lda bg+2070
    sta screen+2070
fx_fade_after44
// frame 45
    cpw anim_loop_step #45
    beq fx_fade_before45
    jmp fx_fade_after45
fx_fade_before45
    lda bg+253
    sta screen+253
    lda bg+293
    sta screen+293
    lda bg+1134
    sta screen+1134
    lda bg+1174
    sta screen+1174
    lda bg+1710
    sta screen+1710
    lda bg+1750
    sta screen+1750
    lda bg+1632
    sta screen+1632
    lda bg+1672
    sta screen+1672
fx_fade_after45
// frame 46
    cpw anim_loop_step #46
    beq fx_fade_before46
    jmp fx_fade_after46
fx_fade_before46
    lda bg+177
    sta screen+177
    lda bg+217
    sta screen+217
fx_fade_after46
// frame 47
    cpw anim_loop_step #47
    beq fx_fade_before47
    jmp fx_fade_after47
fx_fade_before47
    lda bg+88
    sta screen+88
    lda bg+128
    sta screen+128
    lda bg+1135
    sta screen+1135
    lda bg+1175
    sta screen+1175
    lda bg+256
    sta screen+256
    lda bg+296
    sta screen+296
    lda bg+258
    sta screen+258
    lda bg+298
    sta screen+298
    lda bg+1942
    sta screen+1942
    lda bg+1982
    sta screen+1982
    lda bg+2107
    sta screen+2107
    lda bg+2147
    sta screen+2147
    lda bg+2109
    sta screen+2109
    lda bg+2149
    sta screen+2149
    lda bg+1550
    sta screen+1550
    lda bg+1590
    sta screen+1590
    lda bg+1711
    sta screen+1711
    lda bg+1751
    sta screen+1751
    lda bg+2193
    sta screen+2193
    lda bg+2233
    sta screen+2233
fx_fade_after47
// frame 48
    cpw anim_loop_step #48
    beq fx_fade_before48
    jmp fx_fade_after48
fx_fade_before48
    lda bg+89
    sta screen+89
    lda bg+129
    sta screen+129
    lda bg+1462
    sta screen+1462
    lda bg+1502
    sta screen+1502
    lda bg+1706
    sta screen+1706
    lda bg+1746
    sta screen+1746
    lda bg+2026
    sta screen+2026
    lda bg+2066
    sta screen+2066
    lda bg+1630
    sta screen+1630
    lda bg+1670
    sta screen+1670
    lda bg+2112
    sta screen+2112
    lda bg+2152
    sta screen+2152
fx_fade_after48
// frame 49
    cpw anim_loop_step #49
    beq fx_fade_before49
    jmp fx_fade_after49
fx_fade_before49
    lda bg+87
    sta screen+87
    lda bg+127
    sta screen+127
    lda bg+172
    sta screen+172
    lda bg+212
    sta screen+212
    lda bg+1059
    sta screen+1059
    lda bg+1099
    sta screen+1099
    lda bg+1551
    sta screen+1551
    lda bg+1591
    sta screen+1591
    lda bg+2273
    sta screen+2273
    lda bg+2313
    sta screen+2313
    lda bg+2353
    sta screen+2353
    lda bg+2393
    sta screen+2393
fx_fade_after49
// frame 50
    cpw anim_loop_step #50
    beq fx_fade_before50
    jmp fx_fade_after50
fx_fade_before50
    lda bg+257
    sta screen+257
    lda bg+297
    sta screen+297
    lda bg+1546
    sta screen+1546
    lda bg+1586
    sta screen+1586
    lda bg+1631
    sta screen+1631
    lda bg+1671
    sta screen+1671
fx_fade_after50
// frame 51
    cpw anim_loop_step #51
    beq fx_fade_before51
    jmp fx_fade_after51
fx_fade_before51
    lda bg+5
    sta screen+5
    lda bg+45
    sta screen+45
    lda bg+1133
    sta screen+1133
    lda bg+1173
    sta screen+1173
fx_fade_after51
// frame 52
    cpw anim_loop_step #52
    beq fx_fade_before52
    jmp fx_fade_after52
fx_fade_before52
    lda bg+86
    sta screen+86
    lda bg+126
    sta screen+126
    lda bg+91
    sta screen+91
    lda bg+131
    sta screen+131
    lda bg+737
    sta screen+737
    lda bg+777
    sta screen+777
    lda bg+1218
    sta screen+1218
    lda bg+1258
    sta screen+1258
    lda bg+2021
    sta screen+2021
    lda bg+2061
    sta screen+2061
    lda bg+1863
    sta screen+1863
    lda bg+1903
    sta screen+1903
    lda bg+2188
    sta screen+2188
    lda bg+2228
    sta screen+2228
    lda bg+2111
    sta screen+2111
    lda bg+2151
    sta screen+2151
fx_fade_after52
// frame 53
    cpw anim_loop_step #53
    beq fx_fade_before53
    jmp fx_fade_after53
fx_fade_before53
    lda bg+899
    sta screen+899
    lda bg+939
    sta screen+939
    lda bg+1379
    sta screen+1379
    lda bg+1419
    sta screen+1419
    lda bg+1945
    sta screen+1945
    lda bg+1985
    sta screen+1985
    lda bg+1626
    sta screen+1626
    lda bg+1666
    sta screen+1666
    lda bg+2110
    sta screen+2110
    lda bg+2150
    sta screen+2150
fx_fade_after53
// frame 54
    cpw anim_loop_step #54
    beq fx_fade_before54
    jmp fx_fade_after54
fx_fade_before54
    lda bg+168
    sta screen+168
    lda bg+208
    sta screen+208
    lda bg+90
    sta screen+90
    lda bg+130
    sta screen+130
    lda bg+1136
    sta screen+1136
    lda bg+1176
    sta screen+1176
    lda bg+1138
    sta screen+1138
    lda bg+1178
    sta screen+1178
    lda bg+979
    sta screen+979
    lda bg+1019
    sta screen+1019
    lda bg+1943
    sta screen+1943
    lda bg+1983
    sta screen+1983
    lda bg+1785
    sta screen+1785
    lda bg+1825
    sta screen+1825
    lda bg+2192
    sta screen+2192
    lda bg+2232
    sta screen+2232
fx_fade_after54
// frame 55
    cpw anim_loop_step #55
    beq fx_fade_before55
    jmp fx_fade_after55
fx_fade_before55
    lda bg+1298
    sta screen+1298
    lda bg+1338
    sta screen+1338
    lda bg+2022
    sta screen+2022
    lda bg+2062
    sta screen+2062
    lda bg+2348
    sta screen+2348
    lda bg+2388
    sta screen+2388
fx_fade_after55
// frame 56
    cpw anim_loop_step #56
    beq fx_fade_before56
    jmp fx_fade_after56
fx_fade_before56
    lda bg+252
    sta screen+252
    lda bg+292
    sta screen+292
    lda bg+1864
    sta screen+1864
    lda bg+1904
    sta screen+1904
    lda bg+2268
    sta screen+2268
    lda bg+2308
    sta screen+2308
fx_fade_after56
// frame 57
    cpw anim_loop_step #57
    beq fx_fade_before57
    jmp fx_fade_after57
fx_fade_before57
    lda bg+167
    sta screen+167
    lda bg+207
    sta screen+207
    lda bg+1217
    sta screen+1217
    lda bg+1257
    sta screen+1257
    lda bg+1944
    sta screen+1944
    lda bg+1984
    sta screen+1984
    lda bg+2187
    sta screen+2187
    lda bg+2227
    sta screen+2227
    lda bg+2189
    sta screen+2189
    lda bg+2229
    sta screen+2229
    lda bg+2272
    sta screen+2272
    lda bg+2312
    sta screen+2312
    lda bg+2352
    sta screen+2352
    lda bg+2392
    sta screen+2392
fx_fade_after57
// frame 58
    cpw anim_loop_step #58
    beq fx_fade_before58
    jmp fx_fade_after58
fx_fade_before58
    lda bg+1542
    sta screen+1542
    lda bg+1582
    sta screen+1582
    lda bg+2191
    sta screen+2191
    lda bg+2231
    sta screen+2231
fx_fade_after58
// frame 59
    cpw anim_loop_step #59
    beq fx_fade_before59
    jmp fx_fade_after59
fx_fade_before59
    lda bg+1
    sta screen+1
    lda bg+41
    sta screen+41
    lda bg+2
    sta screen+2
    lda bg+42
    sta screen+42
    lda bg+248
    sta screen+248
    lda bg+288
    sta screen+288
    lda bg+169
    sta screen+169
    lda bg+209
    sta screen+209
    lda bg+818
    sta screen+818
    lda bg+858
    sta screen+858
    lda bg+2351
    sta screen+2351
    lda bg+2391
    sta screen+2391
fx_fade_after59
// frame 60
    cpw anim_loop_step #60
    beq fx_fade_before60
    jmp fx_fade_after60
fx_fade_before60
    lda bg+166
    sta screen+166
    lda bg+206
    sta screen+206
    lda bg+247
    sta screen+247
    lda bg+287
    sta screen+287
    lda bg+1137
    sta screen+1137
    lda bg+1177
    sta screen+1177
    lda bg+1297
    sta screen+1297
    lda bg+1337
    sta screen+1337
    lda bg+1784
    sta screen+1784
    lda bg+1824
    sta screen+1824
    lda bg+2025
    sta screen+2025
    lda bg+2065
    sta screen+2065
    lda bg+2106
    sta screen+2106
    lda bg+2146
    sta screen+2146
    lda bg+2267
    sta screen+2267
    lda bg+2307
    sta screen+2307
    lda bg+2347
    sta screen+2347
    lda bg+2387
    sta screen+2387
    lda bg+2269
    sta screen+2269
    lda bg+2309
    sta screen+2309
    lda bg+2349
    sta screen+2349
    lda bg+2389
    sta screen+2389
    lda bg+2190
    sta screen+2190
    lda bg+2230
    sta screen+2230
    lda bg+2271
    sta screen+2271
    lda bg+2311
    sta screen+2311
fx_fade_after60
// frame 61
    cpw anim_loop_step #61
    beq fx_fade_before61
    jmp fx_fade_after61
fx_fade_before61
    lda bg+4
    sta screen+4
    lda bg+44
    sta screen+44
    lda bg+85
    sta screen+85
    lda bg+125
    sta screen+125
    lda bg+1058
    sta screen+1058
    lda bg+1098
    sta screen+1098
    lda bg+1705
    sta screen+1705
    lda bg+1745
    sta screen+1745
fx_fade_after61
// frame 62
    cpw anim_loop_step #62
    beq fx_fade_before62
    jmp fx_fade_after62
fx_fade_before62
    lda bg+0
    sta screen+0
    lda bg+40
    sta screen+40
    lda bg+171
    sta screen+171
    lda bg+211
    sta screen+211
    lda bg+2270
    sta screen+2270
    lda bg+2310
    sta screen+2310
    lda bg+2350
    sta screen+2350
    lda bg+2390
    sta screen+2390
fx_fade_after62
// frame 63
    cpw anim_loop_step #63
    beq fx_fade_before63
    jmp fx_fade_after63
fx_fade_before63
    lda bg+3
    sta screen+3
    lda bg+43
    sta screen+43
    lda bg+1855
    sta screen+1855
    lda bg+1895
    sta screen+1895
    lda bg+817
    sta screen+817
    lda bg+857
    sta screen+857
    lda bg+2101
    sta screen+2101
    lda bg+2141
    sta screen+2141
    lda bg+1703
    sta screen+1703
    lda bg+1743
    sta screen+1743
    lda bg+2023
    sta screen+2023
    lda bg+2063
    sta screen+2063
    lda bg+2024
    sta screen+2024
    lda bg+2064
    sta screen+2064
fx_fade_after63
// frame 64
    cpw anim_loop_step #64
    beq fx_fade_before64
    jmp fx_fade_after64
fx_fade_before64
    lda bg+249
    sta screen+249
    lda bg+289
    sta screen+289
    lda bg+1132
    sta screen+1132
    lda bg+1172
    sta screen+1172
    lda bg+1378
    sta screen+1378
    lda bg+1418
    sta screen+1418
    lda bg+1545
    sta screen+1545
    lda bg+1585
    sta screen+1585
fx_fade_after64
// frame 65
    cpw anim_loop_step #65
    beq fx_fade_before65
    jmp fx_fade_after65
fx_fade_before65
    lda bg+246
    sta screen+246
    lda bg+286
    sta screen+286
    lda bg+170
    sta screen+170
    lda bg+210
    sta screen+210
    lda bg+1057
    sta screen+1057
    lda bg+1097
    sta screen+1097
fx_fade_after65
// frame 66
    cpw anim_loop_step #66
    beq fx_fade_before66
    jmp fx_fade_after66
fx_fade_before66
    lda bg+81
    sta screen+81
    lda bg+121
    sta screen+121
    lda bg+1128
    sta screen+1128
    lda bg+1168
    sta screen+1168
    lda bg+898
    sta screen+898
    lda bg+938
    sta screen+938
    lda bg+978
    sta screen+978
    lda bg+1018
    sta screen+1018
    lda bg+1543
    sta screen+1543
    lda bg+1583
    sta screen+1583
    lda bg+1625
    sta screen+1625
    lda bg+1665
    sta screen+1665
fx_fade_after66
// frame 67
    cpw anim_loop_step #67
    beq fx_fade_before67
    jmp fx_fade_after67
fx_fade_before67
    lda bg+80
    sta screen+80
    lda bg+120
    sta screen+120
    lda bg+82
    sta screen+82
    lda bg+122
    sta screen+122
    lda bg+251
    sta screen+251
    lda bg+291
    sta screen+291
    lda bg+1775
    sta screen+1775
    lda bg+1815
    sta screen+1815
    lda bg+2102
    sta screen+2102
    lda bg+2142
    sta screen+2142
    lda bg+1623
    sta screen+1623
    lda bg+1663
    sta screen+1663
    lda bg+1704
    sta screen+1704
    lda bg+1744
    sta screen+1744
fx_fade_after67
// frame 68
    cpw anim_loop_step #68
    beq fx_fade_before68
    jmp fx_fade_after68
fx_fade_before68
    lda bg+160
    sta screen+160
    lda bg+200
    sta screen+200
    lda bg+240
    sta screen+240
    lda bg+280
    sta screen+280
    lda bg+320
    sta screen+320
    lda bg+360
    sta screen+360
    lda bg+161
    sta screen+161
    lda bg+201
    sta screen+201
    lda bg+2100
    sta screen+2100
    lda bg+2140
    sta screen+2140
    lda bg+2105
    sta screen+2105
    lda bg+2145
    sta screen+2145
    lda bg+2186
    sta screen+2186
    lda bg+2226
    sta screen+2226
fx_fade_after68
// frame 69
    cpw anim_loop_step #69
    beq fx_fade_before69
    jmp fx_fade_after69
fx_fade_before69
    lda bg+241
    sta screen+241
    lda bg+281
    sta screen+281
    lda bg+321
    sta screen+321
    lda bg+361
    sta screen+361
    lda bg+250
    sta screen+250
    lda bg+290
    sta screen+290
fx_fade_after69
// frame 70
    cpw anim_loop_step #70
    beq fx_fade_before70
    jmp fx_fade_after70
fx_fade_before70
    lda bg+84
    sta screen+84
    lda bg+124
    sta screen+124
    lda bg+165
    sta screen+165
    lda bg+205
    sta screen+205
    lda bg+2181
    sta screen+2181
    lda bg+2221
    sta screen+2221
    lda bg+2104
    sta screen+2104
    lda bg+2144
    sta screen+2144
    lda bg+2266
    sta screen+2266
    lda bg+2306
    sta screen+2306
    lda bg+2346
    sta screen+2346
    lda bg+2386
    sta screen+2386
fx_fade_after70
// frame 71
    cpw anim_loop_step #71
    beq fx_fade_before71
    jmp fx_fade_after71
fx_fade_before71
    lda bg+1129
    sta screen+1129
    lda bg+1169
    sta screen+1169
fx_fade_after71
// frame 72
    cpw anim_loop_step #72
    beq fx_fade_before72
    jmp fx_fade_after72
fx_fade_before72
    lda bg+83
    sta screen+83
    lda bg+123
    sta screen+123
    lda bg+2185
    sta screen+2185
    lda bg+2225
    sta screen+2225
fx_fade_after72
// frame 73
    cpw anim_loop_step #73
    beq fx_fade_before73
    jmp fx_fade_after73
fx_fade_before73
    lda bg+162
    sta screen+162
    lda bg+202
    sta screen+202
    lda bg+1131
    sta screen+1131
    lda bg+1171
    sta screen+1171
    lda bg+1458
    sta screen+1458
    lda bg+1498
    sta screen+1498
fx_fade_after73
// frame 74
    cpw anim_loop_step #74
    beq fx_fade_before74
    jmp fx_fade_after74
fx_fade_before74
    lda bg+2180
    sta screen+2180
    lda bg+2220
    sta screen+2220
    lda bg+2184
    sta screen+2184
    lda bg+2224
    sta screen+2224
    lda bg+2265
    sta screen+2265
    lda bg+2305
    sta screen+2305
    lda bg+2345
    sta screen+2345
    lda bg+2385
    sta screen+2385
fx_fade_after74
// frame 75
    cpw anim_loop_step #75
    beq fx_fade_before75
    jmp fx_fade_after75
fx_fade_before75
    lda bg+242
    sta screen+242
    lda bg+282
    sta screen+282
    lda bg+245
    sta screen+245
    lda bg+285
    sta screen+285
    lda bg+1130
    sta screen+1130
    lda bg+1170
    sta screen+1170
    lda bg+2262
    sta screen+2262
    lda bg+2302
    sta screen+2302
    lda bg+2344
    sta screen+2344
    lda bg+2384
    sta screen+2384
fx_fade_after75
// frame 76
    cpw anim_loop_step #76
    beq fx_fade_before76
    jmp fx_fade_after76
fx_fade_before76
    lda bg+322
    sta screen+322
    lda bg+362
    sta screen+362
    lda bg+1457
    sta screen+1457
    lda bg+1497
    sta screen+1497
    lda bg+2183
    sta screen+2183
    lda bg+2223
    sta screen+2223
    lda bg+2264
    sta screen+2264
    lda bg+2304
    sta screen+2304
fx_fade_after76
// frame 77
    cpw anim_loop_step #77
    beq fx_fade_before77
    jmp fx_fade_after77
fx_fade_before77
    lda bg+1696
    sta screen+1696
    lda bg+1736
    sta screen+1736
    lda bg+2260
    sta screen+2260
    lda bg+2300
    sta screen+2300
    lda bg+2343
    sta screen+2343
    lda bg+2383
    sta screen+2383
fx_fade_after77
// frame 78
    cpw anim_loop_step #78
    beq fx_fade_before78
    jmp fx_fade_after78
fx_fade_before78
    lda bg+164
    sta screen+164
    lda bg+204
    sta screen+204
    lda bg+2263
    sta screen+2263
    lda bg+2303
    sta screen+2303
fx_fade_after78
// frame 79
    cpw anim_loop_step #79
    beq fx_fade_before79
    jmp fx_fade_after79
fx_fade_before79
    lda bg+163
    sta screen+163
    lda bg+203
    sta screen+203
fx_fade_after79
// frame 80
    cpw anim_loop_step #80
    beq fx_fade_before80
    jmp fx_fade_after80
fx_fade_before80
    lda bg+1616
    sta screen+1616
    lda bg+1656
    sta screen+1656
fx_fade_after80
// frame 81
    cpw anim_loop_step #81
    beq fx_fade_before81
    jmp fx_fade_after81
fx_fade_before81
    lda bg+243
    sta screen+243
    lda bg+283
    sta screen+283
    lda bg+244
    sta screen+244
    lda bg+284
    sta screen+284
    lda bg+1537
    sta screen+1537
    lda bg+1577
    sta screen+1577
fx_fade_after81
// frame 82
    cpw anim_loop_step #82
    beq fx_fade_before82
    jmp fx_fade_after82
fx_fade_before82
    lda bg+2179
    sta screen+2179
    lda bg+2219
    sta screen+2219
fx_fade_after82
// frame 83
    cpw anim_loop_step #83
    beq fx_fade_before83
    jmp fx_fade_after83
fx_fade_before83
    lda bg+1617
    sta screen+1617
    lda bg+1657
    sta screen+1657
    lda bg+2339
    sta screen+2339
    lda bg+2379
    sta screen+2379
fx_fade_after83
// frame 84
    cpw anim_loop_step #84
    beq fx_fade_before84
    jmp fx_fade_after84
fx_fade_before84
    lda bg+2259
    sta screen+2259
    lda bg+2299
    sta screen+2299
fx_fade_after84
// frame 86
    cpw anim_loop_step #86
    beq fx_fade_before86
    jmp fx_fade_after86
fx_fade_before86
    lda bg+2258
    sta screen+2258
    lda bg+2298
    sta screen+2298
    lda bg+2338
    sta screen+2338
    lda bg+2378
    sta screen+2378
fx_fade_after86
// frame 87
    cpw anim_loop_step #87
    beq fx_fade_before87
    jmp fx_fade_after87
fx_fade_before87
    lda bg+2337
    sta screen+2337
    lda bg+2377
    sta screen+2377
fx_fade_after87
// frame 89
    cpw anim_loop_step #89
    beq fx_fade_before89
    jmp fx_fade_after89
fx_fade_before89
    lda bg+2336
    sta screen+2336
    lda bg+2376
    sta screen+2376
fx_fade_after89
