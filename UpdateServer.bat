@ECHO OFF

echo ##---------- Deleting Server Files ----------##
set SCRIPTS_PATH="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Static\Scripts\"
del %SCRIPTS_PATH%\* /q

echo ##---------- Copying Local Files to Server ----------##
copy "Scripts\*" %SCRIPTS_PATH% /Y

echo ##---------- Deleting Local Files ----------##
del "c:\static\Scripts\*" /q

echo ##---------- Sync with Group Policy ----------##
GPUpdate /force