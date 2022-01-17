echo off
cls

set productName=VM SetupTool 2020
set productVers=1.8
set productAuth=Leo Takacs
set mainstring=%productName% %productVers% - by %productAuth%
title %mainstring%


set isVM=1

if exist "C:\Program Files (x86)\VMware\VMware Workstation\" (
set isVM=0
) else (
REM
)
if exist "C:\Program Files\VMware\VMware Workstation\" (
set isVM=0
) else (
REM
)
if exist "C:\Program Files (x86)\Oracle\VirtualBox\VirtualBox.exe" (
set isVM=0
) else (
REM
)
if exist "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe" (
set isVM=0
) else (
REM
)

if %isVM%==0 (
cls
title Host machine detected
echo You are running this on your host machine.
echo Please run this program from INSIDE your virtual machine.
echo Thanks!
echo - Leo :^)
pause>nul
exit
)

cls
net session >nul 2>&1
if not %errorlevel%==0 (
title Please run this program as an Administrator.
echo Please run this program as an Administrator.
echo Press any key to exit.
pause>nul
exit
) else (
REM
)
cls
:detectvm
set detected=0
cd "C:\Program Files"
dir /s /b /o:n /ad | findstr "VMware" > nul
if %errorlevel%==0 (
set vm=ware
set vm_full=VMware
set vm_prog=Tools
set detected=1
)
dir /s /b /o:n /ad | findstr "VirtualBox" > nul
if %errorlevel%==0 (
set vm=vbox
set vm_full=VirtualBox
set vm_prog=Guest Additions
set detected=1
)
if %detected%==0 (
cls
title Please install either VMware Tools or VirtualBox Guest Additions.
echo Please install either VMware Tools or VirtualBox Guest Additions.
echo Press any key to exit.
pause>nul
exit
)
if not exist "C:\Windows\System32\ownership" (
echo . > "C:\Windows\System32\ownership"
cls
echo Initial run detected.
echo Setting permissions. Please wait.
takeown /F "C:\Windows\System32" /A /R /D Y >nul 2>&1
ICACLS "C:\Windows\System32" /INHERITANCE:e /GRANT:r "%username%":^(F^) /T /C >nul 2>&1
) else (
REM
)
set programList="msinfo32" "msconfig" "syskey" "taskmgr" "eventvwr" "mspaint" "dxdiag" "tree.com" "ipconfig" "netstat" "notepad" "SystemProperties" "systeminfo" "appwiz"
:begin
set mainopt=mmm
cls
echo.
echo %mainstring%
echo VM Type: %vm_full% (Auto-detected)
echo.
echo.
echo I recommend you use options 5, 7, and 4 if you're unfamiliar with scam baiting and/or VM's.
echo.
echo Available options:
echo.
echo 1^) Disable Programs
echo 2^) Re-enable Programs
echo 3^) Replace programs with EXE/BAT
echo 4^) Replace programs with message dialog
echo 5^) Kill %vm_full% %vm_prog% and disable icon + hide from Program Files
echo 6^) Undo above process (restores %vm_full% %vm_prog% functionality)
echo 7^) Perform a basic setup (create dummy files, spoof hard drive usage, etc)
echo 0^) Exit
echo.
set /p mainopt=Enter an option number: 
if %mainopt%==1 goto disable
if %mainopt%==2 goto enable
if %mainopt%==3 goto replace
if %mainopt%==4 goto message
if %mainopt%==5 goto hidevmicon
if %mainopt%==6 goto undohide
if %mainopt%==7 goto basicSetup
if %mainopt%==0 exit
goto :begin
:disable
cd "C:\Windows\System32"
mkdir SysAppBackup >nul 2>&1
for %%a in (%programList%) do (
del /f /q %%a.bat  >nul 2>&1
move %%a.* %cd%\SysAppBackup\  >nul 2>&1
)
if %mainopt%==3 goto replaceAfterDisable
if %mainopt%==4 goto messageAfterDisable
echo Programs have been disabled!
pause
goto :begin
:enable
cd "C:\Windows\System32\SysAppBackup" >nul 2>&1
copy * ..\ >nul 2>&1
cd..
for %%a in (%programList%) do (
del /f /q %%a.bat  >nul 2>&1
)
echo Programs have been re-enabled!
pause
goto :begin
:replace
goto :disable
:replaceAfterDisable
cd %userprofile%\Desktop
set restart=0
echo =============== Available EXE/BAT files: ===============
dir /b *.exe *.bat
echo ====================================================
set /p exeName=Enter name of EXE/BAT to install over applications: 
if not exist %exeName% set restart=1
if %restart%==1 goto :begin
copy %exeName% "%AppData%" >nul 2>&1
echo cd "%AppData%" ^&^& start %exeName% ^&^& cls ^&^& exit > "%AppData%\launch.bat"
:replaceStage2
cd "C:\Windows\System32" >nul 2>&1

