@set "ERRORLEVEL="
@call perl "%~dp0_cpanm.fatpack.pl" %*
@if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
