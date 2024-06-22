@echo off
setlocal

:: Compare Version File

:: Path to AnyDesk executable and installer
echo Setting Paths
set AnyDesk_Path="C:\Program Files (x86)\AnyDesk"
set AnyDesk_Exe="C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
set AnyDesk_On_Server="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Software\AnyDesk\%ANYDESK_VERSION%\AnyDesk.exe"

:: Function to get the installed version of AnyDesk
echo Getting The Installed Version
for /f "delims=" %%i in ('%AnyDesk_Exe% --version') do set Installed_Version=%%i
    goto compare

:compare
echo Comparing Versions
echo AnyDesk Required  : %ANYDESK_VERSION%
echo AnyDesk Installed : %Installed_Version%
for /f "delims=" %%i in ('#CompareVersion %ANYDESK_VERSION% %Installed_Version%') do set Install_Condition=%%i
    goto continue

:continue
echo Instal Condition  : %Install_Condition%
if %Install_Condition%==True (
    echo AnyDesk is already installed with the required version or above.
) else (
    echo No AnyDesk Detected or AnyDesk is out of date.
    echo Installing AnyDesk...
    echo ----------------------
    echo Closing Potential AnyDesk
    taskkill /IM anydesk.exe /F
    echo ----------------------
    set "%AnyDesk_Install%=C:\Program Files (x86)\AnyDesk\AnyDesk-%ANYDESK_VERSION%.exe"
    echo ----------------------
    copy %AnyDesk_On_Server% %AnyDesk_Install% /Y
    echo ----------------------
    %AnyDesk_Install% --install %AnyDesk_Path% --start-with-win --create-desktop-icon
    echo ----------------------
    del %AnyDesk_Install% /q
    echo ----------------------
    %AnyDesk_Exe%
    echo ----------------------
)

echo AnyDesk Folder    : %AnyDesk_Path%
echo AnyDesk Exe       : %AnyDesk_Exe%
echo AnyDesk Installer : %AnyDesk_Install%
echo Server Path       : %AnyDesk_On_Server%

endlocal