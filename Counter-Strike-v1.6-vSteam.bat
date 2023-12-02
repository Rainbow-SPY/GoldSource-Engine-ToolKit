:: Counter-Strike-1.6-vSteam build 12835476
@echo off
@set _#APPDATA#=%LOCALAPPDATA%\Rainbow-SPY\cstrike\bin
if exist "%_#APPDATA#%\load.ini" (
		goto loadRunningCstrikeandEND
		) else (
		echo.
		)
:CheckProcess
tasklist /nh|find /i "hl.exe"
if errorlevel 1 (set _Ecode_Task_HL=False) else (set _Ecode_Task_HL=True & cls & goto CrashHLTask)
tasklist /nh|find /i "cstrike.exe"
if errorlevel 1 (set _Ecode_Task_cstrike=False) else (set _Ecode_Appcation_Steam=False & cls & goto CrashCstrikeTask)

:CheckFolder
if exist "%_#APPDATA#%\Log" (
      	echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]====================启动程序====================>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
      	) else (
      	md "%_#APPDATA#%\Log"
      	)
if exist "%_#APPDATA#%" (
      	echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]创建 LocalAppData 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
	    ) else (
		md "%_#APPDATA#%" & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]创建 LocalAppData 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
	    )
if exist "%_#APPDATA#%\Backup" (
      	set _backup=%_#APPDATA#%\Backup& echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]创建 Backup 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
	    ) else (
		md "%_#APPDATA#%\Backup" & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]创建 Backup 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
	    )
:Backup
copy /y "%~f0" "%_backup%" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_COPY & goto CrashCopy
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]复制 主程序 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
copy /y %~dp0\cstrike\resource\RunGameResource.res "%_backup%" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_COPY & goto CrashCopy
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]复制 游戏运行资源包 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
ren "%_backup%\Counter-Strike-1.6-vSteam.bat" "Bak_%date:~0,4%_%date:~5,2%_%date:~8,2%_%time:~0,2%_%time:~3,2%_%time:~6,2%.bat"
:CheckFile
if not exist "hl.exe" (
	goto CrashHLexe 
		) else (
		reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "InstallPlace" /d %~dp0 /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 InstallPlace 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
		)
if not exist ".\cstrike\cl_dlls\client.dll" (
		goto CrashEngine
		) else (
		reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "Client_DLL" /d %~dp0cstrike\cl_dlls\client.dll /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 Client_DLL 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
		)
if not exist "sw.dll" (
		goto CrashEngine
		) else (
		reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "Engine_sw.dll" /d %~dp0sw.dll /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 sw.dll 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
		)
if not exist "hw.dll" (
		goto CrashEngine
		) else (
		reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "Engine_hw.dll" /d %~dp0hw.dll /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 hw.dll 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
		)
if not exist "%_#APPDATA#%\certificate.ini" (
		echo [certificate]>>%_#APPDATA#%\certificate.ini
		) else (
		goto 2nd
)
:certificate
certmgr.exe /c /add "Rainbow SPY.cer" /s root>NUL 2>NUL
if errorlevel 1 set _Ecode_main=ERROR_NOT_INSTALL_CERTIFICATE & goto CrashCer
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]导入安全证书 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log" & reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "Certificate_Time" /d %date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 安全证书生效日期 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log" & reg add "HKCU\Software\Rainbow-SPY\Counter-Strike" /v "Certificate_Root" /d True /f & echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]写入注册表 安全证书生效 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log" & set _Ecode_Certificate=True & echo certificate=True>>%_#APPDATA#%\certificate.ini & echo certificate_place=root>>%_#APPDATA#%\certificate.ini & echo certificate_time_start=%date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%>>%_#APPDATA#%\certificate.ini