for %%a in (%programList%) do (
del /f /q %%a.bat >nul 2>&1
copy "%AppData%\launch.bat" "C:\Windows\System32\%%a.bat" >nul 2>&1
)
if %mainopt%==4 goto resume
echo EXE/BAT file has been installed!
pause
goto :begin
:message
goto :disable
:messageAfterDisable
set /p msgText=Enter message dialog text: 
echo msgbox "%msgText%" > "%AppData%\message.vbs"
echo cd "%AppData%" ^&^& start message.vbs ^&^& cls ^&^& exit > "%AppData%\launch.bat"
call :replaceStage2
:resume
echo Message has been installed!
pause
goto :begin
:hidevmicon
taskkill /IM vmtoolsd.exe /F  >nul 2>&1
taskkill /IM vmacthlp.exe /F  >nul 2>&1
taskkill /IM vboxtray.exe /F  >nul 2>&1
cd "C:\Program Files"
move VMware "Windows Feedback" >nul 2>&1
move Oracle "Windows Feedback" >nul 2>&1
cd "C:\ProgramData"
move VMware "Windows Feedback" >nul 2>&1
echo Done!
pause>nul
goto :begin
:undohide
cd "C:\Program Files"
if %vm%==ware (
set restFolder=VMware
) else (
set restFolder=Oracle
)
move "Windows Feedback" %restFolder% >nul 2>&1
move "C:\ProgramData\Windows Feedback" "C:\ProgramData\%restFolder"

echo Done!
pause>nul
goto :begin

:basicSetup




for /f "tokens=1-7 delims=:/-, " %%i in ('echo exit^|cmd /q /k"prompt $d $t"') do (
   for /f "tokens=2-4 delims=/-,() skip=1" %%a in ('echo.^|date') do (
      set %%a=%%j
      set %%b=%%k
      set %%c=%%l
   )
)
IF "%mm:~0,1%"=="0" SET mm=%mm:~1%
IF "%dd:~0,1%"=="0" SET dd=%dd:~1%
IF "%yy:~0,1%"=="20" SET yy=%yy:~2%

set oldDate=%mm%-%dd%-%yy%

date 11-16-2019

fsutil file createnew "%appdata%\file" 250000000000  >nul 2>&1
echo reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f > C:\Windows\System32\clearrun.bat

echo Downloading dummy files......
cd "%userprofile%\Desktop"
setlocal EnableDelayedExpansion
for %%l in (
"https://wallpapercave.com/wp/wp7075698.jpg"
"https://wallpapercave.com/wp/wp4855031.jpg"
"https://wvla.org/downloads/Annual_Conference_2013/craftbookletforwvla.pdf"
"https://wallpapercave.com/wp/wp6261051.jpg"
"https://wallpapercave.com/wp/wp7075471.jpg"
"https://wallpapercave.com/wp/wp5561962.jpg"
"https://s2.q4cdn.com/056532643/files/doc_financials/2019/annual/Walmart-2019-AR-Final.pdf"

) do (
set /a num1=!random! %%10 +10
set /a num2=!random! %%20 +20
set /a num3=!random! %%20 +20
time !num1!:!num2!:!num3!
curl -O -J -L %%l  >nul 2>&1
)
setlocal DisableDelayedExpansion
copy * "%userprofile%\Downloads"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideClock" /t REG_DWORD /d 1 /f
taskkill /IM explorer.exe /F
start explorer

date %oldDate%

echo Done!
pause >nul
goto :begin