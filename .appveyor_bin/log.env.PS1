# log relevant environment variables
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }
if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#log.env.BAT"

set-PSdebug -off
