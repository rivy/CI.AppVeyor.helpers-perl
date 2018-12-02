# install ~ install Perl binary package
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }
if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#install.install-perl.BAT"

set-PSdebug -off
