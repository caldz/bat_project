@echo off
setlocal enabledelayedexpansion

set zip_tool=winrar
set product_name=mdb_master_library
set product_ver=1.00.00
set prj_dir=..\..\..
set files_list="libMdbMaster.so MdbMaster.java release_note.txt"
set dir_list=%prj_dir%\doc ^
	%prj_dir%\default_ndk_master_library\libs\armeabi-v7a ^
	%prj_dir%\ndk_only\src\master_library_only


:main
	set final_list=
	for %%i in (%dir_list%) do (
		for %%j in (%files_list%) do (
			call :func_make_final_list %%i %files_list%
			set final_list=!final_list! !fo_fml_final_list!
		)
	)
	echo package_file_list=%final_list%
	set tag=%product_name%_%product_ver%
	call :func_pack_files %tag% "%final_list%"
	pause
goto :eof

:func_make_final_list
REM input: <%1:dir, %2:list(多项时用""框起来)>
REM output: <final_list>
	set fo_fml_final_list=
	set fv_dir=%~1
	set fv_list=%~2
	for %%i in (%fv_list%) do (
		set file_path=%fv_dir%\%%i
		if exist !file_path! (
			set fo_fml_final_list=!fo_fml_final_list! !file_path!
		)
	)
	REM echo fv_dir=%fv_dir% fv_list=%fv_list%
	REM echo fo_fml_final_list=%fo_fml_final_list%
goto :eof

:func_pack_files
REM input: <%1:tag, %2:files(多项时用""框起来)>
	set fv_tag=%1
	set fv_files=%~2
	echo fv_tag=%fv_tag% fv_files=%fv_files%
	set fv_date_ver=%date:~0,4%%date:~5,2%%date:~8,2%
	set fv_zip_name=%fv_tag%_%fv_date_ver%.zip
	del /q %fv_zip_name%
	%zip_tool% a %fv_zip_name% -ep1 %fv_files%
goto :eof

