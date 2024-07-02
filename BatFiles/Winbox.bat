@echo off
setlocal enabledelayedexpansion

:: Specify the path to the version.txt file
echo Setting Paths
set Version_File="C:\Program Files\WinBox\Version.txt"
set Winbox_Path="C:\Program Files\WinBox\"
set Winbox_File="C:\Program Files\WinBox\Winbox64.exe"

set Winbox_On_Server="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Software\Winbox\%WINBOX_VERSION%\Winbox64.exe"

if exist %Version_File% ( set /p Current_Version=<%Version_File% ) else ( set Current_Version=0.0.0 )
if exist %Winbox_Path% ( echo Winbox Folder Exist ) else ( mkdir %Winbox_Path% )

:compare
echo Comparing Versions
echo Winbox Required  : %WINBOX_VERSION%
echo Winbox Installed : %Current_Version%
for /f "delims=" %%i in ('#CompareVersion %Current_Version% %WINBOX_VERSION%') do set Install_Condition=%%i
    goto continue

:continue
echo Instal Condition  : %Install_Condition%
if %Install_Condition%==True (echo Winbox is already installed with the required version or above.) else (
    echo No Winbox Detected or Winbox is out of date.
    echo Installing Winbox...
    copy %Winbox_On_Server% %Winbox_File% /Y
    echo %WINBOX_VERSION% > %Version_File%
)

echo AnyDesk Exe       : %Winbox_File%
echo Server Path       : %Winbox_On_Server%

endlocal