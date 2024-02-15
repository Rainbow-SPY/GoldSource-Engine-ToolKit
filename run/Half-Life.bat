@echo off
FOR /F "tokens=3 delims= " %%i IN (
	'REG QUERY "HKEY_CURRENT_USER\SOFTWARE\Valve\Steam" /v SteamExe'
	) DO (
	echo %%i
	)
pause