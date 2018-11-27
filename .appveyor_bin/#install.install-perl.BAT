@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

:: NOTE: contains some peculiar statement ordering and redirections b/c of AppVeyor bugs when executing BAT/CMD scripts

if not defined perl_version ( set "perl_version=latest" )

:: ## refine "generic" perl versions
if "%perl_version%"=="5.8.8" ( set "perl_version=5.8.8.4" )
if "%perl_version%"=="5.8"   ( set "perl_version=5.8.9.5" )
if "%perl_version%"=="5.10"  ( set "perl_version=5.10.1.1" )
if "%perl_version%"=="5.12"  ( set "perl_version=5.12.1.0" )
if "%perl_version%"=="5.14"  ( set "perl_version=5.14.4.1" )
if "%perl_version%"=="5.16"  ( set "perl_version=5.16.3.1" )
if "%perl_version%"=="5.18"  ( set "perl_version=5.18.4.1" )
if "%perl_version%"=="5.20"  ( set "perl_version=5.20.3.3" )
if "%perl_version%"=="5.22"  ( set "perl_version=5.22.3.1" )
if "%perl_version%"=="5.24"  ( set "perl_version=5.24.4.1" )
if "%perl_version%"=="5.26"  ( set "perl_version=5.26.2.1" )
if "%perl_version%"=="5.28"  ( set "perl_version=5.28.0.1" )

:: ## determine direct download file (as needed [generally only for certain earlier perl versions])
set "perl_download="
if "%perl_version%"=="5.8.8.4"  ( set "perl_download=http://strawberryperl.com/download/5.8.8/strawberry-perl-5.8.8.4.zip" )
if "%perl_version%"=="5.8.9.5"  ( set "perl_download=http://strawberryperl.com/download/5.8.9/strawberry-perl-5.8.9.5.zip" )
if "%perl_version%"=="5.10.1.1" ( set "perl_download=http://strawberryperl.com/download/5.10.1.1/strawberry-perl-5.10.1.1.zip" )
if "%perl_version%"=="5.12.1.0" ( set "perl_download=http://strawberryperl.com/download/5.12.1.0/strawberry-perl-5.12.1.0.zip" )
if "%perl_version%"=="5.14.4.1" ( set "perl_download=http://strawberryperl.com/download/5.14.4.1/strawberry-perl-5.14.4.1-64bit.zip" )
if "%perl_version%"=="5.16.3.1" ( set "perl_download=http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit.zip" )
REM if "%perl_version%"=="5.18.4.1" ( set "perl_download=http://strawberryperl.com/download/5.18.4.1/strawberry-perl-5.18.4.1-64bit.zip" )
REM if "%perl_version%"=="5.20.3.3" ( set "perl_download=http://strawberryperl.com/download/5.20.3.3/strawberry-perl-5.20.3.3-64bit.zip" )
REM if "%perl_version%"=="5.22.3.1" ( set "perl_download=http://strawberryperl.com/download/5.22.3.1/strawberry-perl-5.22.3.1-64bit.zip" )
REM if "%perl_version%"=="5.24.4.1" ( set "perl_download=http://strawberryperl.com/download/5.24.4.1/strawberry-perl-5.24.4.1-64bit.zip" )
REM if "%perl_version%"=="5.26.2.1" ( set "perl_download=http://strawberryperl.com/download/5.26.2.1/strawberry-perl-5.26.2.1-64bit.zip" )
REM if "%perl_version%"=="5.28.0.1" ( set "perl_download=http://strawberryperl.com/download/5.28.0.1/strawberry-perl-5.28.0.1-64bit.zip" )

:: ## setup download area (CI_CACHE_DIR availability is not assumed)

set "_DL_DIR=%CI_CACHE_DIR%"
if not defined _DL_DIR set "_DL_DIR=%CI_TEMP_DIR%"
if not defined _DL_DIR set "_DL_DIR=%TEMP%"
if not defined _DL_DIR set "_DL_DIR=%TMP%"
if not defined _DL_DIR set "_DL_DIR=C:\."
set "_DL_DIR=%_DL_DIR%\perl.download"
if not exist "%_DL_DIR%" mkdir "%_DL_DIR%"

:: ## install
echo|set /p OUTPUT="Installing Strawberry Perl "

set "cinst_options=--yes"
if /i not "%perl_version%" == "latest" ( set "cinst_options=%cinst_options% --version %perl_version%" )

if not defined perl_download (
  echo|set /p OUTPUT="(%perl_version%; via Chocolatey [`cinst %cinst_options% StrawberryPerl`]) ... "
  call choco config set cacheLocation "%_DL_DIR%" >NUL
  call cinst %cinst_options% StrawberryPerl | rem # script fails here if STDOUT redirected to NUL [AppVeyor bug]
) else (
  echo|set /p OUTPUT="(%perl_version%; via direct download) ... "
  call curl -# -L "%perl_download%" -o "%_DL_DIR%\perl-%perl_version%.zip" >NUL 2>&1 && call 7z -bd x "%_DL_DIR%\perl-%perl_version%.zip" -oc:\strawberry >NUL
)

if "%ERRORLEVEL%" == "0" ( echo done ) else ( echo install.install-perl::FAILED [ERRORLEVEL=%ERRORLEVEL%] & exit /b -1 )

:: ## configure
echo|set /p OUTPUT="Configuring Perl ... "

set "PATH=C:\strawberry\c\bin;C:\strawberry\perl\site\bin;C:\strawberry\perl\bin;%PATH%"

for /f "usebackq delims=" %%d in (`call perl -MConfig -e"print $Config{make}"`) do set make=%%d

echo done
