@echo off

set versionFile="C:\Program Files\RealVNC\VNC Server\version.txt"
set requiredVersion=7.10

if exist %versionFile% (    
    set /p currentVersion=<%versionFile%
) else (
    set currentVersion=
)

echo Current Version  : %currentVersion%
echo Required Version : %requiredVersion%

if "%currentVersion%" neq "%requiredVersion%" (
    echo Version is not up to date. Starting file copying...
    net stop "vncserver"
    copy "%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\RealVNC\Server\Install\*" "C:\Program Files\RealVNC\VNC Server\" /Y
    "C:\Program Files\RealVNC\VNC Server\vnclicense.exe" -add "C:\Program Files\RealVNC\VNC Server\license.txt"
    net start "vncserver"
) else (
    echo Version is up to date.
)