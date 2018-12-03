# build-build_script phase
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $null -ne $env:CI_SKIP ) {
    write-host "info: build not done (CI_SKIP enabled)"
} elseif ( $null -ne $env:OS_unsupported ) {
    write-host "info: build not done (OS unsupported)"
} else {
    if ( $env:DIST_TOOLING -ieq 'build' ) {
        write-host "[``perl Build``]"
        & 'CMD' @( '/x/c', "perl Build 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
    if ( $env:DIST_TOOLING -ieq 'make ' ) {
        write-host "[``${env:make}``]"
        & 'CMD' @( '/x/c', "${env:make} 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
}

set-PSdebug -off
exit $exit_val