:2nd
cls
title & echo 初始化.......
color 0a
set _el=%errorlevel% 
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _el 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
set _ver=Counter-Strike-1.6-vSteam
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _ver 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
set _tag=SPY
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _tag 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
set _line=-------------------------------------
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _line 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
set _Ecode_DLL_Engine_OpenGL=False       
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _Ecode_DLL_Engine_OpenGL 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"             
set _Ecode_DLL_Engine_D3D=False
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _Ecode_DLL_Engine_D3D 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
set _Ecode_DLL_Engine_Software=False
if errorlevel 1 set _Ecode_main= ERROR_SET_REG & goto CrashSet
if errorlevel 0 echo [%time:~0,2%:%time:~3,2%:%time:~6,2%]设置变量 _Ecode_DLL_Engine_Software 完成>>"%_#APPDATA#%\Log\Log_%date:~0,4%_%date:~5,2%_%date:~8,2%.log"
:Text
cls
echo %_line%
echo           App ID:10
echo           软件版本：1.0.Pre-res For Steam.
echo           游戏版本: cstrike-Half-Life 25th Anniversary update
echo           build ID:12835476
echo           %_ver% 启动程序
echo           Edit by Rainbow-SPY
echo           QQ:2716842407  有bug请及时反馈
echo %_line%
:ChooseCDKEY
mshta vbscript:msgbox("为避免被Valve检测相同CD-KEY，局域网玩家请选择不同CD-KEY进行联机游玩",0+64+4096+65536,"%_ver%启动程序")(window.close)
title [SPY] 选择你使用的CD-KEY......
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
echo *Steam正版用户在游玩Counter-Strike 1.6时仍需添加CD-KEY
echo.
choice /c 1234567890 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1  goto CDKEY1
if %_el%==2  goto CDKEY2
if %_el%==3  goto CDKEY3
if %_el%==4  goto CDKEY4
if %_el%==5  goto CDKEY5
if %_el%==6  goto CDKEY6
if %_el%==7  goto CDKEY7
if %_el%==8  goto CDKEY8
if %_el%==9  goto CDKEY9
if %_el%==10 goto CDKEY10
:ChooseWideOrNormal
cls
title [SPY] 选择游戏分辨率比例......
echo %_line%
echo 设置[ 普通 4:3  ]输入 [1]
echo 设置[ 宽屏 16:9 ]输入 [2]
echo %_line%
echo.
choice /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto 43Screen
if %_el%==2 goto 169Screen
:ChooseScreenWindow
cls
title [SPY] 设置游戏窗口......
echo %_line%
echo 设置[ 游戏窗口化  ]输入 [1]
echo 设置[ 游戏全屏化  ]输入 [2]
echo %_line%
echo.
choice /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto ScreenWindow
if %_el%==2 goto NoScreenWindow
:ChooseScreenBPP
cls
title [SPY] 选择游戏的颜色质量......
echo %_line%
echo 设置[ 颜色质量 32位  ]输入 [1]
echo 设置[ 颜色质量 16位  ]输入 [2]
echo %_line%
echo.
choice /c 12 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto 32xScreenBPP
if %_el%==2 goto 16xScreenBPP
:ChooseEngine
cls
title [SPY] 选择游戏引擎......
echo %_line%
echo 设置[ 渲染模式 软件加速 ]输入 [1]
echo 设置[ 渲染模式 OpenGL   ]输入 [2]
echo 设置[ 渲染模式 D3D*     ]输入 [3]
echo %_line%
echo.
echo *Steam正版在最新版本中不支持Direct3D引擎渲染
echo.
choice /c 123 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto SoftwareEngine
if %_el%==2 goto OpenGLEngine
if %_el%==3 goto Direct3DEngine
:43Screen
cls
echo&title [SPY] 选择你的分辨率......
echo 设置[  640x480  ]  输入 [1]
echo 设置[  720x576  ]  输入 [2]
echo 设置[  800x600  ]  输入 [3]
echo 设置[  1024x768 ]  输入 [4]
echo 设置[  1152x864 ]  输入 [5]
echo 设置[  1280x960 ]  输入 [6]
echo 设置[  1280x1024]  输入 [7]
echo.
choice /c 1234567 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto 640x480
if %_el%==2 goto 720x576
if %_el%==3 goto 800x600
if %_el%==4 goto 1024x768
if %_el%==5 goto 1152x864
if %_el%==6 goto 1280x960
if %_el%==7 goto 1280x1024
:169Screen
cls
title [SPY] 选择你的分辨率......
echo 设置[  1280x720  ]  输入 [1]
echo 设置[  1280x800  ]  输入 [2]
echo 设置[  1440x900  ]  输入 [3]
echo 设置[  1600x900  ]  输入 [4]
echo 设置[  1682x1050 ]  输入 [5]
echo 设置[  1920x1080 ]  输入 [6]
echo.
choice /c 123456 /n /m "你的选择："
set _el=%errorlevel% 
if %_el%==1 goto 1280x720
if %_el%==2 goto 1280x800
if %_el%==3 goto 1440x900
if %_el%==4 goto 1600x900
if %_el%==5 goto 1682x1050
if %_el%==6 goto 1920x1080

