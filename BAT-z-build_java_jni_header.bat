@echo off
set java_dir=.
set prj_dir=..\..\..
set inc_output_dir=%prj_dir%\ndk_only\inc\master_library_only
set class_name=MdbMaster
set java_path=%prj_dir%\ndk_only\src\master_library_only\%class_name%.java
set pkg_route=com.pax.unattended.mdb.MdbMaster

call :func_main
pause

goto:eof

:func_main
	call :func_clean
	call :func_build_class_file
	call :func_build_header
	call :func_clean
goto:eof

:func_clean
	echo "clear files"
	rd /s /q com
goto:eof
:func_build_class_file
	echo "build .class"
	javac %java_path% -d .
goto:eof
:func_build_header
	echo "build .h"
	javah -d %inc_output_dir%\ %pkg_route%
goto:eof
