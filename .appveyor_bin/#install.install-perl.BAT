@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL="

:: NOTE: contains some peculiar statement ordering and redirections b/c of AppVeyor bugs when executing BAT/CMD scripts

if DEFINED CI_SKIP ( echo INFO: perl install/config not done ^(CI_SKIP enabled^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED OS_unsupported ( echo INFO: perl install/config not done ^(OS unsupported^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if not defined perl_version ( set "perl_version=latest" )

:: ## refine "generic" perl versions
if "%perl_version%"=="5.8.8" ( set "perl_version=5.8.8.4" )
if "%perl_version%"=="5.8.9" ( set "perl_version=5.8.9.5" )
if "%perl_version%"=="5.8"   ( set "perl_version=5.8.9.5" )
if "%perl_version%"=="5.10"  ( set "perl_version=5.10.1.2" )
if "%perl_version%"=="5.12"  ( set "perl_version=5.12.3.0" )
if "%perl_version%"=="5.14"  ( set "perl_version=5.14.4.1" )
if "%perl_version%"=="5.16"  ( set "perl_version=5.16.3.1" )
if "%perl_version%"=="5.18"  ( set "perl_version=5.18.4.1" )
if "%perl_version%"=="5.20"  ( set "perl_version=5.20.3.3" )
if "%perl_version%"=="5.22"  ( set "perl_version=5.22.3.1" )
if "%perl_version%"=="5.24"  ( set "perl_version=5.24.4.1" )
if "%perl_version%"=="5.26"  ( set "perl_version=5.26.2.1" )
if "%perl_version%"=="5.28"  ( set "perl_version=5.28.0.1" )

:: ## "known" perl binaries
:: StrawberryPerl direct download URIs
set "_perl_download_URI_5.8.8.4=http://strawberryperl.com/download/5.8.8/strawberry-perl-5.8.8.4.zip"
set "_perl_download_URI_5.8.9.5=http://strawberryperl.com/download/5.8.9/strawberry-perl-5.8.9.5.zip"
set "_perl_download_URI_5.10.1.2=http://strawberryperl.com/download/5.10.1.2/strawberry-perl-5.10.1.2-portable.zip"
set "_perl_download_URI_5.12.3.0=http://strawberryperl.com/download/5.12.3.0/strawberry-perl-5.12.3.0-portable.zip"
set "_perl_download_URI_5.14.4.1=http://strawberryperl.com/download/5.14.4.1/strawberry-perl-5.14.4.1-64bit-portable.zip"
set "_perl_download_URI_5.16.3.1=http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit-portable.zip"
:: * perl versions after this are available via `cinst`
set "_perl_download_URI_5.18.4.1=http://strawberryperl.com/download/5.18.4.1/strawberry-perl-5.18.4.1-64bit-portable.zip"
set "_perl_download_URI_5.20.3.3=http://strawberryperl.com/download/5.20.3.3/strawberry-perl-5.20.3.3-64bit-portable.zip"
set "_perl_download_URI_5.22.3.1=http://strawberryperl.com/download/5.22.3.1/strawberry-perl-5.22.3.1-64bit-portable.zip"
set "_perl_download_URI_5.24.4.1=http://strawberryperl.com/download/5.24.4.1/strawberry-perl-5.24.1.1-64bit-portable.zip"
set "_perl_download_URI_5.26.2.1=http://strawberryperl.com/download/5.26.2.1/strawberry-perl-5.26.2.1-64bit-portable.zip"
set "_perl_download_URI_5.28.0.1=http://strawberryperl.com/download/5.28.0.1/strawberry-perl-5.28.0.1-64bit-portable.zip"
set "_perl_download_URI_latest=%_perl_download_URI_5.28.0.1%"

:: StrawberryPerl mirror download URIs
set "_perl_mirror_URI_5.8.8.4=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.8.8.4.zip"
set "_perl_mirror_URI_5.8.9.5=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.8.9.5.zip"
set "_perl_mirror_URI_5.10.1.2=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.10.1.2-portable.zip"
set "_perl_mirror_URI_5.12.3.0=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.12.3.0-portable.zip"
set "_perl_mirror_URI_5.14.4.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.14.4.1-64bit-portable.zip"
set "_perl_mirror_URI_5.16.3.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.16.3.1-64bit-portable.zip"
:: * perl versions after this are available via `cinst`
set "_perl_mirror_URI_5.18.4.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.18.4.1-64bit-portable.zip"
set "_perl_mirror_URI_5.20.3.3=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.20.3.3-64bit-portable.zip"
set "_perl_mirror_URI_5.22.3.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.22.3.1-64bit-portable.zip"
set "_perl_mirror_URI_5.24.4.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.24.4.1-64bit-portable.zip"
set "_perl_mirror_URI_5.26.2.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.26.2.1-64bit-portable.zip"
set "_perl_mirror_URI_5.28.0.1=https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.28.0.1-64bit-portable.zip"
set   "_perl_mirror_URI_latest=%_perl_mirror_URI_5.28.0.1%"

:: ## determine direct download file (as needed and available [generally only for certain earlier perl versions])
set "direct_download_only="
if "%perl_version%"=="5.8.8.4"  ( set "direct_download_only=true" )
if "%perl_version%"=="5.8.9.5"  ( set "direct_download_only=true" )
if "%perl_version%"=="5.10.1.2" ( set "direct_download_only=true" )
if "%perl_version%"=="5.12.3.0" ( set "direct_download_only=true" )
if "%perl_version%"=="5.14.4.1" ( set "direct_download_only=true" )
if "%perl_version%"=="5.16.3.1" ( set "direct_download_only=true" )
:: * perl versions after this are available via `cinst`

call set "perl_download_URI=%%_perl_download_URI_%perl_version%%%"
REM call set "perl_download_mirror_URI=%_perl_download_URI_:http://strawberryperl.com/download/=http://mirror.dom/folder/%"
call set "perl_mirror_URI=%%_perl_mirror_URI_%perl_version%%%"

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

set "install_complete="

if defined install_complete goto :install_via_cinst_DONE
if defined direct_download_only goto :install_via_cinst_DONE
set "ERRORLEVEL="
echo|set /p OUTPUT="(%perl_version%; via Chocolatey [`cinst %cinst_options% StrawberryPerl`]) ... "
call choco config set cacheLocation "%_DL_DIR%" >NUL
call cinst %cinst_options% StrawberryPerl | rem # script fails here if STDOUT redirected to NUL [AppVeyor bug]
if not "%ERRORLEVEL%"=="0" ( echo. & echo WARN: `cinst` of Perl failed [ERRORLEVEL=%ERRORLEVEL%] ) else ( set "install_complete=true.cinst" )
:install_via_cinst_DONE

if defined CI_DEBUG_PERL_INSTALL ( set "install_complete=" )

if defined install_complete goto :install_via_direct_download_DONE
if not defined perl_download_URI goto :install_via_direct_download_DONE
set "ERRORLEVEL="
echo|set /p OUTPUT="(%perl_version%; direct download from '%perl_download_URI%') ... "
call curl -# -fL "%perl_download_URI%" -o "%_DL_DIR%\perl-%perl_version%.zip" >NUL 2>&1 && call 7z -bd -y x "%_DL_DIR%\perl-%perl_version%.zip" -oc:\strawberry >NUL
if not "%ERRORLEVEL%"=="0" ( echo. & echo WARN: direct download of Perl failed [ERRORLEVEL=%ERRORLEVEL%] ) else ( set "install_complete=true.direct" )
:install_via_direct_download_DONE

if defined CI_DEBUG_PERL_INSTALL ( set "install_complete=" )

if defined install_complete goto :install_via_mirror_download_DONE
if not defined perl_mirror_URI goto :install_via_mirror_download_DONE
set "ERRORLEVEL="
echo|set /p OUTPUT="(%perl_version%; mirror download from '%perl_mirror_URI%') ... "
call curl -# -fL "%perl_mirror_URI%" -o "%_DL_DIR%\perl-%perl_version%.zip" >NUL 2>&1 && call 7z -bd -y x "%_DL_DIR%\perl-%perl_version%.zip" -oc:\strawberry >NUL
if not "%ERRORLEVEL%"=="0" ( echo. & echo WARN: mirror download of Perl failed [ERRORLEVEL=%ERRORLEVEL%] ) else ( set "install_complete=true.mirror" )
:install_via_mirror_download_DONE

if not defined install_complete ( echo ERR!: installation of Perl FAILED & goto _undefined_ 2>NUL || CMD /x/d/c exit -1 )
echo done

REM :: ## configure
REM echo|set /p OUTPUT="Configuring Perl ... "

REM set "PATH=C:\strawberry\c\bin;C:\strawberry\perl\site\bin;C:\strawberry\perl\bin;%PATH%"

REM for /f "usebackq delims=" %%d in (`call perl -MConfig -e"print $Config{make}"`) do set make=%%d

REM echo done
