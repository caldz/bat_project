@echo off
::配置库路径
set lib_name=libjansson.so
set lib_dir=D:\svn\prolin_wsp\component\jansson\default
set self_prj_dir=..\..
set is_block=true
call BAT-remote.bat %lib_name% %lib_dir% %self_prj_dir% %is_block%