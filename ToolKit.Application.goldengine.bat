@echo off
mode con cols=80 lines=25
title GE 工具箱 版本 v2.1.0
setlocal EnableDelayedExpansion
@rem 设置活动页代码
chcp 936>NUL
@rem 检测32位或64位系统
if exist "%WinDir%\SysWOW64" (
	set "HostArchitecture=x64"
) else (
	set "HostArchitecture=x86"
)
:CheckService
if not exist "ToolKit.Application.service.goldengine.bat" (
	.\crashreportor\ToolKit.crashreportor.service.goldengine_%HostArchitecture%.exe
	exit
)
:CheckAdmin
@rem 检测权限是否是TrustedInstaller
Whoami|find /i "system">NUL
if errorlevel 1 (
	for /f "tokens=3 delims= " %%i in (
		'reg query "HKEY_CURRENT_USER\SOFTWARE\Valve\Steam" /v SteamExe'
	) do (
		echo %%i>%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini
	)
	start ToolKit.Application.service.goldengine.bat -service -admin -jump-steamPath
	exit
) else (
	echo.
	cls
)
:ReadMe //最终用户许可协议
echo.===============================================================================
echo.######################## GE 工具箱  - 最终用户许可协议 #########################
echo.===============================================================================
echo.
echo. Copyright (C) Rainbow SPY Technology(2019-2024). All rights reserved.
echo.
echo.
echo. GE 工具箱仅限用于金源引擎开发的游戏
echo.
echo.
echo. 此 GE 工具箱“按开发者提供的原样”提供，并且不作任何明示或暗示性的保证。在任何
echo. 情况之下，作者均不会对因为使用此脚本配置工具而导致可能的任何破坏承担责任。此
echo. 软件不用于任何商业行为，出现任何法律问题将有使用者承担。
echo.
echo.
echo. GE 工具箱将会使用各类第三方工具来完成其中的一部分任务行为。
echo.
echo.
echo. GE 工具箱、金源引擎、Gold Engine 均为其各自公司或作者的注册商标。
echo. (C) Microsoft Corporation. All rights reserved.
echo. 7-Zip Copyright (C) 1999-2018 Igor Pavlov.
echo. Copyright (C) 2021 Valve Corporation
echo.===============================================================================
%windir%\system32\choice.exe /C:AR /N /M "########################[ 按‘A’同意 / 按‘R’拒绝 ]#########################"
if errorlevel 2 (
	color 00
	exit
)
:CheckTrustedInstaller
set srvname="TrustedInstaller" 
sc query|find %srvname% >NUL|| net start %srvname%
if errorlevel 1 (
	.\crashreportor\ToolKit.crashreportor.service.TrustedInstaller_%HostArchitecture%.exe
	exit
)
:CheckSteamPath
if exist "%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini" (
	pause
) else (
	.\crashreportor\ToolKit.crashreportor.config.steampath_%HostArchitecture%.exe
	exit
)
:ComputerInfo // 用于收集电脑信息
cls
@rem 用于检测是否为Windows 11 系统
for /f "tokens=3 delims= " %%i in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" ^| find "REG_SZ"'
) do (
	set HostBuild=%%i
)
@rem 检测操作系统内部版本
for /f "tokens=3 delims= " %%j in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f "ReleaseId" ^| find "REG_SZ"'
) do (
	set /A "HostReleaseVersion=%%j" & if "%%j" lss "2004" set HostDisplayVersion=%%j
)
if "%HostDisplayVersion%" equ "" (
	for /f "tokens=3 delims= " %%k in (
		'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" ^| find "REG_SZ"'
	) do (
		set "HostDisplayVersion=%%k"
	)
)
@rem 检测操作系统版本
for /f "tokens=3 delims= " %%l in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" ^| find "REG_SZ"'
) do (
	if %%l equ Professional (
		set "HostEdition=专业版"
	) else (
		set "HostEdition=%%l"
	)
)
@rem 检测操作系统是否为服务器版本
for /f "tokens=3 delims= " %%m in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" ^| find "REG_SZ"'
) do (
	if %%m equ Client ( 
		set "HostInstallationType=客户端"
	) else (
		set "HostInstallationType=%%m"
	)
)
for /f "tokens=7 delims=[]. " %%r in (
	'ver 2^>nul'
) do (
	set /A HostServicePackBuild=%%r
)
@rem 检测操作系统为Windows x.x
for /f "tokens=4-5 delims=[]. " %%s in (
	'ver 2^>nul'
) do (
	set "HostVersion=%%s.%%t" & set "HostOSVersion=%%s"
)
if "%HostVersion%" equ "6.1" (
	set "HostOSVersion=7 SP1"
)
if "%HostVersion%" equ "6.3" (
	set "HostOSVersion=8.1"
)
if "%HostVersion%" equ "10.0" (
	if "%HostBuild%" geq "21996" (
		set "HostOSVersion=11"
	)
)
@rem 检测操作系统语言
for /f "tokens=3 delims=\ " %%o in (
	'reg query "HKCU\Control Panel\International\User Profile" /s /v "Languages" ^| findstr /I "REG_ _SZ"'
) do (
	if %%o equ zh-Hans-CN (
		set "HostLanguage=zh-CN"
	) else (
		set "HostLanguage=%%o"
	)
)
echo.===============================================================================
echo.                                GE 工具箱 - 启动
echo.===============================================================================
echo.
echo.正在读取主机操作系统信息……
echo.
echo.Windows %HostOSVersion% %HostEdition% %HostInstallationType% %HostDisplayVersion% - v%HostVersion%.%HostBuild%.%HostServicePackBuild% %HostArchitecture% %HostLanguage%
pause
:Command //半条命、反恐精英游戏的启动项
set Command_Game=
set Command_1=
set Command_2=
set Command_3=
set Command_4=
set HlCommand_1=
set HlCommand_2=
set HlCommand_3=
set HlCommand_4=
:DownloadList // aria2c的下载链接库
set Link1=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/resource-1.1.0-Offical.7z
set Link2=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/cstrike_schinese/titles.txt
set Link3=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/cstrike_english.txt
set Link4=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/gameui_english.txt
set Link5=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/serverbrowser_english.txt
set Link6=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/valve_english.txt
:Path //定义路径
set "ver=v2.0"
set "_#APPDATA#=%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin"
set "cstike_ver=Counter-Strike-1.6-vSteam"
set "title=GE 工具箱 版本: %ver%"
set "_line=-------------------------------------"
set "_Ecode_DLL_Engine_OpenGL=False"
set "_Ecode_DLL_Engine_D3D=False"
set "_Ecode_DLL_Engine_Software=False"
:CheckRes
if not exist "%~dp0bin\aria2\aria2c.exe" (
	.\crashreportor\ToolKit.crashreportor.aria2_%HostArchitecture%.exe
	exit
) else (
	echo.
)
for /f %%i in (
	'type %LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini'
) do (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "SteamPath" /d "%%i" /F
)

