@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

if DEFINED OS_unsupported ( echo ^(OS unsupported^) testing not done & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

set _TEST_CMD=%TEST_METHOD%
if DEFINED TEST_FILES set _TEST_CMD=%_TEST_CMD% %TEST_FILES%

echo [`%_TEST_CMD%`] & call %_TEST_CMD%

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
