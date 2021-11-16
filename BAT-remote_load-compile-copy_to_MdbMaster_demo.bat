@echo off
call :func_config
call :func_main
goto:eof

:func_config
	REM 基础配置
	set bat=lm.bat
	set prj_dir=D:\svn\prolin_wsp\unattended\mdb\main\mdb
	set demo_prj_dir=D:\svn\android_wsp\MdbMasterDemo\app
	REM 配置计算
	set lib_src_file=%prj_dir%\default_ndk_master_library\libs\armeabi-v7a\libMdbMaster.so
	set lib_dst_dir=%demo_prj_dir%\libs\armeabi-v7a
	set java_src_file=%prj_dir%\ndk_only\src\master_library_only\MdbMaster.java
	set java_dst_dir=%demo_prj_dir%\src\main\java\com\pax\unattended\mdb
goto:eof

:func_main
	call %bat% make
	copy %lib_src_file% %lib_dst_dir%\
	copy %java_src_file% %java_dst_dir%\
	call %bat% block
goto:eof