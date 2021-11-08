@echo off
::配置库路径
set lib_name=%1
set lib_dir=%2
set self_prj_dir=%3
set is_block=%4

set cur_dir=%cd%
cd %lib_dir%
make
cd %cur_dir%

copy %lib_dir%\%lib_name% %self_prj_dir%\lib\

if "%is_block%"=="true" (
	choice /t 5 /d n /m "press y to lock the message, n or 5s timeout to exit"
	if errorlevel 2 goto:eof
	pause
)