:CheckFolder
if exist "%_#APPDATA#%" (
	echo.>NUL
) else (
	md "%_#APPDATA#%"
)
if exist "%_#APPDATA#%\Backup" (
    set _backup=%_#APPDATA#%\Backup
) else (
	md "%_#APPDATA#%\Backup"
)
if exist ".\Download" (
	rd /s/q ".\Download"
) else (
	md ".\Download"
)
@rem 以下代码会在下个版本启用 
@rem if exist ".\cstrike_schinese" (
@rem     echo.>NUL
@rem ) else (
@rem 	md ".\cstrike_schinese"
@rem )
@rem if exist ".\platform" (
@rem     echo.>NUL
@rem ) else ( 
@rem 	md ".\platform"
@rem )
@rem if exist ".\platform\servers" (
@rem     echo.>NUL
@rem ) else (
@rem 	md ".\platform\servers"
@rem )
:Backup
copy /y "%~f0" "%_backup%" >NUL 2>NUL
if errorlevel 1 (
	.\crashreportor\ToolKit.crashreportor.system.copy_%HostArchitecture%.exe"
	exit
)
if errorlevel 0 (
	echo.>NUL
)
ren "%_backup%\GE ToolKit.bat" "Bak_%date:~0,4%_%date:~5,2%_%date:~8,2%_%time:~0,2%_%time:~3,2%_%time:~6,2%.bat"
if not exist "%_#APPDATA#%\certificate.ini" (
	echo [certificate]>>%_#APPDATA#%\certificate.ini
	call :certificate
) else (
	echo.>NUL
)
:MainMenu
cls
echo.===============================================================================
echo.                          GE 工具箱 - 主  菜  单
echo.===============================================================================
echo.
echo.                             [1]   启动游戏
echo.
echo.                             [2]   汉化游戏
echo.
echo.                             [3]   反      馈
echo.
echo.                             [4]   自定义键位
echo.
echo.                             [5]   语音切换
echo.
echo.                             [6]   更换模型
echo.
echo.                             [7]   整合包
echo.
echo.                             [8]   更换背景
echo.
echo.                             [X]   退      出
echo.
echo.===============================================================================
choice /C:12345678X /N /M "请输入你的选项 ："
if errorlevel 9 (
	exit
)
if errorlevel 8 (
	goto :Background
)
if errorlevel 7 (
	goto :All-in-one-Pack
)
if errorlevel 6 (
	goto :ChooseModels
)
if errorlevel 5 (
	goto :ChooseSoundLanguage
)
if errorlevel 4 (
	goto :Custombind
)
if errorlevel 3 (
	goto :ReportIssues
)
if errorlevel 2 (
	goto :ChineseText
)
if errorlevel 1 (
	goto :ChooseGame
)
:ChooseGame
cls
echo.===============================================================================
echo.                          GE 工具箱 - 启动游戏
echo.===============================================================================
echo.
echo 选择您游玩的游戏......
echo.
echo.
echo.
echo 游玩Half-Life 和 Half-Life:Uplink      输入 [1]
echo.
echo.
echo.
echo.
echo.
echo 游玩Counter-Strike                     输入 [2]
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.===============================================================================
echo.
.\bin\choice /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto Half-life-config
)
if %_el%==2 (
	goto cstike-config-sv_rollangle
)
:Half-life-config
cls
echo.===============================================================================
echo.                          MSMG 工具箱 - 启动项
echo.===============================================================================
echo.
echo.您已选择了游戏：Half-Life 和 Half-Life:Uplinkl
echo.
echo.
echo.
echo.请选择您要加载的启动项......
echo.
echo.
echo.
echo.[1] 更改视角晃动参数(默认：True, 2)
echo.
echo.
echo.
echo.[2] 快速切枪(默认：False, 0)
echo.
echo.
echo.
echo.[3] 启动游戏
echo.
echo.===============================================================================
echo.
.\bin\choice /c 123 /n /m "你的选择："
if %errorlevel%==1 (
	goto Half-life-config-sv_rollangle
)
if %errorlevel%==2 (
	goto Half-Life-config-hud_fastswitch
)
if %errorlevel%==3 (
	goto RunningandEND
)
:cstike-config-sv_rollangle
echo [01] 视角晃动 ^| 当前数值：%sv_rollangle%
echo      - 0 ^| 无摆动幅度
echo      - 1 ^| 摆动幅度小
echo      - 2 ^| 摆动幅度大
set /p sv_rollangle= # 请输入你的配置数值：
if "%sv_rollangle%" equ "0" (
	set %Command_1%=sv_rollangle 0
	echo 设置 sv_rollangle=0
	goto cstike-config-hud_fastswitch
)
if "%sv_rollangle%" equ "1" (
	set %Command_1%=sv_rollangle 1
	echo 设置 sv_rollangle=1
	goto cstike-config-hud_fastswitch
)
if "%sv_rollangle%" equ "2" (
	set %Command_1%=sv_rollangle 2
	echo 设置 sv_rollangle=2
	goto cstike-config-hud_fastswitch
)
goto Half-life-config-sv_rollangle
:cstike-config-hud_fastswitch
echo [02] 快速切枪 ^| 当前数值：%hud_fastswitch%
echo      - 0 ^| 禁用 快速切枪
echo      - 1 ^| 启用 快速切枪
set /p ConfigChoice= # 请输入你的配置数值：
if "%hud_fastswitch%" equ "0" (
	set %Command_2%=hud_fastswitch 0
	echo 设置 hud_fastswitch=0
	goto 
)
if "%hud_fastswitch%" equ "1" (
	set %Command_2%=hud_fastswitch 1
	echo 设置 hud_fastswitch=1
)
goto cstike-config-hud_fastswitch
:cstike-config-cl_righthand
echo [03] 持枪视角 ^| 当前数值：%cl_righthand%
echo      - 0 ^| 左手持枪
echo      - 1 ^| 右手持枪
set /p cl_righthand= # 请输入你的配置数值：
if "%cl_righthand%" equ "0" (
	set %Command_1%=cl_righthand 0
	echo 设置 cl_righthand=0
	goto cstike-config-cl_righthand
)
if "%cl_righthand%" equ "1" (
	set %Command_1%=cl_righthand 1
	echo 设置 cl_righthand=1
	goto cstike-config-cl_righthand
)
goto cstike-config-cl_righthand
:cstike-config-bind-all
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前配置：config.cfg
echo.===============================================================================
echo [1]       前进  ^|  默认键位	[ W ]          ^|   当前键位	[%bind-config_forward%]
echo [2]       后退  ^|  默认键位	[ S ]          ^|   当前键位	[%bind-config_back%]
echo [3]       左移  ^|  默认键位	[ A ]          ^|   当前键位	[%bind-config_moveleft%]
echo [4]       右移  ^|  默认键位	[ D ]          ^|   当前键位	[%bind-config_moveright%]
echo [5]       静步  ^|  默认键位	[ LEFT SHIFT ] ^|   当前键位	[%bind-config_speed%]
echo [6]       跳跃  ^|  默认键位	[ SPACE ]      ^|   当前键位	[%bind-config_jump%]
echo [7]       蹲伏  ^|  默认键位	[ LEFT CTRL ]  ^|   当前键位	[%bind-config_duck%]
echo [8]     麦克风  ^|  默认键位	[ J ]          ^|   当前键位	[%bind-config_voicerecord%]
echo [9]   全体消息  ^|  默认键位	[ Y ]          ^|   当前键位	[%bind-config_messagemode%]
echo [0]   团队消息  ^|  默认键位	[ U ]          ^|   当前键位	[%bind-config_messagemode2%]
echo [A]   购买菜单  ^|  默认键位	[ B ]          ^|   当前键位	[%bind-config_buy%]
@rem echo 购买主武器弹药  ^|  默认键位	[ . ]          ^|   当前键位	[]
@rem echo 购买副武器弹药  ^|  默认键位	[ , ]          ^|   当前键位	[]
@rem echo   购买装备菜单  ^|  默认键位	[ O ]          ^|   当前键位	[]
echo [B]    自动购买 ^|  默认键位	[ F1 ]         ^|   当前键位	[%bind-config_autobuy%]
echo [C]    重新购买 ^|  默认键位	[ F3 ]         ^|   当前键位	[%bind-config_rebuy%]
echo [D]    选择队伍 ^|  默认键位	[ M ]          ^|   当前键位	[%bind-config_chooseteam%]
echo.===============================================================================
echo [X]    返回菜单
echo.
choice /c 1234567890ABCDX /n /m "输入代码进行编辑键位..."
set _el=%errorlevel% 
if %_el%==1 (
	goto bind_forward
)
if %_el%==2 (
	goto bind_back
)
if %_el%==3 (
	goto bind_moveleft
)
if %_el%==4 (
	goto bind_moveright
)
if %_el%==5 (
	goto bind_speed
)
if %_el%==6 (
	goto bind_jump
)
if %_el%==7 (
	goto bind_duck
)
if %_el%==8 (
	goto bind_voicerecord
)
if %_el%==9 (
	goto bind_messagemode
)
if %_el%==0 (
	goto bind_messagemode2
)
if %_el%==A (
	goto bind_buy
)
if %_el%==B (
	goto bind_autobuy
)
if %_el%==C (
	goto bind_rebuy
)
if %_el%==D (
	goto bind_chooseteam
)
if %_el%==X (
	goto 
)
:bind_forward
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_forward%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_forward= # 请输入你的配置数值：
:bind_back
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_back%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_back= # 请输入你的配置数值：
:bind_moveleft
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_moveleft%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_moveleft= # 请输入你的配置数值：
:bind_moveright
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_moveright%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_moveright= # 请输入你的配置数值：
:bind_speed
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_speed%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_speed= # 请输入你的配置数值：
:bind_jump
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_jump%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_jump= # 请输入你的配置数值：
:bind_duck
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_duck%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_duck= # 请输入你的配置数值：
:bind_voicerecord
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_voicerecord%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_voicerecord= # 请输入你的配置数值：
:bind_messagemode
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_messagemode%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_messagemode= # 请输入你的配置数值：
:bind_messagemode2
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_messagemode2%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_messagemode2= # 请输入你的配置数值：
:bind_buy
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_buy%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_buy= # 请输入你的配置数值：
:bind_autobuy
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_autobuy%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_autobuy= # 请输入你的配置数值：
:bind_rebuy
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_rebuy%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_rebuy= # 请输入你的配置数值：
:bind_chooseteam
cls
echo.===============================================================================
echo.           GE 工具箱 - 自定义键位           ^|    当前键位：[%bind-config_chooseteam%]
echo.===============================================================================
echo.
echo.
echo.
echo.请在下方输入您所要更改的键位...
echo.
echo.
echo.          =======================================================
echo.                            警           告
echo.          =======================================================
echo.注意！
echo.
echo.您所输入的字符/数字将立即生效，请务必保证无拼写错误。
echo.
echo.如有异常请在下次使用工具箱时重新选择配置键位
echo.
echo.输入完成后，单击Enter回车键发送.
echo.
echo.参考：W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_chooseteam= # 请输入你的配置数值：




















