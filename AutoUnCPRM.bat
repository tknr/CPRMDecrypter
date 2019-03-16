@echo off
if "%comspec%" == "c:\command.com" goto WIN9X
setlocal ENABLEEXTENSIONS
set BatFileTitle=CPRM解除支援バッチ ver0.37
:/ =======《ユーザー設定項目》=========================================
:/ GetKeyDrive=		･･･DVDドライブレター (A～Z 半角1文字)
:/ UserSaveFolder=	･･･保存先フォルダのフルパス指定(""で囲まないで下さい)
:/                       ※空欄時はAutoUnCPRM.batのあるフォルダ内に保存します
:/ FixSaveFolder=ON/OFF	･･･ON=保存先フォルダを常時固定にします
:/　　　　　　　　　　　 ※フォルダ自動作成機能は無効化され既存のVRO/IFO
:/			　 ファイルは上書きされます（通常はOFFを推奨）
:/ UseC2Dec=ON/OFF	･･･ON=c2decを利用, OFF=cprm2freeを利用
:/  C2Dec_R=ON/OFF	･･･c2dec -Rオプション（映像制御情報除去）
:/  C2Dec_W=ON/OFF	･･･c2dec -Wオプション（ワイド画面化）
:/  C2Dec_C=ON/OFF	･･･c2dec -Cオプション（音声制御情報除去）
:/ UseVro2Split=ON/OFF	･･･ON=vro2splitを利用, OFF=利用しない
:/  VrDelete=ON/OFF	･･･ON=vro2split後にVR_MOVIE.VRO/VR_MANGR.IFOを削除
:/  RenameRule=		･･･vro2split後の自動リネーム形式の指定(0～11)
:/  VrMpgMerge=		･･･vro2splitでmpgが細分割された場合の連結法(0～2)
:/ ====================================================================

set GetKeyDrive=Q

set UserSaveFolder=

set FixSaveFolder=OFF

set UseC2Dec=ON

 set C2Dec_R=ON
 set C2Dec_W=ON
 set C2Dec_C=OFF


set UseVro2Split=OFF

 set VrDelete=OFF
 set RenameRule=1
:/------------------------------------
:/ RenameRuleの設定値 (半角数字 0～11)
:/  0 （リネームしない）
:/  1  番号_タイトル_年月日_時分秒.mpg
:/  2  番号_タイトル_年月日_時分.mpg
:/  3  番号_タイトル_年月日.mpg
:/  4  番号_タイトル.mpg
:/  5  年月日_時分秒_番号_タイトル.mpg
:/  6  年月日_時分_番号_タイトル.mpg
:/  7  年月日_番号_タイトル.mpg
:/  8  年月日_時分秒_タイトル.mpg
:/  9  年月日_時分_タイトル.mpg
:/ 10  年月日_タイトル.mpg
:/ 11  タイトル.mpg
:/------------------------------------

 set VrMpgMerge=1
:/------------------------------------
:/ VrMpgMergeの設定値 (半角数字 0～2)
:/  0  連結しない
:/  1  連結後も元のデータを残す
:/  2  連結後に元のデータを削除
:/
:/ ※初めは 0か 1で運用されることをお勧めします
:/ 　正常動作が確認された環境でのみ 2をご利用ください
:/------------------------------------

:/ ====================================================================
:/ 利用プログラムの登録
:/ ====================================================================
if exist cprmgetkey041.exe (
 set GetKeyProgram1=cprmgetkey041.exe
) else (
 set GetKeyProgram1=cprmgetkey.exe
)

if exist cprmgetkey038.exe (
 set GetKeyProgram2=cprmgetkey038.exe
) else (
 set GetKeyProgram2=cprmgetkey.exe
)

if exist cprmgetkey037.exe (
 set GetKeyProgram3=cprmgetkey037.exe
) else (
 set GetKeyProgram3=cprmgetkey.exe
)

if exist cprmgetkey036.exe (
 set GetKeyProgram4=cprmgetkey036.exe
) else (
 set GetKeyProgram4=cprmgetkey.exe
)

if exist cprmgetkey031.exe (
 set GetKeyProgram5=cprmgetkey031.exe
) else (
 set GetKeyProgram5=cprmgetkey.exe
)

if exist cprmgetkey021.exe (
 set GetKeyProgram6=cprmgetkey021.exe
) else (
 set GetKeyProgram6=cprmgetkey.exe
)

