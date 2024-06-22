@echo off
setlocal

:: Path to AnyDesk executable and installer
set ANYDESK_PATH="C:\Program Files (x86)\AnyDesk"
set ANYDESK_EXEC="C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
set ANYDESK_INST="C:\Program Files (x86)\AnyDesk\AnyDesk(Install).exe"

:: Function to get the installed version of AnyDesk
for /f "delims=" %%i in ('%ANYDESK_EXEC% --version') do set INSTALLED_VERSION=%%i
    goto required

:required
for /f "delims=" %%v in ('%ANYDESK_INST% --version') do set REQUIRED_VERSION=%%v
    goto continue

:continue
if exist %ANYDESK_EXEC% (
    if "%INSTALLED_VERSION%"=="%REQUIRED_VERSION%" (
        echo AnyDesk is already installed with the required version.
    ) else (
        echo AnyDesk version does not match the required version.
        echo Please update AnyDesk to version %REQUIRED_VERSION%.
    )
) else (
    echo AnyDesk is not installed. Installing AnyDesk...
    %ANYDESK_INST% --install %ANYDESK_PATH% --start-with-win --create-desktop-icon
)

echo AnyDesk Installed : %INSTALLED_VERSION%
echo AnyDesk Installer : %REQUIRED_VERSION%
echo AnyDesk Path   : %ANYDESK_PATH%
echo Insstaled Path : %ANYDESK_EXEC%
echo Installer Path : %ANYDESK_INST%


endlocal