@echo off
::配置库路径
set lib_name=libpax_app_untity.so
set lib_dir=D:\svn\prolin_wsp\component\pax_app_untity\default
set self_prj_dir=..\..
set is_block=%1
call BAT-remote.bat %lib_name% %lib_dir% %self_prj_dir% %is_block%