if exist cprmgetkey022.exe (
 set GetKeyProgram7=cprmgetkey022.exe
 set GetKeyProgramRoot=cprmgetkey022.exe
) else (
 set GetKeyProgram7=cprmgetkey.exe
 set GetKeyProgramRoot=
)

if exist vro2split.exe (
 set Vro2SplitExe="%~dp0vro2split.exe"
) else (
 set Vro2SplitExe=vro2split.exe
)

if exist ren4splitmpg.exe (
 set Ren4SplitMpg="%~dp0ren4splitmpg.exe"
) else (
 set Ren4SplitMpg=ren4splitmpg.exe
)

if exist cprm2free.exe (
 set Cprm2FreeExe="%~dp0cprm2free.exe"
) else (
 set Cprm2FreeExe=cprm2free.exe
)

set SplitRenameBat=
set CPRM=

:/ =====================================================
:/ スタート
:/ =====================================================
echo %BatFileTitle%
echo.

:/ =====================================================
:/ VRファイルの存在確認とIFOファイルの解析コピー
:/ =====================================================
if not exist %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO goto ERROR1

rem バッチ分岐用ファイルの消去
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.cmd del vr_titlemerge.cmd
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp

rem IFOのコピー
if "%VrMpgMerge%" equ "" set VrMpgMerge=0
:/-似非switch文--------------------------
goto Merge_%VrMpgMerge%
:Merge_0
:Merge_０
  ifocopy -t  %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
  goto Merge_END
:Merge_1
:Merge_１
  ifocopy -j %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
  goto Merge_END
:Merge_2
:Merge_２
  ifocopy -h %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
:Merge_END

if "%errorlevel%" equ "2" (
 rem Encrypted Title Keyがない（CPRMメディアではない）
 set CPRM=OFF
 goto MAIN
)


:/ =====================================================
:/ cprmgetkeyによるContentsKey Base64の取得
:/ =====================================================

%GetKeyProgram1% %GetKeyDrive%: >key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram2% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram3% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram4% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram5% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram6% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

%GetKeyProgram7% %GetKeyDrive%: >>key.txt
find "ContentsKey Base64:" key.txt>key2.txt && goto MAIN

rem GetKeyProgramRootが設定されている場合ルートで実行を試みる（LITE-ON対策）
if "%GetKeyProgramRoot%" equ "" goto ERROR2
if "%CD%" equ "%SystemDrive%\" (
 echo プログラムやバッチファイルはルートよりも適当なフォルダーに
 echo 入れて利用することをお勧めします
 goto ERROR2
)
set CopyFlag2Root=
if not exist %SystemDrive%\%GetKeyProgramRoot% (
 copy %GetKeyProgramRoot% %SystemDrive%\ >nul
 set CopyFlag2Root=true
)
pushd %SystemDrive%\
%GetKeyProgramRoot% %GetKeyDrive%: >key3.txt
move key3.txt "%~dp0"
if exist MKB_TBL move MKB_TBL "%~dp0"
if "%CopyFlag2Root%" equ "true" del %GetKeyProgramRoot%
popd
type key3.txt >>key.txt
del key3.txt
find "ContentsKey Base64:" key.txt>key2.txt || goto ERROR2


:/ ========================================================
:/ 保存フォルダの作成
:/ ========================================================
:MAIN

set num=

rem 保存先フォルダ固定モード
if /i "%FixSaveFolder%" equ "ON" set SaveDir=%UserSaveFolder%
if /i "%FixSaveFolder%" neq "ON" goto MakeSaveDir

if "%SaveDir%" equ "" goto ERROR3
if not exist "%SaveDir%" mkdir "%SaveDir%"
echo.
echo 保存先が "%SaveDir%" に固定されています
echo 保存先にあるVR_MOVIE.VRO, VR_MANGR.IFOは上書きされます
goto MakeSaveDirEND

rem 保存先フォルダ自動作成モード
:MakeSaveDir

if exist vr_title.tmp for /f %%i in (vr_title.tmp) do set SaveDir=%%i
if not exist vr_title.tmp set SaveDir=NoTitle

if "%UserSaveFolder%" neq "" set SaveDir=%UserSaveFolder%\%SaveDir%

set /a num = 0
:LOOP
set /a num += 1
if exist "%SaveDir%_%num%" (
 goto LOOP
) else (
 mkdir "%SaveDir%_%num%"
)
set SaveDir=%SaveDir%_%num%

:MakeSaveDirEND


