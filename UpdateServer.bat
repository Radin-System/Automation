@ECHO OFF

set SCRIPTS_PATH="\\%DEPLOYMENT_SERVER%\%DEPLOYMENT_PATH%\Static\Scripts\"

copy "BatFiles\*" %SCRIPTS_PATH% /Y
del "c:\static\Scripts\*" /Y


GPUpdate /force
