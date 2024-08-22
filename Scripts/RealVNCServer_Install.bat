@echo off

echo Setting Paths
set RealVNC_Path="C:\Program Files\RealVNC\VNC Server"
set RealVNC_Exe="C:\Program Files\RealVNC\VNC Server\vncserver.exe"
set RealVNC_On_Server="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Software\RealVNC\%ANYDESK_VERSION%\Server\RealVNC.msi"
set RealVNC_Install="C:\Program Files (x86)\AnyDesk\AnyDesk(Install).exe"

:: Function to get the installed version of AnyDesk
echo Getting The Installed Version
for /f "delims=" %%i in ('%RealVNC_Exe% --version') do set Installed_Version=%%i
    if "%Installed_Version%"=="" (set Installed_Version=0.0.0)
    goto compare

echo Current Version  : %currentVersion%
echo Required Version : %requiredVersion%

if "%currentVersion%" neq "%requiredVersion%" (
    echo Version is not up to date. Starting file copying...
    net stop "vncserver"
    copy "%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\RealVNC\%REALVNC_VERSION%\Server\Files\*" "C:\Program Files\RealVNC\VNC Server\" /Y
    "C:\Program Files\RealVNC\VNC Server\vnclicense.exe" -add "C:\Program Files\RealVNC\VNC Server\license.txt"
    net start "vncserver"
) else (
    echo Version is up to date.
)