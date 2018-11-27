@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

if DEFINED CI_SKIP ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED OS_unsupported ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if /I "%DIST_TOOLING%"=="build" ( echo [`perl Build.PL`] & call perl Build.PL )
if /I "%DIST_TOOLING%"=="make"  ( echo [`perl Makefile.PL`] & call perl Makefile.PL )

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
