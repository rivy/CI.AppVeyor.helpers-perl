@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

if DEFINED OS_unsupported ( echo ^(OS unsupported^) testing not done & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

echo [`%TEST_METHOD% %TEST_FILES%`] & call %TEST_METHOD% %TEST_FILES%

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
