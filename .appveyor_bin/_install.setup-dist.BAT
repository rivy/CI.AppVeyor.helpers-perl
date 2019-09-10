@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL=" &:: UN-pin ERRORLEVEL

set _CPAN_VERBOSITY=--quiet
if DEFINED CI_DEBUG ( set _CPAN_VERBOSITY=--verbose )
if NOT DEFINED CI_HELPERS set "CI_HELPERS=%~dp0"

if DEFINED CI_SKIP ( echo info: build not done ^(CI_SKIP enabled^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED OS_unsupported ( echo info: setup not done ^(OS unsupported^) & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if DEFINED DIST_SUPPRESS_DEPS if NOT DEFINED COVERAGE if NOT DEFINED DIST_EXTRA_DEPS ( echo info: skipping dependency discovery/installation [DIST_SUPPRESS_DEPS=%DIST_SUPPRESS_DEPS%] & goto :_check_OS_unsupported_ )
if NOT DEFINED DIST_TOOLING if NOT DEFINED COVERAGE if NOT DEFINED DIST_EXTRA_DEPS if NOT EXIST "cpanfile" ( echo info: skipping dependency discovery/installation for non-build/make/cpanfile distribution & goto _undefined_ 2>NUL || CMD /d /c exit 0 )

if DEFINED DIST_SUPPRESS_DEPS if DEFINED COVERAGE ( echo info: dependency suppression disabled for coverage [COVERAGE=%COVERAGE%] )
if DEFINED DIST_SUPPRESS_DEPS if DEFINED DIST_EXTRA_DEPS ( echo info: dependency suppression disabled for extra dependencies [DIST_EXTRA_DEPS=%DIST_EXTRA_DEPS%] )

echo [%TIME%] ### install basic modules with "issues"
::# * pre-install problematic modules (especially for perl versions < 5.14)
::#   'ExtUtils::MakeMaker' ## (CORE module)
::#   - for perl versions < 5.14, installing ExtUtils::MakeMaker >= 7.0 causes ... "The system cannot find the path specified.\ndmake.exe:  Error code 129, while making 'blib\lib\ExtUtils\.exists'"
::#   - for perl versions = 5.12, installing ExtUtils::MakeMaker >= 7.0 causes ... "Use of inherited AUTOLOAD for non-method Win32::GetConsoleCP() is deprecated at C:/strawberry/perl/site/lib/ExtUtils/MakeMaker/Locale.pm line 50."
::#   - for perl versions <= 5.10, installing ExtUtils::MakeMaker < 6.98 causes various odd failures (eg, "! Installing ExtUtils::MakeMaker failed. ... Retry with --force to force install it.").
::#   - for perl versions > 5.24, the default make type was changed to `gmake` and ExtUtils::MakeMaker works without issue
::# [2019-05] fixes for these problems [<https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/pull/332>] were committed/released in v7.35_12
REM if /i NOT "%make%"=="gmake" ( set EUMM_version=ExtUtils::MakeMaker~">=6.98, <7.0" ) else ( set "EUMM_version=" )
if /i NOT "%make%"=="gmake" ( set EUMM_version=ExtUtils::MakeMaker~">=7.36" ) else ( set "EUMM_version=" )
REM call perl -e "use version; use ExtUtils::MakeMaker; exit -1 if version->parse($ExtUtils::MakeMaker::VERSION) < version->parse(q{7.0});" >NUL 2>&1 || call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% ExtUtils::MakeMaker~"< 7.0" 2>&1
if DEFINED EUMM_version call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::#   'Module::Build' ## (CORE module since perl v5.9.4)
::#   - updated version needed for many installs with older META info formats
call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% Module::Build~">= 0.421" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::#   'version' ## (CORE module since perl v5.9)
::#   - updated version needed for many installs
::#   - 'version' requires 'parent' (missing requirement on some 0.9915+ versions, specifically 0.9918 [most recent on 2018-01-20])
::#   - 'version 0.9919' breaks on perl v5.10 thru v5.20
call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% parent version~">= 0.9924" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::#   'ExtUtils::ParseXS' ## (CORE module since perl v5.8.9)
::#   - updated ParseXS needed to install File::Spec (o/w PathTools installation fails with "Cwd.o:Cwd.c:(.text+0x593): undefined reference to `croak_xs_usage'")
call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% ExtUtils::ParseXS~">= 3.35" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

::# install any "extra" requested dependencies (installed prior to baseline dependencies; may be needed for configuration)
if DEFINED DIST_EXTRA_DEPS ( echo [%TIME%] ### install "extra" modules )
if DEFINED DIST_EXTRA_DEPS (
    echo `call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% %DIST_EXTRA_DEPS%`
    call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied %EUMM_version% %DIST_EXTRA_DEPS%
    )
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

if NOT DEFINED DIST_TOOLING if NOT EXIST "cpanfile" ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED DIST_SUPPRESS_DEPS ( goto :_check_OS_unsupported_ )

if NOT DEFINED DIST_TOOLING ( set "_CPAN_VERBOSITY=" ) &:: # "normal" verbosity for "cpanfile" dependency installation

::
::# install baseline dependencies
echo [%TIME%] ### install distribution dependencies
echo `call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --installdeps %EUMM_version% . 2>&1`
call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --installdeps %EUMM_version% . 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

echo [%TIME%] ### HACK ~ create faux distribution; (fixes `cpanm` overlooking "test_requires" and "test_recommends")
::# note: `cpanm` will sometimes overlook "test_requires" and/or "test_recommends" modules; this bug is reproducible but only occurs for some distributions
::# * HACK `cpanm`, creating a faux distribution directory with a minimal "Makefile.PL" and META build information
set "_faux_dir=%TEMP%\%APPVEYOR_JOB_ID%\cpanm-rec-hack"
if EXIST "%_faux_dir%" ( rmdir /s/q "%_faux_dir%" )
mkdir "%_faux_dir%"
copy cpanfile "%_faux_dir%" >NUL 2>&1 || cd . &:: suppress any error
copy MYMETA.* "%_faux_dir%" >NUL 2>&1 || cd . &:: suppress any error
::# * overwrite MYMETA from META, if present, as a better source
copy META.json "%_faux_dir%"\MYMETA.json >NUL 2>&1 || cd . &:: suppress any error
copy META.yml "%_faux_dir%"\MYMETA.yml >NUL 2>&1 || cd . &:: suppress any error
pushd "%_faux_dir%"
echo. > Makefile.PL &:: create empty Makefile.PL
echo. > Makefile    &:: create empty Makefile
popd
::

::# re-check/install baseline dependencies
echo [%TIME%] ### re-check/install distribution dependencies
pushd "%_faux_dir%" &:: use faux distribution
echo `call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --installdeps %EUMM_version% . 2>&1`
call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --installdeps %EUMM_version% . 2>&1
popd
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

::# check OS_unsupported
:_check_OS_unsupported_
echo [%TIME%] ### OS_unsupported ?
if /i "%DIST_TOOLING%"=="build" (
    set "_DIST_PREBUILDER=perl Build.PL"
  ) else (
    set "_DIST_PREBUILDER=perl Makefile.PL"
  )
call %_DIST_PREBUILDER% 2>&1 | call findstr /b /i /r "OS unsupported\b" >NUL 2>&1 && set "OS_unsupported=OS unsupported" || set "OS_unsupported="
:: * cleanup Build.PL products to avoid possible later version mismatch with an updated Module::Build
if /i "%DIST_TOOLING%"=="build" (
    call "perl" Build realclean 2>&1 >NUL
    )
set "_DIST_PREBUILDER="

if DEFINED OS_unsupported ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED DIST_SUPPRESS_DEPS ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if DEFINED DIST_SUPPRESS_RECS ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )

::# install any further optional dependencies
echo [%TIME%] ### install recommended modules
pushd "%_faux_dir%" &:: use faux distribution
echo `call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --with-recommends --installdeps %EUMM_version% . 2>&1`
call "%CI_HELPERS%\cpanm.BAT" --no-interactive --no-man-pages --notest %_CPAN_VERBOSITY% --skip-satisfied --with-recommends --installdeps %EUMM_version% . 2>&1
popd
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
