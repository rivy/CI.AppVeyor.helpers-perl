# test-test_script phase
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( $env:CI_SKIP ) {
    write-host "info: testing not done (CI_SKIP enabled)"
} elseif ( $env:CI_SKIP_TEST ) {
    write-host "info: testing not done (CI_SKIP_TEST enabled)"
} elseif ( $env:OS_unsupported ) {
    write-host "info: testing not done (OS unsupported)"
} else {
    $test_cmd = @($env:TEST_METHOD, $env:TEST_FILES) -join ' '
    write-host "[``$test_cmd``]"
    & "$env:TEST_METHOD" @( "$env:TEST_FILES" )
    if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
}

set-PSdebug -off
exit $exit_val
