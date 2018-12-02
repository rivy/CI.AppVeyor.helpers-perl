# install ~ setup distribution (dependencies, ...)
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }
if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#install.setup-dist.BAT"

set-PSdebug -off
