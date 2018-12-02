# determine repository tooling
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

if ( ! $env:DIST_TOOLING -and (Test-Path "build.PL") ) { $env:DIST_TOOLING = "build" }
if ( ! $env:DIST_TOOLING -and (Test-Path "Makefile.PL") ) { $env:DIST_TOOLING = "make" }

if ( $env:DIST_TOOLING -ieq "build" -and $($_=$(perl -MModule::Build -e "print Module::Build->VERSION()").Replace("_",""); $_ -lt 0.421) ) { write-host "WARN: using buggy early version of Module::Build ($_); consider requiring later version" -f yellow }

set-PSdebug -off