:CDKEY1
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5522H-HY5KC-VL6QQ-IGCHV-YJP2H" /F
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5522H-HY5KC-VL6QQ-IGCHV-YJP2H>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY2
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "56RP8-4WYL5-49PQQ-59H92-Q3GKC" /F
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=56RP8-4WYL5-49PQQ-59H92-Q3GKC>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY3
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "547PV-RAE7Z-4XS5R-MMAPJ-I6AC3" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=547PV-RAE7Z-4XS5R-MMAPJ-I6AC3>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY4
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5RP2E-EPH3K-BR3LG-KMGTE-FN8PY" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5RP2E-EPH3K-BR3LG-KMGTE-FN8PY>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY5
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY6
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY7
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZK2G-79JSD-FFSFD-CF35H-SDF4A" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5ZK2G-79JSD-FFSFD-CF35H-SDF4A>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY8
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62G-79JDV-79NAM-ZQVEB-ARBWY" /F >NUL 2>NUL
if e7rrorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5Z62E-79JDV-79NAM-ZGVE6-ARBWY>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY9
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62E-79JDV-79NAM-ZGVE6-ARBWY" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5Z62G-79JDV-79NAM-ZQVEB-ARBWY>>%_#APPDATA#%\cd-key.ini
goto ChooseWideOrNormal
:CDKEY10
reg add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT" /F >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini & echo CD_KEY=5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT>>%_#APPDATA#%\cd-key.ini 
goto ChooseWideOrNormal
:640x480
::4:3 640x480分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "480" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=480>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "640" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=640>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:720x576
::4:3 720x576分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "576" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=576>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=720>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:800x600
::4:3 800x600分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "600" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=600>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=800>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1024x768
::4:3 1024x768分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "768" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=768>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1024>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1152x864
::4:3 1152x864分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "864" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=864>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1152" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1152>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1280x960
::4:3 1280x960分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "960" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=960>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1280>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1280x1024
::4:3 1280x1024分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=1024>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1280>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1280x720
::16:9 1280x720分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=720>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1280>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1280x800
::16:9 1280x800分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=800>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1280>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1440x900
::16:9 1440x900分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=900>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1440" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1440>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1600x900
::16:9 1600x900分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=900>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1600" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1600>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1682x1050
::16:9 1682x1050分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1050" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=1050>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1682" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1682>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:1920x1080
::1920x1080分辨率游戏
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1080" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Height=1080>>%_#APPDATA#%\video.ini
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1920" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Video]>>%_#APPDATA#%\video.ini & echo Width=1920>>%_#APPDATA#%\video.ini
goto ChooseScreenWindow
:ScreenWindow
::窗口化
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "1" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo Window=True>>%_#APPDATA#%\video.ini
goto ChooseScreenBPP
:NoScreenWindow
::全屏化
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo Window=False>>%_#APPDATA#%\video.ini
goto ChooseScreenBPP
:32xScreenBPP
::颜色质量>>>最高[32位]
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "32" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo BPP=32>>%_#APPDATA#%\video.ini
goto ChooseEngine
:16xScreenBPP
::颜色质量>>>中等[16位]
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "16" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo BPP=16>>%_#APPDATA#%\video.ini
goto ChooseEngine
:SoftwareEngine
::渲染模式>>>软件加速
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "sw.dll" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Engine]>>%_#APPDATA#%\engine.ini & echo Direct3D=False>>%_#APPDATA#%\engine.ini & echo OpenGL=False>>%_#APPDATA#%\engine.ini & echo SoftwareEngine=True>>%_#APPDATA#%\engine.ini
goto RunningCstrikeandEND
:Direct3DEngine
::渲染模式>>>D3D
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "hw.dll" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo.
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineD3D /t REG_DWORD /f /d "1" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Engine]>>%_#APPDATA#%\engine.ini & echo Direct3D=True>>%_#APPDATA#%\engine.ini & echo OpenGL=False>>%_#APPDATA#%\engine.ini & echo SoftwareEngine=False>>%_#APPDATA#%\engine.ini
goto RunningCstrikeandEND
:OpenGLEngine
::渲染模式>>>OpenGL
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "hw.dll" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo.
reg add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineD3D /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 1 set _Ecode_main= ERROR_INVALID_HANDLE(0x0000003f5) & goto CrashSet
if errorlevel 0 echo [Engine]>>%_#APPDATA#%\engine.ini & echo Direct3D=False>>%_#APPDATA#%\engine.ini & echo OpenGL=True>>%_#APPDATA#%\engine.ini & echo SoftwareEngine=False>>%_#APPDATA#%\engine.ini
goto RunningCstrikeandEND
:RunningCstrikeandEND
cls
color 0a
title 游戏已成功启动
echo 游戏已成功启动
echo [load]>%_#APPDATA#%\load.ini
echo load=True>%_#APPDATA#%\load.ini
"hl.exe" -steam -game cstrike
exit

:loadRunningCstrikeandEND
cls
color 0a
title 游戏已成功启动
echo 游戏已成功启动
"hl.exe" -steam -game cstrike
exit















pause
exit
:CrashCer
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n，证书安装失败，无法验证证书的完整性。\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashSet
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n未知错误，写入注册表无效。\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashHLTask
mshta vbscript:msgbox(Replace("应用程序发生异常%_Ecode_main%.\nCounter-Strike或Half-Life正在运行，无法更新配置.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashCstrikeTask
mshta vbscript:msgbox(Replace("应用程序发生异常%_Ecode_main%.\nCounter-Strike正在运行，无法更新配置.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashHLexe
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n找不到hl.exe，程序被迫中止.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashEngine-SW.DLL
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n找不到sw.dll，游戏引擎异常.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashEngine-HW.DLL
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n找不到hw.dll，游戏引擎异常.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit
:CrashClient
mshta vbscript:msgbox(Replace("应用程序发生异常 (%_Ecode_main%).\n找不到client.dll，客户端窗口异常.\n\n要终止程序，请单击[确定]。","\n",vbCrLf),0+16+4096+65536,"%_ver%启动程序 - 应用程序错误")(window.close)
exit

