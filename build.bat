@echo off
cls

set PROJECTNAME=SLS
for /f "delims=" %%A in ('cd') do set "prjpath=%%A"
set ma=%prjpath%\bin\mads.exe
set bc=%prjpath%\bin\cmdcruncher.exe
set at=%prjpath%\bin\ATfile.exe
set sp=%prjpath%\bin\split.exe
set include=%prjpath%\include
set lib=%prjpath%\lib
set build=%prjpath%\build
set parts=%prjpath%\parts

del /q %build%\*.*
md build

call:printHeader
call:printConfig
call:compileLib
call:compileOs
call:compileLoader
call:compilePart_01
call:compilePart_02
call:compilePart_03
call:compilePart_04
call:compilePart_05
call:compilePart_06
call:compilePart_07
call:compilePart_08
call:compilePart_09
call:compilePart_10
call:compilePart_11
call:compilePart_12
call:compilePart_13
call:compilePart_14
call:compilePart_15
call:compilePart_16
call:compilePart_17
call:compilePart_18
call:compilePart_19
call:compilePart_20
call:compilePart_21
call:compilePart_22
call:compilePart_23

call:compileSLS
%build%\sls.obx
exit /b 5

:endBuild
cd %prjpath%
goto:eof

:compileLib
echo.compile LIB
echo.compile dir: %lib%
call:compile rmtplayr4 %lib%
echo.
goto:eof

:compileOs
echo.compile OS
set tp=%parts%\os
echo.compile dir: %tp%
call:compile os %tp%
call:crunch os.obx
echo.
goto:eof


:compileLoader
echo.compile LOADER
set tp=%parts%\loader
echo.compile dir: %tp%
call:compileInPlace bank_switcher %tp%
call:compile config_detecthw %tp%
call:crunch config_detecthw.obx
echo.
goto:eof


:compilePart_01
echo.compile PART 01 start screen
set tp=%parts%\01_startscr
echo.compile dir: %tp%
call:compileInPlace 01_startscr_out %tp%
call:crunchInPlace 01_startscr_out.obx
call:compile 01_startscr %tp%
call:crunch 01_startscr.obx
echo.
goto:eof

:compilePart_02
echo.compile PART trans to chess
set tp=%parts%\02_trans_to_chess
echo.compile dir: %tp%
call:compile 02_trans_to_chess %tp%
call:crunch 02_trans_to_chess.obx
echo.
goto:eof

:compilePart_03
echo.compile PART trans to chess go
set tp=%parts%\03_go_to_chess
echo.compile dir: %tp%
call:compile 03_go_to_chess %tp%
call:crunch 03_go_to_chess.obx
echo.
goto:eof

:compilePart_04
echo.compile PART 04 chess
set tp=%parts%\04_chess
echo.compile dir: %tp%
call:compileInPlace 04_go_to_xor %tp%
call:crunchInPlace 04_go_to_xor.obx
call:compile 04_chess %tp%
call:crunch 04_chess.obx
echo.
goto:eof

:compilePart_05
echo.compile PART xor
set tp=%parts%\05_xor
echo.compile dir: %tp%
call:compileInPlace 05_go_to_sinscroll %tp%
call:crunchInPlace 05_go_to_sinscroll.obx
call:compile 05_xor %tp%
call:crunch 05_xor.obx
echo.
goto:eof

:compilePart_06
echo.compile PART sin scroll
set tp=%parts%\06_sinscroll
echo.compile dir: %tp%
call:compile 06_sinscroll %tp%
call:crunch 06_sinscroll.obx
echo.
goto:eof

:compilePart_07
echo.compile PART hiphop picture
set tp=%parts%\07_hiphop
echo.compile dir: %tp%
call:compileInPlace 07_go_to_meta %tp%
call:crunchInPlace 07_go_to_meta.obx
call:compile 07_hiphop %tp%
call:crunch 07_hiphop.obx
echo.
goto:eof

:compilePart_08
echo.compile PART meta
set tp=%parts%\08_meta
echo.compile dir: %tp%
call:compileInPlace 08_go_to_worm %tp%
call:crunchInPlace 08_go_to_worm.obx
call:compile 08_meta %tp%
call:crunch 08_meta.obx
echo.
goto:eof

:compilePart_09
echo.compile PART worm
set tp=%parts%\09_worm
echo.compile dir: %tp%
call:compileInPlace 09_go_to_logos %tp%
call:crunchInPlace 09_go_to_logos.obx
call:compile 09_worm %tp%
call:crunch 09_worm.obx
echo.
goto:eof

:compilePart_10
echo.compile PART logos
set tp=%parts%\10_logos
echo.compile dir: %tp%
call:compileInPlace 10_go_to_carpet %tp%
call:crunchInPlace 10_go_to_carpet.obx
call:compile 10_logos %tp%
call:crunch 10_logos.obx
echo.
goto:eof

:compilePart_11
echo.compile PART carpet
set tp=%parts%\11_carpet
echo.compile dir: %tp%
call:compileInPlace 11_go_to_budda %tp%
call:crunchInPlace 11_go_to_budda.obx
call:compile 11_carpet %tp%
call:crunch 11_carpet.obx
echo.
goto:eof

:compilePart_12
echo.compile PART budda
set tp=%parts%\12_budda
echo.compile dir: %tp%
call:compileInPlace 12_go_to_boxpic %tp%
call:crunchInPlace 12_go_to_boxpic.obx
call:compile 12_budda %tp%
call:crunch 12_budda.obx
echo.
goto:eof

