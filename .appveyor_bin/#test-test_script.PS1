# test-test_script phase
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $null -eq $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( $null -ne $env:CI_SKIP ) {
    write-host "info: testing not done (CI_SKIP enabled)"
} elseif ( $null -ne $env:CI_SKIP_TEST ) {
    write-host "info: testing not done (CI_SKIP_TEST enabled)"
} elseif ( $null -ne $env:OS_unsupported ) {
    write-host "info: testing not done (OS unsupported)"
} else {
    $test_cmd = if ( $null -ne $env:TEST_FILES ) { @($env:TEST_METHOD, $env:TEST_FILES) -join ' ' } else { $env:TEST_METHOD }
    write-host "[``$test_cmd``]"
    & 'CMD' ( '/x/c', "$test_cmd 2>&1" )
    if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
}

set-PSdebug -off
exit $exit_val
