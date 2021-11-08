@echo off
::配置库路径
set lib_name=libjxui.so
set lib_dir=D:\svn\prolin_wsp\jxui\default
set self_prj_dir=..\..
set is_block=%1
call BAT-remote.bat %lib_name% %lib_dir% %self_prj_dir% %is_block%