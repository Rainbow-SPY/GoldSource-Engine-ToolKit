@echo off
title Running - Gold Engine ToolKit Service
set title=Gold Engine ToolKit Service ver 1.2.0
if "%1" NEQ "-service" (
	exit
)
if "%1" EQU "-service" (
	goto ComputerInfo
)
:ComputerInfo // 用于收集电脑信息
@rem 检测32位或64位系统
if exist "%WinDir%\SysWOW64" (
	set "HostArchitecture=x64"
) else (
	set "HostArchitecture=x86"
)
:service
if "%2" EQU "-admin" (
	NSudo.exe -U:T -P:E "ToolKit.Application.goldengine.bat"
)
:CheckCrashReportor
choice /t 1 /d y /n>NUL
tasklist /nh |find /i "ToolKit.crashreportor.">NUL
if %errorlevel%==0 (
	taskkill /f /im "ToolKit.Application.goldengine.exe" 2>NUL
	call :crash
	exit
) else (
	goto CheckCrashReportor
)
:crash
%windir%\system32\mshta.exe vbscript:msgbox(Replace("应用程序发生异常 (ERROR_UNKNOW).\n\n   Language=%HostLanguage%\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%title% - 应用程序错误")(window.close)