:/ ========================================================
:/ CPRMではないメディア
:/ ========================================================
if /i "%CPRM%" equ "OFF" (
 echo.
 echo このメディアはCPRMではないか既に解除済みです
 echo.
 echo VROファイルをHDDにコピーしています
 echo これには時間がかかりますのでしばらくお待ち下さい
 copy %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\" >nul
 echo     VR_MOVIE.VRO をコピーしました
 echo.
 move VR_MANGR.IFO "%SaveDir%\"
 goto FINAL
)


rem UseC2Dec=ONならc2decへ
if /i "%UseC2Dec%" equ "ON" goto C2DEC
:/ ========================================================
:/ 解除にcprm2freeを利用
:/ ========================================================
echo.
echo VROファイルをHDDにコピーしています
echo これには時間がかかりますのでしばらくお待ち下さい
copy %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\" >nul
echo     VR_MOVIE.VRO をコピーしました
move VR_MANGR.IFO "%SaveDir%\"
move key2.txt "%SaveDir%\"
pushd "%SaveDir%\"
echo.
echo cprm2freeでCPRMを解除します
for /f "eol=- tokens=3" %%i in (key2.txt) do %Cprm2FreeExe% %%i
echo.
del VR_MOVIE.VRO
del VR_MANGR.IFO
del key2.txt
ren free_VR_MOVIE.VRO VR_MOVIE.VRO
ren free_VR_MANGR.IFO VR_MANGR.IFO
popd
goto FINAL


:/ ========================================================
:/ 解除にc2decを利用
:/ ========================================================
:C2DEC

rem 各種オプション設定
set C2DecOpt=
set C2DecMes=
if /i "%C2Dec_R%" equ "ON" (
 set C2DecOpt=R
 set C2DecMes=＋映像制御情報除去
)
if /i "%C2Dec_W%" equ "ON" (
 set C2DecOpt=%C2DecOpt%W
 set C2DecMes=%C2DecMes%＋アスペクト16:9
)
if /i "%C2Dec_C%" equ "ON" (
 set C2DecOpt=%C2DecOpt%C
 set C2DecMes=%C2DecMes%＋音声制御情報除去
)
if "%C2DecOpt%" neq "" set C2DecOpt=-%C2DecOpt%
if "%C2DecMes%" equ "" set C2DecMes=(オプション設定なし)

echo.
echo c2decでCPRMを解除します%C2DecMes%
REM echo ※Vistaでは進行状況が表示されませんが気長にお待ち下さい
echo.

rem c2decloaderの起動
for /f "eol=- tokens=3" %%i in (key2.txt) do (
c2decloader %C2DecOpt% %%i %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\VR_MOVIE.VRO"
)

rem c2decloader終了時のerrorlevelで条件分岐
if "%errorlevel%" equ "0" goto SUCCESS

if /i "%FixSaveFolder%" neq "ON" rmdir "%SaveDir%"
del VR_MANGR.IFO
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
del key2.txt
goto END


rem c2decloaderが正常終了
:SUCCESS
move VR_MANGR.IFO "%SaveDir%\"

:/ =====================================================
:/ デコード終了
:/ =====================================================
:FINAL

if exist vr_title.tmp del vr_title.tmp
if exist key2.txt del key2.txt
echo.
if /i "%CPRM%" equ "OFF" (
 echo ファイルを "%SaveDir%" に保存しました
) else (
 echo 解除済みファイルを "%SaveDir%" に保存しました
)

if /i "%UseVro2Split%" equ "ON" (
 goto SPLIT
) else (
 if exist vr_titleA.tmp del vr_titleA.tmp
 if exist vr_title1Flag.tmp del vr_title1Flag.tmp
 if exist vr_titlemerge.tmp del vr_titlemerge.tmp
 goto END
)

:/ =========================================================
:/ vro2split＆自動ファイルリネーム
:/ =========================================================
:SPLIT

rem リネーム用ファイルを保存フォルダに移動し作業領域を変更する
if exist vr_titleA.tmp move vr_titleA.tmp "%SaveDir%\"
if exist vr_title1Flag.tmp move vr_title1Flag.tmp "%SaveDir%\"
if exist vr_titlemerge.tmp move vr_titlemerge.tmp "%SaveDir%\"
pushd "%SaveDir%\"

echo.
echo 続いてvro2split＆ファイルリネームを実行します

:/--------------------------------------
:/ vro2split実行に必要な空き容量確認
:/--------------------------------------
:CHKFREESPACE
rem vro2split実行時の安全空き容量(200MB=209715200バイト)
set SafetyMargin=209715200

