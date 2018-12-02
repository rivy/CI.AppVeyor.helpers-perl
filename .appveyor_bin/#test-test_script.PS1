# test-test_script phase
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }
if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#test-test_script.BAT"

set-PSdebug -off
