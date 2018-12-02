@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

if DEFINED CI_SKIP ( echo info: testing not done ^(CI_SKIP enabled^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED CI_SKIP_TEST ( echo info: testing not done ^(CI_SKIP_TEST enabled^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED OS_unsupported ( echo info: testing not done ^(OS unsupported^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

set _TEST_CMD=%TEST_METHOD%
if DEFINED TEST_FILES set _TEST_CMD=%_TEST_CMD% %TEST_FILES%

echo [`%_TEST_CMD%`] & call %_TEST_CMD%

if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
