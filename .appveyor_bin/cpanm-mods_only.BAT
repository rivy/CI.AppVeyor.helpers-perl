@setlocal
@echo off
if DEFINED CI_HELPER_DEBUG ( echo on )
set "ERRORLEVEL="

:: cpanm-mods-only == CPANM MODuleS ONLY

:: * issue: local filenames can conflict with module names, confusing `cpanm`
::  ...fix: run `cpanm` out-of-source, in an empty temporary directory, forcing all arguments to be interpreted as modules

:: create empty TEMP directory
set "tmp_dir=%CI_TEMP_DIR%\empty-dir-for-cpanm"
if EXIST "%tmp_dir%" ( rmdir /s/q "%tmp_dir%" )
mkdir "%tmp_dir%"

:: change to non-conflicting environment
cd "%tmp_dir%"

call cpanm %*
if NOT "%ERRORLEVEL%"=="0" ( goto _undefined_ 2>NUL || CMD /d /c exit %ERRORLEVEL% )
