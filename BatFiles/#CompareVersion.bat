@echo off
setlocal enabledelayedexpansion

rem Function to compare versions
:compare_versions
set "version1=%1"
set "version2=%2"

rem Split the version numbers into components
for /f "tokens=1-3 delims=." %%a in ("%version1%") do (
    set "major1=%%a"
    set "minor1=%%b"
    set "patch1=%%c"
)
for /f "tokens=1-3 delims=." %%a in ("%version2%") do (
    set "major2=%%a"
    set "minor2=%%b"
    set "patch2=%%c"
)

rem Pad components to ensure proper numerical comparison
set "major1=000!major1!"
set "minor1=000!minor1!"
set "patch1=000!patch1!"
set "major2=000!major2!"
set "minor2=000!minor2!"
set "patch2=000!patch2!"

set "major1=!major1:~-3!"
set "minor1=!minor1:~-3!"
set "patch1=!patch1:~-3!"
set "major2=!major2:~-3!"
set "minor2=!minor2:~-3!"
set "patch2=!patch2:~-3!"

rem Concatenate components to create comparable strings
set "v1=!major1!!minor1!!patch1!"
set "v2=!major2!!minor2!!patch2!"

rem Compare versions
if "!v1!" geq "!v2!" (
    echo True
) else (
    echo False
)

exit /b

rem Example usage
:main
call :compare_versions %1 %2
endlocal
exit /b