echo      开火 ^| 摆动幅度大
echo      武器第二功能 ^| 摆动幅度大
echo      换弹 ^| 摆动幅度大
echo      最后使用的武器 ^| 摆动幅度大
echo      夜视仪 ^| 摆动幅度大
echo      扔掉武器 ^| 摆动幅度大
echo      使用物品 ^| 摆动幅度大
echo      手电筒 ^| 摆动幅度大
echo      截图 ^| 摆动幅度大
set /p sv_rollangle= # 请输入你的配置数值：
:Half-life-config-sv_rollangle
echo [01] 视角晃动 ^| 当前数值：%sv_rollangle%
echo      - 0 ^| 无摆动幅度
echo      - 1 ^| 摆动幅度小
echo      - 2 ^| 摆动幅度大
set /p sv_rollangle= # 请输入你的配置数值：
if "%sv_rollangle%" equ "0" (
	set %HlCommand_1%=sv_rollangle 0
	echo 设置 sv_rollangle=0
	goto Half-life-config
)
if "%sv_rollangle%" equ "1" (
	set %HlCommand_1%=sv_rollangle 1
	echo 设置 sv_rollangle=1
	goto Half-life-config
)
if "%sv_rollangle%" equ "2" (
	set %HlCommand_1%=sv_rollangle 2
	echo 设置 sv_rollangle=2
	goto Half-life-config
)
goto Half-life-config
:Half-life-config-hud_fastswitch
echo [02] 快速切枪 ^| 当前数值：%hud_fastswitch%
echo      - 0 ^| 禁用 快速切枪
echo      - 1 ^| 启用 快速切枪
set /p ConfigChoice= # 请输入你的配置数值：
if "%hud_fastswitch%" equ "0" (
	set %HlCommand_2%=hud_fastswitch 0
	echo 设置 hud_fastswitch=0
	goto Half-Life-config
)
if "%hud_fastswitch%" equ "1" (
	set %HlCommand_2%=hud_fastswitch 1
	echo 设置 hud_fastswitch=1
	goto Half-life-config
)
goto Half-life-config-
:ChineseText
cls
set Nuber_aria2_download_compelete=1
set Nuber_aria2_download_all=5
set download_list_now=titles.txt
set download_list=%Link2%
if exist ".\Download\titles.txt" (
	set Nuber_aria2_download_compelete=2
	set download_list_now=cstrike_english.txt
	set download_list=%Link3%
)
if exist ".\Download\cstrike_english.txt" (
	set Nuber_aria2_download_compelete=3
	set download_list_now=gameui_english.txt
	set download_list=%Link4%
)
if exist ".\Download\gameui_english.txt" (
	set Nuber_aria2_download_compelete=4
	set download_list_now=serverbrowser_english.txt
	set download_list=%Link5%
)
if exist ".\Download\serverbrowser_english.txt" (
	set Nuber_aria2_download_compelete=5
	set download_list_now=valve_english.txt
	set download_list=%Link6%
)
if exist ".\Download\valve_english.txt" (
	goto ChineseTextComplete
)
echo.===============================================================================
echo.                          GE 工具箱 - 汉化游戏
echo.===============================================================================
echo.
echo 正在准备下载......
title 下载中 [%Nuber_aria2_download_compelete%/%Nuber_aria2_download_all%]...... - aria2c - %title%
echo.===============================================================================
echo                        Download[%Nuber_aria2_download_compelete%/%Nuber_aria2_download_all%] - %download_list_now%
echo.===============================================================================
.\bin\aria2\aria2c.exe %download_list% -x 16 -c -d .\Download
goto ChineseText
:ChineseTextComplete
title 
echo.===============================================================================
echo.                          GE 工具箱 - 汉化游戏
echo.===============================================================================
echo.
echo 正在汉化游戏.....
copy /y 
echo.汉化完成！
:aria2c-menu-cstike
cls
echo.
echo.
echo.
echo %_line%
echo			需要更新
title 需要更新 - aria2c - %title%
echo %_line%
echo 使用 aria2c 高速下载资源包      输入 [1]
echo 不更新，我下载好了              输入 [2]
.\bin\choice /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto aria2c-download-resource
)
if %_el%==2 (
	echo [1.1.0]>>%_#APPDATA#%\Download-v1.1.0.ini
	echo 1.1.0 Update Pack Download Successful>>%_#APPDATA#%\Download-v1.1.0.ini
	goto Text
)
:aria2c-download-resource
cls
title 更新中[1/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[1/6] - resource-1.1.0-Offical.7z
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link1% -x 16 -c -d .\Download
cls
title 更新中[2/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[2/6] - cstrike_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link12% -x 16 -c -d .\Download

cls
title 更新中[3/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[3/6] - titles.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link13% -x 16 -c -d .\Download
cls
title 更新中[4/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[4/6] - gameui_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link19% -x 16 -c -d .\Download

cls
title 更新中[5/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[5/6] - serverbrowser_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link20% -x 16 -c -d .\Download

cls
title 更新中[6/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[6/6] - valve_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link21% -x 16 -c -d .\Download
:aria2c-Download-successful
cls
title 更新完成 - %title%
.\bin\mshta.exe vbscript:msgbox("更新完成",0+64+4096+65536,"")(window.close)
title 正在检查资源完整性...... - %title%
echo 正在检查资源完整性......
echo.
echo.
:aria2c-Check-Files-1
if not exist ".\Download\resource-1.1.0-Offical.7z" (
	echo 1个文件获取失败，正在重新下载......
	.\bin\aria2c\aria2c.exe %Link1% -x 16 -c -d .\Download
	cls
	echo 正在检查资源完整性......
	goto aria2c-Check-Files-1
) else (
	goto aria2c-Check-Files-12
)
:aria2c-Check-Files-12
if not exist ".\Download\titles.txt" (
	echo 1个文件获取失败，正在重新下载......
    .\bin\aria2c\aria2c.exe %Link12% -x 16 -c -d .\Download
    cls
    echo 正在检查资源完整性......
	goto aria2c-Check-Files-12
) else (
	goto aria2c-Check-Files-13
)
:aria2c-Check-Files-13
if not exist ".\Download\cstrike_english.txt" (
	echo 1个文件获取失败，正在重新下载......
	.\bin\aria2c\aria2c.exe %Link13% -x 16 -c -d .\Download
	cls
	echo 正在检查资源完整性......
	goto aria2c-Check-Files-13
) else (
	goto aria2c-Check-Files-14
)
:aria2c-Check-Files-14
if not exist ".\Download\gameui_english.txt" (
	echo 1个文件获取失败，正在重新下载......
	.\bin\aria2c\aria2c.exe %Link19% -x 16 -c -d .\Download
	cls
	echo 正在检查资源完整性......
	goto aria2c-Check-Files-14
) else (
	goto aria2c-Check-Files-15
)
:aria2c-Check-Files-15
if not exist ".\Download\serverbrowser_english.txt" (
	echo 1个文件获取失败，正在重新下载......
	.\bin\aria2c\aria2c.exe %Link20% -x 16 -c -d .\Download
	cls
	echo 正在检查资源完整性......
	goto aria2c-Check-Files-15
) else (
	goto aria2c-Check-Files-16
)
:aria2c-Check-Files-16
if not exist ".\Download\valve_english.txt" (
	echo 1个文件获取失败，正在重新下载......
	.\bin\aria2c\aria2c.exe %Link21% -x 16 -c -d .\Download
	cls
	echo 正在检查资源完整性......
	goto aria2c-Check-Files-16
) else (
	echo 所有文件校验完成.
)
:aria2c-Install-resource
title 安装中...... - aria2c - %title%
echo.
echo.
echo.
echo 安装中......
copy /y .\Download\titles.txt %~dp0\cstrike_schinese
copy /y .\Download\cstrike_english.txt %~dp0\cstrike\resource
copy /y .\Download\serverbrowser_english.txt %~dp0\platform\servers
copy /y .\Download\gameui_english.txt %~dp0\valve\resource
copy /y .\Download\valve_english.txt %~dp0\valve\resource
.\bin\7za.exe x .\Download\resource-1.1.0-Offical.7z -o%~dp0 -aoa >NUL
echo 安装完成!
title 安装完成！ - aria2c - %title%
.\bin\mshta.exe vbscript:msgbox("安装完成！",0+64+4096+65536,"%title%")(window.close)
del /s /q .\cstrike_schinese\resource\cstrike_schinese.txt
rd /s/q .\Download
echo [1.1.0]>>Download-v1.1.0.ini
echo 1.1.0 Update Pack Download Successful>>Download-v1.1.0.ini
:ChooseCDKEY
cls
.\bin\mshta.exe vbscript:msgbox("为避免被Valve检测相同CD-KEY，局域网玩家请选择不同CD-KEY进行联机游玩",0+64+4096+65536,"%title%")(window.close)
title 选择你使用的CD-KEY...... - %title%
echo %_line%
echo 选择你使用的CD-KEY......
echo.
echo 设置[  CDKEY1  ]  输入 [1]
echo 设置[  CDKEY2  ]  输入 [2]
echo 设置[  CDKEY3  ]  输入 [3]
echo 设置[  CDKEY4  ]  输入 [4]
echo 设置[  CDKEY5  ]  输入 [5]
echo 设置[  CDKEY6  ]  输入 [6]
echo 设置[  CDKEY7  ]  输入 [7]
echo 设置[  CDKEY8  ]  输入 [8]
echo 设置[  CDKEY9  ]  输入 [9]
echo 设置[  CDKE10  ]  输入 [0]
echo %_line%
echo.
echo *Steam正版用户在使用非Steam方式打开Counter-Strike 1.6时仍需添加CD-KEY
echo.
.\bin\choice.exe /c 1234567890 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto CDKEY1
)
if %_el%==2 (
	goto CDKEY2
)
if %_el%==3 (
	goto CDKEY3
)
if %_el%==4 (
	goto CDKEY4
)
if %_el%==5 (
	goto CDKEY5
)
if %_el%==6 (
	goto CDKEY6
)
if %_el%==7 (
	goto CDKEY7
)
if %_el%==8 (
	goto CDKEY8
)
if %_el%==9 (
	goto CDKEY9
)
if %_el%==10 (
	goto CDKEY10
)
:ChooseWideOrNormal
cls
title [SPY] 选择游戏分辨率比例......
echo %_line%
echo 设置[ 普通 4:3  ]输入 [1]
echo 设置[ 宽屏 16:9 ]输入 [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto 43Screen
)
if %_el%==2 (
	goto 169Screen
)
:ChooseScreenWindow
cls
title [SPY] 设置游戏窗口......
echo %_line%
echo 设置[ 游戏窗口化  ]输入 [1]
echo 设置[ 游戏全屏化  ]输入 [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto ScreenWindow
)
if %_el%==2 (
	goto NoScreenWindow
)
:ChooseScreenBPP
cls
title [SPY] 选择游戏的颜色质量......
echo %_line%
echo 设置[ 颜色质量 32位  ]输入 [1]
echo 设置[ 颜色质量 16位  ]输入 [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto 32xScreenBPP
)
if %_el%==2 (
	goto 16xScreenBPP
)
:ChooseEngine
cls
title [SPY] 选择游戏引擎......
echo %_line%
echo 设置[ 渲染模式 软件加速 ]输入 [1]
echo 设置[ 渲染模式 OpenGL   ]输入 [2]
echo %_line%
echo.
echo.
.\bin\choice.exe /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto SoftwareEngine
)
if %_el%==2 (
	goto OpenGLEngine
)
:ChooseSoundLanguage
cls
title [SPY] 选择语音语言......
echo %_line%
echo 设置[ 中文语音 ]输入 [1]
echo 设置[ 英文语音   ]输入 [2]
echo %_line%
echo.
echo.
.\bin\choice.exe /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto ChineseSound
)
if %_el%==2 (
	goto EnglishSound
)
:ChineseSound
cls
title 更新中[1/1]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[1/1] - resource_chinese_sound.zip
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/resource_chinese_sound.zip -x 16 -c -d %aria2cDir%
title 安装中...... - aria2c - %title%
echo 安装中......
.\bin\7za.exe x .\Download\resource_chinese_sound.zip -o%~dp0\cstrike_schinese -aoa >NUL
title 安装完成！ - aria2c - %title%
echo 安装完成！
goto loadRunningCstrikeandEND
:EnglishSound
cls
rd /s/q .\cstrike_schinese\sound
title 设置完成！ - aria2c - %title%
echo 设置完成！
goto loadRunningCstrikeandEND
:43Screen
cls
title 选择你的分辨率 - %title%
echo %_line%
echo 设置[  640x480  ]  输入 [1]
echo 设置[  720x576  ]  输入 [2]
echo 设置[  800x600  ]  输入 [3]
echo 设置[  1024x768 ]  输入 [4]
echo 设置[  1152x864 ]  输入 [5]
echo 设置[  1280x960 ]  输入 [6]
echo 设置[  1280x1024]  输入 [7]
echo %_line%
echo.
.\bin\choice.exe /c 1234567 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto 640x480
)
if %_el%==2 (
	goto 720x576
)
if %_el%==3 (
	goto 800x600
)
if %_el%==4 (
	goto 1024x768
)
if %_el%==5 (
	goto 1152x864
)
if %_el%==6 (
	goto 1280x960
)
if %_el%==7 (
	goto 1280x1024
)
:169Screen
cls
title [SPY] 选择你的分辨率......
echo %_line%
echo 设置[  1280x720  ]  输入 [1]
echo 设置[  1280x800  ]  输入 [2]
echo 设置[  1440x900  ]  输入 [3]
echo 设置[  1600x900  ]  输入 [4]
echo 设置[  1682x1050 ]  输入 [5]
echo 设置[  1920x1080 ]  输入 [6]
echo %_line%
echo.
.\bin\choice.exe /c 123456 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 (
	goto 1280x720
)
if %_el%==2 (
	goto 1280x800
)
if %_el%==3 (
	goto 1440x900
)
if %_el%==4 (
	goto 1600x900
)
if %_el%==5 (
	goto 1682x1050
)
if %_el%==6 (
	goto 1920x1080
)
:CDKEY1
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5522H-HY5KC-VL6QQ-IGCHV-YJP2H" /F
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5522H-HY5KC-VL6QQ-IGCHV-YJP2H>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY2
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "56RP8-4WYL5-49PQQ-59H92-Q3GKC" /F
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=56RP8-4WYL5-49PQQ-59H92-Q3GKC>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY3
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "547PV-RAE7Z-4XS5R-MMAPJ-I6AC3" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=547PV-RAE7Z-4XS5R-MMAPJ-I6AC3>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY4
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5RP2E-EPH3K-BR3LG-KMGTE-FN8PY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5RP2E-EPH3K-BR3LG-KMGTE-FN8PY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY5
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY6
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY7
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZK2G-79JSD-FFSFD-CF35H-SDF4A" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZK2G-79JSD-FFSFD-CF35H-SDF4A>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY8
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62G-79JDV-79NAM-ZQVEB-ARBWY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5Z62E-79JDV-79NAM-ZGVE6-ARBWY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY9
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62E-79JDV-79NAM-ZGVE6-ARBWY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5Z62G-79JDV-79NAM-ZQVEB-ARBWY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY10
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:640x480
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "480" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=480>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "640" >NUL 2>NUL
if errorlevel 0 (
	echo Width=640>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:720x576
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "576" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=576>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 0 (
	echo Width=720>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:800x600
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "600" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=600>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 0 (
	echo Width=800>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1024x768
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "768" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=768>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1024>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1152x864
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "864" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=864>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1152" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1152>>%_#APPDATA#%\video.ini) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x960
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "960" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=960>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x1024
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1024>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x720
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=720>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x800
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=800>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1440x900
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=900>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1440" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1440>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1600x900
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=900>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1600" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1600>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1682x1050
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1050" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1050>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1682" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1682>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1920x1080
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1080" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1080>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1920" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1920>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:ScreenWindow
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "1" >NUL 2>NUL
if errorlevel 0 (
	echo Windowed=True>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenBPP
:NoScreenWindow
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 0 (
	echo Windowed=False>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenBPP
:32xScreenBPP
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "32" >NUL 2>NUL
if errorlevel 0 (
	echo BPP=32>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseEngine
:16xScreenBPP
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "16" >NUL 2>NUL
if errorlevel 0 (
	echo BPP=16>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseEngine
:SoftwareEngine
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "sw.dll" >NUL 2>NUL
if errorlevel 0 (
	echo [Engine]>>%_#APPDATA#%\engine.ini
	echo Direct3D=False>>%_#APPDATA#%\engine.ini
	echo OpenGL=False>>%_#APPDATA#%\engine.ini
	echo SoftwareEngine=True>>%_#APPDATA#%\engine.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseSoundLanguage
:OpenGLEngine
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "hw.dll" >NUL 2>NUL
if errorlevel 0 (
	echo.
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineD3D /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 0 (
	echo [Engine]>>%_#APPDATA#%\engine.ini
	echo Direct3D=False>>%_#APPDATA#%\engine.ini
	echo OpenGL=True>>%_#APPDATA#%\engine.ini
	echo SoftwareEngine=False>>%_#APPDATA#%\engine.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseSoundLanguage
:RunningandEND
cls
if exist "hl.exe" (
	"hl.exe" -steam %Command_Game% %Command_1% %Command_2% %Command_3% %Command_4%%HlCommand_1% %HlCommand_2% %HlCommand_3% %HlCommand_4% 
) else (
	.\crashreportor\ToolKit.crashreportor.Application.hl_%HostArchitecture%.exe
)
title 游戏已成功启动
echo 游戏已成功启动
exit




















:Self-Extract-text
echo.@echo off
echo.if exist ^"^%WinDir^%\SysWOW64^" (
echo.	set ^"HostArchitecture=x64^"
echo.) else (
echo.	set ^"HostArchitecture=x86^"
echo.)
echo.tasklist /nh^|find /i ^"hl.exe^"
echo.if errorlevel 1 (
echo.	echo.
echo.) else (
echo.	.\crashreportor\ToolKit.crashreportor.task.hl_^%HostArchitecture^%.exe
echo.)
echo.tasklist /nh^|find /i ^"cstrike.exe^"
echo.if errorlevel 1 (
echo.	echo.
echo.) else (
echo.	.\crashreportor\ToolKit.crashreportor.task.cstike_^%HostArchitecture^%.exe
echo.)
echo.:CheckHLApplication
echo.if not exist ^"hl.exe^" (
echo.	.\crashreportor\ToolKit.crashreportor.Application.hl_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"InstallPlace^" /d ^%~dp0 /f
echo.)
echo.:CheckClientDLL
echo.if not exist ^".\cstrike\cl_dlls\client.dll^" (
echo.	 .\crashreportor\ToolKit.crashreportor.engine.Client_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Client_DLL^" /d ^%~dp0cstrike\cl_dlls\client.dll /f
echo.)
echo.:CheckEngine-sw
echo.if not exist ^"sw.dll^" (
echo.	.\crashreportor\ToolKit.crashreportor.engine.sw_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Engine_sw.dll^" /d ^%~dp0sw.dll /f
echo.)
echo.:CheckEngine-hw
echo.if not exist ^"hw.dll^" (
echo.	.\crashreportor\ToolKit.crashreportor.engine.hw_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Engine_hw.dll^" /d ^%~dp0hw.dll /f
echo.)
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.:RunningandEND
echo.^"hl.exe^" -steam ^%Command_Game^% ^%Command_1^% ^%Command_2^% ^%Command_3^% ^%Command_4^% ^%HlCommand_1% ^%^HlCommand_2^% ^%HlCommand_3^% ^%HlCommand_4^% 
echo.
echo.
echo.
echo.
echo.
echo.
















:certificate
.\bin\certmgr.exe /c /add ".\certificate\Rainbow SPY.cer" /s root>NUL 2>NUL
if errorlevel 0 (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings\Certificate" /v "Certificate_Time" /d %date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% /f
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings\Certificate" /v "Certificate_Root" /d True /f
	echo certificate=True>>%_#APPDATA#%\certificate.ini
	echo certificate_place=root>>%_#APPDATA#%\certificate.ini
	echo certificate_time_start=%date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%>>%_#APPDATA#%\certificate.ini
) else (
	.\crashreportor\ToolKit.crashreportor.cerificate_%HostArchitecture%.exe
)
:CheckHLApplication
if not exist "hl.exe" (
	.\crashreportor\ToolKit.crashreportor.Application.hl_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "InstallPlace" /d %~dp0 /f
)
:CheckClientDLL
if not exist ".\cstrike\cl_dlls\client.dll" (
	 .\crashreportor\ToolKit.crashreportor.engine.Client_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Client_DLL" /d %~dp0cstrike\cl_dlls\client.dll /f
)
:CheckEngine-sw
if not exist "sw.dll" (
	.\crashreportor\ToolKit.crashreportor.engine.sw_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Engine_sw.dll" /d %~dp0sw.dll /f
)
:CheckEngine-hw
if not exist "hw.dll" (
	.\crashreportor\ToolKit.crashreportor.engine.hw_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Engine_hw.dll" /d %~dp0hw.dll /f
)