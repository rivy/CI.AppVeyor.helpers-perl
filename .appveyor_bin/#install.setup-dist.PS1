# install ~ setup distribution (dependencies, ...)
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }
if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#install.setup-dist.BAT"

if ( $env:DIST_TOOLING -ieq 'build' -and $($_=$(perl -MModule::Build -e "print Module::Build->VERSION()").Replace("_",""); $_ -lt 0.421) ) { write-host $("WARN: using flawed early version of Module::Build ($_); consider requiring later version") -f yellow }

set-PSdebug -off
