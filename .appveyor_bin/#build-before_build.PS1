# build-before_build phase
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $null -eq $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( ( $null -eq $env:CI_SKIP ) -and ( $null -eq $env:OS_unsupported ) )  {
    if ( "${env:DIST_TOOLING}".trim() -ieq 'build' ) {
        write-host "[``perl Build.PL``]"
        & 'CMD' @( '/x/c', "perl Build.PL 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
    if ( "${env:DIST_TOOLING}".trim() -ieq 'make' ) {
        write-host "[``perl Makefile.PL``]"
        & 'CMD' @( '/x/c', "perl Makefile.PL 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
}

set-PSdebug -off
exit $exit_val
