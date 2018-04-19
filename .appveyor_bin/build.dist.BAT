@echo off
set "ERRORLEVEL="

if DEFINED OS_unsupported ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if /I "%DIST_TOOLING%"=="build" ( echo `perl Build` & call perl Build )
if /I "%DIST_TOOLING%"=="make" 	( echo `%make%` & call "%make%" )

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
