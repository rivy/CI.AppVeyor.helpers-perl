@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

if DEFINED CI_SKIP ( echo info: build not done ^(CI_SKIP enabled^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED OS_unsupported ( echo info: build not done ^(OS unsupported^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if /I "%DIST_TOOLING%"=="build" ( echo [`perl Build`] & call perl Build )
if /I "%DIST_TOOLING%"=="make"  ( echo [`%make%`] & call "%make%" )

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
