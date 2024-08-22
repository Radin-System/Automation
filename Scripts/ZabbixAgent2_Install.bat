@ECHO OFF
sc query "Zabbix Agent 2" > NULL
IF ERRORLEVEL 1060 GOTO INSTALL
ECHO ZabbixAgent is Installed
GOTO END

:INSTALL
C:
CD "C:\Program Files\Zabbix Agent 2"
.\zabbix_agent2.exe -i
.\zabbix_agent2.exe -s
SC QUERY "Zabbix Agent 2" > NULL
IF ERRORLEVE 1060 ECHO Faild To Install Zabbix Agent

:END
DEL NULL
EXIT