dir VR_MOVIE.VRO >sizecheck1.tmp
find "バイトの空き" sizecheck1.tmp >sizecheck2.tmp || find "bytes free" sizecheck1.tmp >sizecheck2.tmp
for /f "eol=- tokens=3" %%i in (sizecheck2.tmp) do set FreeSpace=%%i
find "個のファイル" sizecheck1.tmp >sizecheck2.tmp || find "File(s)" sizecheck1.tmp >sizecheck2.tmp
for /f "eol=- tokens=3" %%i in (sizecheck2.tmp) do set VroSize=%%i
del sizecheck1.tmp
del sizecheck2.tmp
if "%FreeSpace%" equ "" set FreeSpace=不明
if "%VroSize%" equ "" set VroSize=不明
echo.
echo ディスクの空き容量　 = %FreeSpace%バイト
echo VR_MOVIE.VROのサイズ =   %VroSize%バイト

rem ,を除去して整数値化
set FreeSpace=%FreeSpace:,=%
set VroSize=%VroSize:,=%
rem 32bit(2GB未満)に収まるよう下4桁切り捨て(10kB～20TBまでOK)
set FreeSpace=%FreeSpace:~0,-4%
set VroSize=%VroSize:~0,-4%
set SafetyMargin=%SafetyMargin:~0,-4%

rem サイズ不明なら処理実行
if "%FreeSpace%" equ "" goto ExecuteSPLIT
if "%VroSize%" equ "" goto ExecuteSPLIT

rem 予測空き容量が確保されていれば実行
if exist vr_titlemerge.tmp (
 set /a AvailableSpace=%FreeSpace% - %VroSize% - %VroSize%
) else (
 set /a AvailableSpace=%FreeSpace% - %VroSize%
)

if %AvailableSpace% geq %SafetyMargin% goto ExecuteSPLIT

rem 予測空き容量が不足と予測される場合は中止
echo.
echo vro2splitを実行するための空き容量が不足しているため処理を中止します
if exist vr_titlemerge.tmp (
 echo VR_MOVIE.VROx2+200MB以上の空き容量を確保してsplitrename.batを実行してください
) else (
 echo VR_MOVIE.VRO+200MB以上の空き容量を確保してsplitrename.batを実行してください
)
:/--------------------------------------
:/ 作業継続用batファイルの生成
:/--------------------------------------
if /i "%SplitRenameBat%" equ "ON" goto END
:CreateRenameBat
> splitrename.bat echo @echo off
>>splitrename.bat echo setlocal ENABLEEXTENSIONS
>>splitrename.bat echo set Vro2SplitExe=%Vro2SplitExe%
>>splitrename.bat echo set Ren4SplitMpg=%Ren4SplitMpg%
>>splitrename.bat echo set VrDelete=%VrDelete%
>>splitrename.bat echo set RenameRule=%RenameRule%
>>splitrename.bat echo set VrMpgMerge=%VrMpgMerge%
>>splitrename.bat echo set SplitRenameBat=ON
>>splitrename.bat echo goto CHKFREESPACE
rem 保存フォルダがバッチファイルと同じなら自分自身を消さない
if "%CD%\" neq "%~dp0" (
 copy "%~f0" >nul
 type "%~nx0">>splitrename.bat
 del "%~nx0"
) else (
 type "%~nx0">>splitrename.bat
)
popd
goto END

:/--------------------------------------
:/ vro2splitの実行
:/--------------------------------------
:ExecuteSPLIT

rem クリップ(mpgデータ)が複数ならvro2splitを起動してリネームへ
if not exist vr_title1Flag.tmp (
 %Vro2SplitExe%
 goto RENAME
)
rem クリップが一つならファイル名を年月日_時分秒_cn01.mpgに変更or複製
if /i "%VrDelete%" equ "ON" (
 for /f %%i in (vr_title1Flag.tmp) do ren VR_MOVIE.VRO %%i >nul
) else (
 echo.
 echo ビデオクリップ数が１つのためVROを複製します
 echo しばらくお待ち下さい
 for /f %%i in (vr_title1Flag.tmp) do copy VR_MOVIE.VRO %%i >nul
)


:/--------------------------------------
:/ mpgの自動リネーム
:/--------------------------------------
:RENAME

if not exist vr_titlemerge.tmp goto NoMerging

