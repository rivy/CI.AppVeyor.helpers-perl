# test-test_script phase
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& CMD @('/x/c', "${env:CI_HELPERS}\#test-test_script.BAT 2>&1" )
if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }

set-PSdebug -off
exit $exit_val
