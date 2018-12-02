# log relevant environment variables
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\log.env.BAT"
if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }

set-PSdebug -off
exit $exit_val
