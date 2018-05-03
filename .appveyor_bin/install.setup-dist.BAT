@echo off
if DEFINED CI_DEBUG ( echo on )
set "ERRORLEVEL=" &:: UN-pin ERRORLEVEL

if DEFINED DIST_SUPPRESS_DEPS if NOT DEFINED COVERAGE if NOT DEFINED DIST_EXTRA_DEPS ( echo INFO: skipping dependency testing/installation & goto :_check_OS_unsupported_ )
if NOT DEFINED DIST_TOOLING if NOT DEFINED COVERAGE if NOT DEFINED DIST_EXTRA_DEPS ( echo INFO: skipping dependency testing/installation for non-build/make distribution & goto :_install_extras_ )

::# * install `cpanm` (needed for older perl versions)
echo [%TIME%] ### install `cpanm`
call cpan -T -i App::cpanminus
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
echo [%TIME%] ### install basic modules with "issues"
::# * pre-install problematic modules (especially for perl versions < 5.14)
::#   'ExtUtils::MakeMaker' ## (CORE module)
::#   - for perl versions < 5.14, installing ExtUtils::MakeMaker >= 7.0 causes ... "The system cannot find the path specified.\ndmake.exe:  Error code 129, while making 'blib\lib\ExtUtils\.exists'"
::#   - for perl versions = 5.12, installing ExtUtils::MakeMaker >= 7.0 causes ... "Use of inherited AUTOLOAD for non-method Win32::GetConsoleCP() is deprecated at C:/strawberry/perl/site/lib/ExtUtils/MakeMaker/Locale.pm line 50."
call perl -e "use version; use ExtUtils::MakeMaker; exit -1 if version->parse($ExtUtils::MakeMaker::VERSION) < version->parse(q{7.0});" >NUL 2>&1 || call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet ExtUtils::MakeMaker~"< 7.0" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::#   'version' ## (CORE module since perl v5.9)
::#   - updated version needed for many installs
::#   - 'version' requires 'parent' (missing requirement on some 0.9915+ versions, specifically 0.9918 [most recent on 2018-01-20])
::#   - 'version 0.9919' breaks on perl v5.10 thru v5.20
call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet parent version~"< 0.9919" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::#   'ExtUtils::ParseXS' ## (CORE module since perl v5.8.9)
::#   - updated ParseXS needed to install File::Spec (o/w PathTools installation fails with "Cwd.o:Cwd.c:(.text+0x593): undefined reference to `croak_xs_usage'")
call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet ExtUtils::ParseXS~">= 3.35" 2>&1
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

if DEFINED DIST_SUPPRESS_DEPS ( goto :_check_OS_unsupported_ )
if NOT DEFINED DIST_TOOLING ( goto :_install_extras_ )

::# install baseline dependencies
echo [%TIME%] ### install distribution dependencies
call cpanm --no-interactive --no-man-pages --notest --quiet --skip-satisfied --installdeps .
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

::# check OS_unsupported
:_check_OS_unsupported_
echo [%TIME%] ### OS_unsupported ?
if /I "%DIST_TOOLING%"=="build" (
    set "_DIST_PREBUILDER=perl Build.PL"
  ) else (
    set "_DIST_PREBUILDER=perl Makefile.PL"
  )
call %_DIST_PREBUILDER% 2>&1 | findstr /b /i /r "OS unsupported\b" >NUL 2>&1 && set "OS_unsupported=OS unsupported" || set "OS_unsupported="
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
set "_DIST_PREBUILDER="

if DEFINED OS_unsupported ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )

::# install any "extra" requested dependencies
:_install_extras_
if DEFINED DIST_EXTRA_DEPS ( echo [%TIME%] ### install "extra" modules )
if DEFINED DIST_EXTRA_DEPS ( call "%CI_HELPERS%\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet %DIST_EXTRA_DEPS% 2>&1 )
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )

if DEFINED DIST_SUPPRESS_DEPS ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )
if NOT DEFINED DIST_TOOLING ( goto _undefined_ 2>NUL || CMD /d /c exit 0 )

::# install any further optional dependencies
echo [%TIME%] ### install recommended modules
call cpanm --no-interactive --no-man-pages --notest --quiet --skip-satisfied --with-recommends --installdeps .
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
::
echo [%TIME%] ### # ... HACK for `cpanm` overlooking "test_recommends"
::# note: `cpanm` will sometimes overlook "test_recommends" modules; this bug is reproducible but only occurs for some distributions
::# * HACK `cpanm`, creating a faux distribution directory with a minimal "Makefile.PL" and META build information
echo [%TIME%] ### # ... .... create faux distribution
set "_dir=%TEMP%\%APPVEYOR_JOB_ID%\cpanm-rec-hack"
if EXIST "%_dir%" ( rmdir /s/q "%_dir%" )
mkdir "%_dir%"
copy cpanfile "%_dir%" >NUL 2>&1 || cd . &:: suppress any error
copy META.* "%_dir%" >NUL 2>&1 || cd . &:: suppress any error
copy MYMETA.* "%_dir%" >NUL 2>&1 || cd . &:: suppress any error
pushd "%_dir%"
echo use ExtUtils::MakeMaker; WriteMakefile(); > Makefile.PL    &:: create minimal Makefile.PL
echo [%TIME%] ### # ... .... re-run `cpanm`
call cpanm --no-interactive --no-man-pages --notest --quiet --skip-satisfied --with-recommends --installdeps ExtUtils::MakeMaker~"< 7.0" .
popd
