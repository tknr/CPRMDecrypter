@echo off
if "%comspec%" == "c:\command.com" goto WIN9X
setlocal ENABLEEXTENSIONS
set BatFileTitle=CPRM�����x���o�b�` ver0.37
:/ =======�s���[�U�[�ݒ荀�ځt=========================================
:/ GetKeyDrive=		���DVD�h���C�u���^�[ (A�`Z ���p1����)
:/ UserSaveFolder=	����ۑ���t�H���_�̃t���p�X�w��(""�ň͂܂Ȃ��ŉ�����)
:/                       ���󗓎���AutoUnCPRM.bat�̂���t�H���_���ɕۑ����܂�
:/ FixSaveFolder=ON/OFF	���ON=�ۑ���t�H���_���펞�Œ�ɂ��܂�
:/�@�@�@�@�@�@�@�@�@�@�@ ���t�H���_�����쐬�@�\�͖��������������VRO/IFO
:/			�@ �t�@�C���͏㏑������܂��i�ʏ��OFF�𐄏��j
:/ UseC2Dec=ON/OFF	���ON=c2dec�𗘗p, OFF=cprm2free�𗘗p
:/  C2Dec_R=ON/OFF	���c2dec -R�I�v�V�����i�f�������񏜋��j
:/  C2Dec_W=ON/OFF	���c2dec -W�I�v�V�����i���C�h��ʉ��j
:/  C2Dec_C=ON/OFF	���c2dec -C�I�v�V�����i���������񏜋��j
:/ UseVro2Split=ON/OFF	���ON=vro2split�𗘗p, OFF=���p���Ȃ�
:/  VrDelete=ON/OFF	���ON=vro2split���VR_MOVIE.VRO/VR_MANGR.IFO���폜
:/  RenameRule=		���vro2split��̎������l�[���`���̎w��(0�`11)
:/  VrMpgMerge=		���vro2split��mpg���ו������ꂽ�ꍇ�̘A���@(0�`2)
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
:/ RenameRule�̐ݒ�l (���p���� 0�`11)
:/  0 �i���l�[�����Ȃ��j
:/  1  �ԍ�_�^�C�g��_�N����_�����b.mpg
:/  2  �ԍ�_�^�C�g��_�N����_����.mpg
:/  3  �ԍ�_�^�C�g��_�N����.mpg
:/  4  �ԍ�_�^�C�g��.mpg
:/  5  �N����_�����b_�ԍ�_�^�C�g��.mpg
:/  6  �N����_����_�ԍ�_�^�C�g��.mpg
:/  7  �N����_�ԍ�_�^�C�g��.mpg
:/  8  �N����_�����b_�^�C�g��.mpg
:/  9  �N����_����_�^�C�g��.mpg
:/ 10  �N����_�^�C�g��.mpg
:/ 11  �^�C�g��.mpg
:/------------------------------------

 set VrMpgMerge=1
:/------------------------------------
:/ VrMpgMerge�̐ݒ�l (���p���� 0�`2)
:/  0  �A�����Ȃ�
:/  1  �A��������̃f�[�^���c��
:/  2  �A����Ɍ��̃f�[�^���폜
:/
:/ �����߂� 0�� 1�ŉ^�p����邱�Ƃ������߂��܂�
:/ �@���퓮�삪�m�F���ꂽ���ł̂� 2�������p��������
:/------------------------------------

:/ ====================================================================
:/ ���p�v���O�����̓o�^
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
:/ �X�^�[�g
:/ =====================================================
echo %BatFileTitle%
echo.

:/ =====================================================
:/ VR�t�@�C���̑��݊m�F��IFO�t�@�C���̉�̓R�s�[
:/ =====================================================
if not exist %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO goto ERROR1

rem �o�b�`����p�t�@�C���̏���
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.cmd del vr_titlemerge.cmd
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp

rem IFO�̃R�s�[
if "%VrMpgMerge%" equ "" set VrMpgMerge=0
:/-����switch��--------------------------
goto Merge_%VrMpgMerge%
:Merge_0
:Merge_�O
  ifocopy -t  %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
  goto Merge_END
:Merge_1
:Merge_�P
  ifocopy -j %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
  goto Merge_END
:Merge_2
:Merge_�Q
  ifocopy -h %GetKeyDrive%:\DVD_RTAV\VR_MANGR.IFO "%~dp0VR_MANGR.IFO"
:Merge_END

if "%errorlevel%" equ "2" (
 rem Encrypted Title Key���Ȃ��iCPRM���f�B�A�ł͂Ȃ��j
 set CPRM=OFF
 goto MAIN
)


:/ =====================================================
:/ cprmgetkey�ɂ��ContentsKey Base64�̎擾
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

rem GetKeyProgramRoot���ݒ肳��Ă���ꍇ���[�g�Ŏ��s�����݂�iLITE-ON�΍�j
if "%GetKeyProgramRoot%" equ "" goto ERROR2
if "%CD%" equ "%SystemDrive%\" (
 echo �v���O������o�b�`�t�@�C���̓��[�g�����K���ȃt�H���_�[��
 echo ����ė��p���邱�Ƃ������߂��܂�
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
:/ �ۑ��t�H���_�̍쐬
:/ ========================================================
:MAIN

set num=

rem �ۑ���t�H���_�Œ胂�[�h
if /i "%FixSaveFolder%" equ "ON" set SaveDir=%UserSaveFolder%
if /i "%FixSaveFolder%" neq "ON" goto MakeSaveDir

if "%SaveDir%" equ "" goto ERROR3
if not exist "%SaveDir%" mkdir "%SaveDir%"
echo.
echo �ۑ��悪 "%SaveDir%" �ɌŒ肳��Ă��܂�
echo �ۑ���ɂ���VR_MOVIE.VRO, VR_MANGR.IFO�͏㏑������܂�
goto MakeSaveDirEND

rem �ۑ���t�H���_�����쐬���[�h
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
:/ CPRM�ł͂Ȃ����f�B�A
:/ ========================================================
if /i "%CPRM%" equ "OFF" (
 echo.
 echo ���̃��f�B�A��CPRM�ł͂Ȃ������ɉ����ς݂ł�
 echo.
 echo VRO�t�@�C����HDD�ɃR�s�[���Ă��܂�
 echo ����ɂ͎��Ԃ�������܂��̂ł��΂炭���҂�������
 copy %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\" >nul
 echo     VR_MOVIE.VRO ���R�s�[���܂���
 echo.
 move VR_MANGR.IFO "%SaveDir%\"
 goto FINAL
)


rem UseC2Dec=ON�Ȃ�c2dec��
if /i "%UseC2Dec%" equ "ON" goto C2DEC
:/ ========================================================
:/ ������cprm2free�𗘗p
:/ ========================================================
echo.
echo VRO�t�@�C����HDD�ɃR�s�[���Ă��܂�
echo ����ɂ͎��Ԃ�������܂��̂ł��΂炭���҂�������
copy %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\" >nul
echo     VR_MOVIE.VRO ���R�s�[���܂���
move VR_MANGR.IFO "%SaveDir%\"
move key2.txt "%SaveDir%\"
pushd "%SaveDir%\"
echo.
echo cprm2free��CPRM���������܂�
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
:/ ������c2dec�𗘗p
:/ ========================================================
:C2DEC

rem �e��I�v�V�����ݒ�
set C2DecOpt=
set C2DecMes=
if /i "%C2Dec_R%" equ "ON" (
 set C2DecOpt=R
 set C2DecMes=�{�f�������񏜋�
)
if /i "%C2Dec_W%" equ "ON" (
 set C2DecOpt=%C2DecOpt%W
 set C2DecMes=%C2DecMes%�{�A�X�y�N�g16:9
)
if /i "%C2Dec_C%" equ "ON" (
 set C2DecOpt=%C2DecOpt%C
 set C2DecMes=%C2DecMes%�{���������񏜋�
)
if "%C2DecOpt%" neq "" set C2DecOpt=-%C2DecOpt%
if "%C2DecMes%" equ "" set C2DecMes=(�I�v�V�����ݒ�Ȃ�)

echo.
echo c2dec��CPRM���������܂�%C2DecMes%
REM echo ��Vista�ł͐i�s�󋵂��\������܂��񂪋C���ɂ��҂�������
echo.

rem c2decloader�̋N��
for /f "eol=- tokens=3" %%i in (key2.txt) do (
c2decloader %C2DecOpt% %%i %GetKeyDrive%:\DVD_RTAV\VR_MOVIE.VRO "%SaveDir%\VR_MOVIE.VRO"
)

rem c2decloader�I������errorlevel�ŏ�������
if "%errorlevel%" equ "0" goto SUCCESS

if /i "%FixSaveFolder%" neq "ON" rmdir "%SaveDir%"
del VR_MANGR.IFO
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
del key2.txt
goto END


rem c2decloader������I��
:SUCCESS
move VR_MANGR.IFO "%SaveDir%\"

:/ =====================================================
:/ �f�R�[�h�I��
:/ =====================================================
:FINAL

if exist vr_title.tmp del vr_title.tmp
if exist key2.txt del key2.txt
echo.
if /i "%CPRM%" equ "OFF" (
 echo �t�@�C���� "%SaveDir%" �ɕۑ����܂���
) else (
 echo �����ς݃t�@�C���� "%SaveDir%" �ɕۑ����܂���
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
:/ vro2split�������t�@�C�����l�[��
:/ =========================================================
:SPLIT

rem ���l�[���p�t�@�C����ۑ��t�H���_�Ɉړ�����Ɨ̈��ύX����
if exist vr_titleA.tmp move vr_titleA.tmp "%SaveDir%\"
if exist vr_title1Flag.tmp move vr_title1Flag.tmp "%SaveDir%\"
if exist vr_titlemerge.tmp move vr_titlemerge.tmp "%SaveDir%\"
pushd "%SaveDir%\"

echo.
echo ������vro2split���t�@�C�����l�[�������s���܂�

:/--------------------------------------
:/ vro2split���s�ɕK�v�ȋ󂫗e�ʊm�F
:/--------------------------------------
:CHKFREESPACE
rem vro2split���s���̈��S�󂫗e��(200MB=209715200�o�C�g)
set SafetyMargin=209715200

dir VR_MOVIE.VRO >sizecheck1.tmp
find "�o�C�g�̋�" sizecheck1.tmp >sizecheck2.tmp || find "bytes free" sizecheck1.tmp >sizecheck2.tmp
for /f "eol=- tokens=3" %%i in (sizecheck2.tmp) do set FreeSpace=%%i
find "�̃t�@�C��" sizecheck1.tmp >sizecheck2.tmp || find "File(s)" sizecheck1.tmp >sizecheck2.tmp
for /f "eol=- tokens=3" %%i in (sizecheck2.tmp) do set VroSize=%%i
del sizecheck1.tmp
del sizecheck2.tmp
if "%FreeSpace%" equ "" set FreeSpace=�s��
if "%VroSize%" equ "" set VroSize=�s��
echo.
echo �f�B�X�N�̋󂫗e�ʁ@ = %FreeSpace%�o�C�g
echo VR_MOVIE.VRO�̃T�C�Y =   %VroSize%�o�C�g

rem ,���������Đ����l��
set FreeSpace=%FreeSpace:,=%
set VroSize=%VroSize:,=%
rem 32bit(2GB����)�Ɏ��܂�悤��4���؂�̂�(10kB�`20TB�܂�OK)
set FreeSpace=%FreeSpace:~0,-4%
set VroSize=%VroSize:~0,-4%
set SafetyMargin=%SafetyMargin:~0,-4%

rem �T�C�Y�s���Ȃ珈�����s
if "%FreeSpace%" equ "" goto ExecuteSPLIT
if "%VroSize%" equ "" goto ExecuteSPLIT

rem �\���󂫗e�ʂ��m�ۂ���Ă���Ύ��s
if exist vr_titlemerge.tmp (
 set /a AvailableSpace=%FreeSpace% - %VroSize% - %VroSize%
) else (
 set /a AvailableSpace=%FreeSpace% - %VroSize%
)

if %AvailableSpace% geq %SafetyMargin% goto ExecuteSPLIT

rem �\���󂫗e�ʂ��s���Ɨ\�������ꍇ�͒��~
echo.
echo vro2split�����s���邽�߂̋󂫗e�ʂ��s�����Ă��邽�ߏ����𒆎~���܂�
if exist vr_titlemerge.tmp (
 echo VR_MOVIE.VROx2+200MB�ȏ�̋󂫗e�ʂ��m�ۂ���splitrename.bat�����s���Ă�������
) else (
 echo VR_MOVIE.VRO+200MB�ȏ�̋󂫗e�ʂ��m�ۂ���splitrename.bat�����s���Ă�������
)
:/--------------------------------------
:/ ��ƌp���pbat�t�@�C���̐���
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
rem �ۑ��t�H���_���o�b�`�t�@�C���Ɠ����Ȃ玩�����g�������Ȃ�
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
:/ vro2split�̎��s
:/--------------------------------------
:ExecuteSPLIT

rem �N���b�v(mpg�f�[�^)�������Ȃ�vro2split���N�����ă��l�[����
if not exist vr_title1Flag.tmp (
 %Vro2SplitExe%
 goto RENAME
)
rem �N���b�v����Ȃ�t�@�C������N����_�����b_cn01.mpg�ɕύXor����
if /i "%VrDelete%" equ "ON" (
 for /f %%i in (vr_title1Flag.tmp) do ren VR_MOVIE.VRO %%i >nul
) else (
 echo.
 echo �r�f�I�N���b�v�����P�̂���VRO�𕡐����܂�
 echo ���΂炭���҂�������
 for /f %%i in (vr_title1Flag.tmp) do copy VR_MOVIE.VRO %%i >nul
)


:/--------------------------------------
:/ mpg�̎������l�[��
:/--------------------------------------
:RENAME

if not exist vr_titlemerge.tmp goto NoMerging

echo.
echo �������ꂽmpg�t�@�C�����^�C�g�����ɘA�����܂�
echo �t�@�C���T�C�Y�ɂ���Ă͎��Ԃ�������܂�
echo ���΂炭���҂�������
echo.
ren vr_titlemerge.tmp vr_titlemerge.cmd
call vr_titlemerge.cmd
rem �A�����s��
if "%errorlevel%" equ "1" (
 ren vr_titlemerge.cmd vr_titlemerge.tmp
 goto CreateRenameBat
)

:NoMerging

if not exist vr_titleA.tmp (
 echo.
 echo �^�C�g����񂪎擾�ł��܂���ł���
 echo ���l�[���͎��s����܂���
 goto case_END
)

if "%RenameRule%" equ "" set RenameRule=0
:/-����switch��----------------------------
goto case_%RenameRule%
:case_0
:case_�O
  echo.
  echo �g���l�[���Ȃ��h�ɐݒ肳��Ă��܂�
  goto case_END
:case_1
:case_�P
  rem �ԍ�_�^�C�g��_�N����_�����b.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 15 %%1 "%%2_%%3_")
  goto case_END
:case_2
:case_�Q
  rem �ԍ�_�^�C�g��_�N����_����.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 13 %%1 "%%2_%%3_")
  goto case_END
:case_3
:case_�R
  rem �ԍ�_�^�C�g��_�N����.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% -r 8 %%1 "%%2_%%3_")
  goto case_END
:case_4
:case_�S
  rem �ԍ�_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 0 %%1 "%%2_%%3")
  goto case_END
:case_5
:case_�T
  rem �N����_�����b_�ԍ�_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 15 %%1 "_%%2_%%3")
  goto case_END
:case_6
:case_�U
  rem �N����_����_�ԍ�_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 13 %%1 "_%%2_%%3")
  goto case_END
:case_7
:case_�V
  rem �N����_�ԍ�_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 8 %%1 "_%%2_%%3")
  goto case_END
:case_8
:case_�W
  rem �N����_�����b_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 15 %%1 "_%%3")
  goto case_END
:case_9
:case_�X
  rem �N����_����_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 13 %%1 "_%%3")
  goto case_END
:case_10
:case_�P�O
  rem �N����_�^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 8 %%1 "_%%3")
  goto case_END
:case_11
:case_�P�P
  rem �^�C�g��.mpg
  for /f "delims=| tokens=1,2,*" %%1 in (vr_titleA.tmp) do (
  %Ren4SplitMpg% 0 %%1 "%%3")
:case_END
:/-----------------------------------------

if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp

if "%VrDelete%" neq "ON" goto NotDEL
echo.
echo VR_MANGR.IFO/VR_MOVIE.VRO���폜���܂�
if not exist *.mpg (
 echo.
 echo mpg�t�@�C���̍쐬�Ɏ��s�������ߍ폜�𒆎~���܂�
 goto NotDEL
)

if exist VR_MANGR.IFO del VR_MANGR.IFO
if exist VR_MOVIE.VRO del VR_MOVIE.VRO

:NotDEL
echo.
echo vro2split���t�@�C�����l�[�����I�����܂���

if exist vr_titlemerge.cmd (
 echo ���^�C�g������mpg�A���@�\�͌��ؕs�\���ł�
 echo ---------------------------------
 findstr "^:�^�C�g��" vr_titlemerge.cmd
 echo ---------------------------------
 echo ��L�^�C�g����mpg���������A������Ă��邩���m�F�����肢���܂�
 del vr_titlemerge.cmd
)

if "%SplitRenameBat%" neq "ON" popd

goto END


:/ =====================================================
:/ Windows9x�n
:/ =====================================================
:WIN9X
echo Windows 9x�n�ł͂��̃o�b�`�t�@�C���͐��퓮�삵�܂���
echo.
echo �����L�[�������ƏI�����܂�
pause >nul
exit


:/ =====================================================
:/ ERROR1�FVR_MOVIE.VRO��������Ȃ�
:/ =====================================================
:ERROR1
echo %GetKeyDrive% �h���C�u���� VR_MOVIE.VRO ��������܂���ł���
echo �h���C�u���^�[�̋L�q�Ɍ��͂���܂��񂩁H
echo �܂��f�B�X�N���������Z�b�g����Ă��邩���m�F��������
goto END


:/ =====================================================
:/ ERROR2�FContensKey���擾�ł��Ȃ�
:/ =====================================================
:ERROR2
echo �L�[�̎擾�Ɏ��s���܂���
echo �΍�1. ���x�����s���J��Ԃ��Ă�������
echo �΍�2. ���f�B�A�����o���A�đ}����ɍēx���s���Ă�������
echo �΍�3. key.txt ���J���ăG���[�󋵂��`�F�b�N���Ă�������
del key2.txt
goto END

:/ =====================================================
:/ ERROR3�F�ۑ���t�H���_�Œ胂�[�h�Ńt�H���_�̎w�肪�Ȃ�
:/ =====================================================
:ERROR3
if exist VR_MANGR.IFO del VR_MANGR.IFO
if exist vr_title.tmp del vr_title.tmp
if exist vr_titleA.tmp del vr_titleA.tmp
if exist vr_title1Flag.tmp del vr_title1Flag.tmp
if exist vr_titlemerge.cmd del vr_titlemerge.cmd
if exist vr_titlemerge.tmp del vr_titlemerge.tmp
echo.
echo �ۑ���t�H���_�Œ胂�[�h�ɐݒ肳��Ă��܂���
echo UserSaveFolder���ݒ肳��Ă��܂���
goto END

:/ =====================================================
:/ �I��
:/ =====================================================
:END
endlocal
echo.
echo �����L�[�������ƏI�����܂�
pause >nul