echo.
echo 分割されたmpgファイルをタイトル毎に連結します
echo ファイルサイズによっては時間がかかります
echo しばらくお待ち下さい
echo.
ren vr_titlemerge.tmp vr_titlemerge.cmd
call vr_titlemerge.cmd
rem 連結失敗時
if "%errorlevel%" equ "1" (
 ren vr_titlemerge.cmd vr_titlemerge.tmp
 goto CreateRenameBat
)

:NoMerging

if not exist vr_titleA.tmp (
 echo.
 echo タイトル情報が取得できませんでした
 echo リネームは実行されません
 goto case_END
)

if "%RenameRule%" equ "" set RenameRule=0
:/-似非switch文----------------------------
goto case_%RenameRule%
:case_0
:case_０
  echo.
  echo “リネームなし”に設定されています
  goto case_END
:case_1
:case_１
  rem 番号_タイトル_年月日_時分秒.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 15 %%1 "%%2_%%3_")
  goto case_END
:case_2
:case_２
  rem 番号_タイトル_年月日_時分.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 13 %%1 "%%2_%%3_")
  goto case_END
:case_3
:case_３
  rem 番号_タイトル_年月日.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 8 %%1 "%%2_%%3_")
  goto case_END
:case_4
:case_４
  rem 番号_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 0 %%1 "%%2_%%3")
  goto case_END
:case_5
:case_５
  rem 年月日_時分秒_番号_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 15 %%1 "_%%2_%%3")
  goto case_END
:case_6
:case_６
  rem 年月日_時分_番号_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 13 %%1 "_%%2_%%3")
  goto case_END
:case_7
:case_７
  rem 年月日_番号_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 8 %%1 "_%%2_%%3")
  goto case_END
:case_8
:case_８
  rem 年月日_時分秒_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 15 %%1 "_%%3")
  goto case_END
:case_9
:case_９
  rem 年月日_時分_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 13 %%1 "_%%3")
  goto case_END
:case_10
:case_１０
  rem 年月日_タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 8 %%1 "_%%3")
  goto case_END
:case_11
:case_１１
  rem タイトル.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 0 %%1 "%%3")
:case_END
:/-----------------------------------------

if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp

if "%VrDelete%" neq "ON" goto NotDEL
echo.
echo VR_MANGR.IFO/VR_MOVIE.VROを削除します
if not exist *.mpg (
 echo.
 echo mpgファイルの作成に失敗したため削除を中止します
 goto NotDEL
)

if exist VR_MANGR.IFO del VR_MANGR.IFO
if exist VR_MOVIE.VRO del VR_MOVIE.VRO

:NotDEL
echo.
echo vro2split＆ファイルリネームが終了しました

if exist vr_titlemerge.cmd (
 echo ※タイトル毎のmpg連結機能は検証不十分です
 echo ---------------------------------
 findstr "^:タイトル" vr_titlemerge.cmd
 echo ---------------------------------
 echo 上記タイトルのmpgが正しく連結されているかご確認をお願いします
 del vr_titlemerge.cmd
)

if "%SplitRenameBat%" neq "ON" popd

goto END


:/ =====================================================
:/ Windows9x系
:/ =====================================================
:WIN9X
echo Windows 9x系ではこのバッチファイルは正常動作しません
echo.
echo 何かキーを押すと終了します
pause >nul
exit


:/ =====================================================
:/ ERROR1：VR_MOVIE.VROが見つからない
:/ =====================================================
:ERROR1
echo %GetKeyDrive% ドライブ内に VR_MOVIE.VRO が見つかりませんでした
echo ドライブレターの記述に誤りはありませんか？
echo またディスクが正しくセットされているかご確認ください
goto END


:/ =====================================================
:/ ERROR2：ContensKeyが取得できない
:/ =====================================================
:ERROR2
echo キーの取得に失敗しました
echo 対策1. 何度か実行を繰り返してください
echo 対策2. メディアを取り出し、再挿入後に再度実行してください
echo 対策3. key.txt を開いてエラー状況をチェックしてください
del key2.txt
goto END

:/ =====================================================
:/ ERROR3：保存先フォルダ固定モードでフォルダの指定がない
:/ =====================================================
:ERROR3
if exist VR_MANGR.IFO del VR_MANGR.IFO
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.cmd del vr_titlemerge.cmd
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
echo.
echo 保存先フォルダ固定モードに設定されていますが
echo UserSaveFolderが設定されていません
goto END

:/ =====================================================
:/ 終了
:/ =====================================================
:END
endlocal
echo.
echo 何かキーを押すと終了します
pause >nul
