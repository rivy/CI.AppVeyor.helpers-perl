# build-build_script phase
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_SKIP -ne $null ) {
    write-host "info: build not done (CI_SKIP enabled)"
} elseif ( $env:OS_unsupported -ne $null ) {
    write-host "info: build not done (OS unsupported)"
} else {
    if ( $env:DIST_TOOLING -ieq 'build' ) {
        write-host "[``perl Build.PL``]"
        & "perl" @( "Build" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
    if ( $env:DIST_TOOLING -ieq 'make ' ) {
        write-host "[``${env:make}``]"
        & "${env:make}"
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
}

set-PSdebug -off
exit $exit_val
