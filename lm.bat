@echo off
REM 首先要配置脚本所在工程的平台
REM 然后再去不同平台的 func_xx_config 函数去做更细致的配置

set platform=ndk
set output=library


REM PROLIN区
if "%platform%"=="prolin" (
	call :func_prolin_config
	call :func_prolin_cal_var
	call :func_prolin_main %*
) else if "%platform%"=="ndk" (
REM NDK
	REM echo platform=%platform%
	set make_dir=..
	call :func_ndk_config
	call :func_ndk_cal_var
	call :func_ndk_main %*
) else (
	echo "incorrect platform:%platform%"
	pause
	exit
)
goto:eof


REM 配置区=======================================
:func_prolin_config
REM 一般不同环境都需要配置一遍
	set prj_dir=..\..
	set sdk_dir=D:\software\SDK\prolin
	set loader_dir=D:\software\tool\pax\TermAssist
	set com_index=5
	set bin_name=
goto:eof


:func_prolin_cal_var
REM 仅当有特殊需要时才需要去配置
REM input<prj_dir loader_dir sdk_dir>
REM output<xcb,zip,output_zip,>
	set fv_cur_dir=%cd%
	cd %prj_dir%
	set fv_prj_dir=%cd%
	cd %fv_cur_dir%
	if "%bin_name%"=="" (
		for %%i in (%fv_prj_dir%) do (set bin_name=%%~nxi)
	)
	set xcb=%loader_dir%\tools\xcb
	set zip=%loader_dir%\tools\7za
	set output_zip=%fv_prj_dir%\pkg\%bin_name%.aip
	set zip_files_list=appinfo .\default\%bin_name% res\ data\ lib\
	set zip_add_files_list=appinfo .\default\%bin_name%
	set make=%sdk_dir%\sdk\tools\msys\bin\make
	set make_dir=%prj_dir%\default
goto:eof
REM 配置区---------------------------------------


REM 函数区======================================

:func_timeout_block
	choice /t 5 /d n /m "press y to lock the message, n or 5s timeout to exit"
	if errorlevel 2 goto:eof
	pause
goto:eof




:func_prolin_main
	if "%1"=="make" (
		REM 编译
		call :func_prolin_build
	) else if "%1"=="clean" (
		REM 清空编译产物
		call :func_prolin_build clean
	) else if "%1"=="pack" (
		REM 打包app
		call :func_prolin_pack %prj_dir% %zip% %bin_name% %output_zip% %zip_files_list%
	) else if "%1"=="add_pack" (
		REM 增量打包app（仅打包执行程序）
		call :func_prolin_pack %prj_dir% %zip% %bin_name% %output_zip% %zip_add_files_list%
	) else if "%1"=="load" (
		REM 安装app
		call :func_prolin_xcb_op installer aip %output_zip%
	) else if "%1"=="clear" (
		REM 清除APP
		call :func_prolin_xcb_op installer uaip MAINAPP
	) else if "%1"=="log" (
		REM 查询日志
		echo log [start]
		call :func_prolin_xcb_op logcat -c
		call :func_prolin_xcb_op logcat "*:e"
	) else if "%1"=="telnet" (
		REM 打开telnet服务器
		call :func_prolin_xcb_op telnetd
	) else if "%1"=="block" (
		REM 卡住信息
		call :func_timeout_block
	) else (
		REM call :func_prolin_build
	)
goto:eof


REM input<prj_dir,zip,bin_name,output_zip,zip_file_list>
:func_prolin_pack
	set fv_zip_files_list=%5 %6 %7 %8 %9
	del /q %output_zip%
	set fv_cur_dir=%cd%
	cd %1
		@echo on
		%2 a -r -tzip %output_zip% %fv_zip_files_list%
		@echo off
	cd %fv_cur_dir%
goto:eof

:func_prolin_xcb_op
	%xcb% connect com:COM%com_index%
	%xcb% %*
goto:eof

:func_prolin_build
set fv_cur_dir=%cd%
cd %make_dir%
%make% %1
cd %fv_cur_dir%
goto:eof



:func_ndk_config
goto:eof
:func_ndk_cal_var
goto:eof

:func_ndk_main
	if "%1"=="make" (
		call :func_ndk_build
	) else if "%1"=="clean" (
		call :func_ndk_build clean
	) else if "%1"=="block" (
		call :func_timeout_block
	) else (
		echo "no match command"
	)
goto:eof

:func_ndk_vmc_main
	if "%1"=="make" (
		call :func_ndk_build
	) else if "%1"=="clean" (
		call :func_ndk_build clean
	) else if "%1"=="block" (
		call :func_timeout_block
	) else (
		echo "no match command"
	)
goto:eof

:func_ndk_build
	set fv_cur=%cd%
	cd %make_dir%
	call ndk-build.cmd %1
	cd %fv_cur%
goto:eof

:func_ndk_vmc_load
	if not "%1"=="" (set fv_ndk_vmc_prj_dir=%1) else (set fv_ndk_vmc_prj_dir=%ndk_vmc_dir%)
	adb push %fv_ndk_vmc_prj_dir%\..\libs\armeabi-v7a\vmc /tmp/
	adb push %fv_ndk_vmc_prj_dir%\data\vmc_config.json /tmp/
	adb push %fv_ndk_vmc_prj_dir%\data\console_config.json /tmp/
	adb push %fv_ndk_vmc_prj_dir%\data\vmc_mdb_driver_config.json /tmp/
	adb shell chmod +x /tmp/vmc;
goto:eof

:func_ndk_vmc_getlog
	adb pull /storage/emulated/0/vmc_spi.quick.plog ./spi.quick.plog
goto:eof



REM 函数区-----------------------------------------



REM 说明区==========================================
goto comment
:comment
REM 说明区-------------------------------------------