:compilePart_13
echo.compile PART boxpic
set tp=%parts%\13_boxpic
echo.compile dir: %tp%
call:compileInPlace 13_go_to_boxes %tp%
call:crunchInPlace 13_go_to_boxes.obx
call:compile 13_boxpic %tp%
call:crunch 13_boxpic.obx
echo.
goto:eof

:compilePart_14
echo.compile PART boxes
set tp=%parts%\14_boxes
echo.compile dir: %tp%
call:compileInPlace 14_go_to_twist %tp%
call:crunchInPlace 14_go_to_twist.obx
call:compile 14_boxes %tp%
call:crunch 14_boxes.obx
echo.
goto:eof

:compilePart_15
echo.compile PART twist
set tp=%parts%\15_twist
echo.compile dir: %tp%
call:compileInPlace 15_go_to_tunnel %tp%
call:crunchInPlace 15_go_to_tunnel.obx
call:compile 15_twist %tp%
call:crunch 15_twist.obx
echo.
goto:eof

:compilePart_16
echo.compile PART tunnel
set tp=%parts%\16_tunnel
echo.compile dir: %tp%
call:compile 16_go_to_trans_to_credit %tp%
call:crunch 16_go_to_trans_to_credit.obx
call:compile 16_tunnel %tp%
call:crunch 16_tunnel.obx
echo.
goto:eof

:compilePart_17
echo.compile PART anim
set tp=%parts%\17_anim
echo.compile dir: %tp%
call:compile 17_anim %tp%
call:crunch 17_anim.obx
echo.
goto:eof

:compilePart_18
echo.compile PART credits
set tp=%parts%\18_credits
echo.compile dir: %tp%
call:compileInPlace 18_go_to_vscorl_p1 %tp%
call:crunchInPlace 18_go_to_vscorl_p1.obx
call:compile 18_credits %tp%
call:crunch 18_credits.obx
echo.
goto:eof

:compilePart_19
echo.compile PART vscroll1
set tp=%parts%\19_vscroll
echo.compile dir: %tp%
call:compileInPlace 19_go_to_vscroll2 %tp%
call:crunchInPlace 19_go_to_vscroll2.obx
call:compile 19_vscroll1 %tp%
call:crunch 19_vscroll1.obx
echo.
goto:eof

:compilePart_20
echo.compile PART vscroll2
set tp=%parts%\20_vscroll2
echo.compile dir: %tp%
call:compile 20_vscroll2 %tp%
call:split 20_vscroll2.obx 30002 20_vscoll2_
call:crunch 20_vscoll2_aa
call:splitandappend 20_vscoll2_ab 30002 $30 $85 20_vscoll2_ab_a
call:crunch 20_vscoll2_ab_a0
echo.
goto:eof

:compilePart_21
echo.compile PART go_to_gretz 
set tp=%parts%\21_go_to_gretz
echo.compile dir: %tp%
call:compile 21_go_to_gretz %tp%
call:crunch 21_go_to_gretz.obx
echo.
goto:eof

:compilePart_22
echo.compile PART wavwxy
set tp=%parts%\22_wavexy
echo.compile dir: %tp%
call:compileInPlace 22_go_to_skull %tp%
call:crunchInPlace 22_go_to_skull.obx
call:compile 22_wavexy %tp%
call:split 22_wavexy.obx 30002 22_wavexy_
call:crunch 22_wavexy_aa
call:splitandappend 22_wavexy_ab 30002 $30 $85 22_wavexy_ab_a
call:crunch 22_wavexy_ab_a0
echo.
goto:eof

:compilePart_23
echo.compile PART skull 
set tp=%parts%\23_skull
echo.compile dir: %tp%
call:compile 23_skull %tp%
call:crunch 23_skull.obx
echo.
goto:eof

:compileSLS
echo.compile MAIN FILE SLS PROJECT
set tp=%prjpath%\sls
echo.compile dir: %tp%
call:compile sls %tp%
echo.
goto:eof

:compile
echo.compile file: %2\%1.asm
set t=%ma% %2\%1.asm -o:%build%\%1.obx -i:%include% -s -t
%t%
goto:eof

:compileInPlace
echo.compile file: %2\%1.asm
cd %2
set t=%ma% %1.asm -o:%1.obx -i:%include% -s -t
%t%
cd %prjpath%
goto:eof

:crunch
echo.crunch file: %1
set t=%bc% -i %build%\%1 -o %build%\%1.bc -binfile -nosafeldadr
%t%
goto:eof

:crunchInPlace
echo.crunch file: %1
set t=%bc% -i %tp%\%1 -o %tp%\%1.bc -binfile -nosafeldadr
%t%
goto:eof

:splitandappend
echo.split file: %build%\%1
set t=%at% -c sa %2 %3,%4 -i %build%\%1 -o %build%\%5
%t%
goto:eof

:split
echo.split file: %build%\%1
set t=%sp% -b %2 %build%\%1 %3
cd %build%
%t%
cd ..
goto:eof


:printHeader
echo.*****************************************
echo.***     Lamers 2019, project  %PROJECTNAME%     ***
echo.***     build script by ajcek/LMS     ***
echo.*****************************************
echo.
echo.
goto:eof

:printConfig
echo.project %PROJECTNAME% configuration set
echo. main project path = %prjpath%
echo. compiler          = %ma%
echo. cruncher          = %bc%
echo. lib path          = %lib%
echo. include path      = %include%
echo. build path        = %build%
echo. parts path        = %parts%
echo.
echo.
goto:eof  