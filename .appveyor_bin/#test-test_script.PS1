# test-test_script phase
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_HELPERS -eq $null ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( $env:CI_SKIP -ne $null ) {
    write-host "info: testing not done (CI_SKIP enabled)"
} elseif ( $env:CI_SKIP_TEST -ne $null ) {
    write-host "info: testing not done (CI_SKIP_TEST enabled)"
} elseif ( $env:OS_unsupported -ne $null ) {
    write-host "info: testing not done (OS unsupported)"
} else {
    $test_cmd = if ( $env:TEST_FILES -ne $null ) { @($env:TEST_METHOD, $env:TEST_FILES) -join ' ' } else { $env:TEST_METHOD }
    write-host "[``$test_cmd``]"
    & 'CMD' ( '/x/c', "$test_cmd 2>&1" )
    if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
}

set-PSdebug -off
exit $exit_val
