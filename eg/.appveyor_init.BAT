:: configuration
@prompt $g$s &:: minimize output "noise"
@echo ON

set "DIST_SUPPRESS_DEPS=1"

if /i "%Perl_VERSION%" == "5.10"  ( set "CI_SKIP=true" )
if /i "%Perl_VERSION%" == "5.8.9" ( set "DIST_EXTRA_DEPS=parent" )
if /i "%Perl_VERSION%" == "5.8.8" ( set "OS_unsupported=true" )
if /i "%Perl_VERSION%" == "5.8"   ( set "OS_unsupported=true" )

@echo OFF
@echo.
