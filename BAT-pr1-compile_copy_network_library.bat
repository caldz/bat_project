@echo off
::配置库路径
set lib_name=libnetwork.so
set lib_dir=D:\svn\prolin_wsp\component\network\default
set self_prj_dir=..\..
set is_block=%1
call remote.bat %lib_name% %lib_dir% %self_prj_dir% %is_block%
call BAT-p2-compile+pack+load.bat