# determine repository tooling
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

if ( ! $env:DIST_TOOLING -and (Test-Path "build.PL") ) { $env:DIST_TOOLING = "build" }
if ( ! $env:DIST_TOOLING -and (Test-Path "Makefile.PL") ) { $env:DIST_TOOLING = "make" }

set-PSdebug -off
