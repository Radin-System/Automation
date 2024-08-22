:: Reqiered ENV:
::  DEPLOYMENT_SERVER
::  DEPLOYMENT_PATH
::  ANYDESK_VERSION

@echo off
setlocal

:: Path to AnyDesk executable and installer
echo Setting Paths
set AnyDesk_Path="C:\Program Files (x86)\AnyDesk"
set AnyDesk_Exe="C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
set AnyDesk_On_Server="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Software\AnyDesk\%ANYDESK_VERSION%\AnyDesk.exe"

:: Function to get the installed version of AnyDesk
echo Getting The Installed Version
for /f "delims=" %%i in ('%AnyDesk_Exe% --version') do set Installed_Version=%%i
    if "%Installed_Version%"=="" (set Installed_Version=0.0.0)
    goto compare

:compare
echo Comparing Versions
echo AnyDesk Required  : %ANYDESK_VERSION%
echo AnyDesk Installed : %Installed_Version%
for /f "delims=" %%i in ('#CompareVersion %Installed_Version% %ANYDESK_VERSION%') do set Install_Condition=%%i
    goto continue

:continue
echo Instal Condition  : %Install_Condition%
if %Install_Condition%==True (echo AnyDesk is already installed with the required version or above.) else (
    echo No AnyDesk Detected or AnyDesk is out of date.
    echo Installing AnyDesk...
    echo Closing Potential AnyDesk
    taskkill /IM anydesk.exe /F
    copy %AnyDesk_On_Server% %AnyDesk_Exe% /Y
    %AnyDesk_Exe% --install %AnyDesk_Path% --start-with-win --create-desktop-icon
    del %AnyDesk_Exe% /q
    %AnyDesk_Exe%
)

echo AnyDesk Folder    : %AnyDesk_Path%
echo AnyDesk Exe       : %AnyDesk_Exe%
echo Server Path       : %AnyDesk_On_Server%

endlocal