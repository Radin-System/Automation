@echo off
for /f "tokens=2 delims==" %%i in ('wmic datafile where name^="C:\Program Files\WinBox\winbox64.exe" get version /value ^| find "="') do set version=%%i
echo Version of winbox.exe: %version%