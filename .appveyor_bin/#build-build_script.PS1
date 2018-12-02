# build-build_script phase
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_SKIP ) {
    write-host "INFO: build not done (CI_SKIP enabled)"
} elseif ( $env:OS_unsupported ) {
    write-host "INFO: build not done (OS unsupported)"
} else {
    if ( $env:DIST_TOOLING -ieq 'build' ) {
        write-host "[``perl Build.PL``]"
        & "perl" @( "Build")
        $exit_val = $LASTEXITCODE
    }
    if ( $env:DIST_TOOLING -ieq 'make ' ) {
        write-host "[``${env:make}``]"
        & "${env:make}"
        $exit_val = $LASTEXITCODE
    }
}

set-PSdebug -off
exit $exit_val
