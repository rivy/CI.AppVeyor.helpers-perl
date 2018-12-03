# build-before_build phase
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_HELPERS -eq $null ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( ( $env:CI_SKIP -eq $null ) -and ( $env:OS_unsupported -eq $null ) )  {
    if ( $env:DIST_TOOLING -ieq 'build' ) {
        write-host "[``perl Build.PL``]"
        & 'CMD' @( '/x/c', "perl Build.PL 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
    if ( $env:DIST_TOOLING -ieq 'make ' ) {
        write-host "[``perl Makefile.PL``]"
        & 'CMD' @( '/x/c', "perl Makefile.PL 2>&1" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
}

set-PSdebug -off
exit $exit_val
