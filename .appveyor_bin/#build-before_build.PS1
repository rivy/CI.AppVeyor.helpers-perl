# build-before_build phase
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_HELPERS -eq $null ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( ( $env:CI_SKIP -ne $null ) -or ( $env:OS_unsupported -ne $null ) )  {
    if ( $env:DIST_TOOLING -ieq 'build' ) {
        write-host "[``perl Build.PL``]"
        & "perl" @( "Build.PL" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
    if ( $env:DIST_TOOLING -ieq 'make ' ) {
        write-host "[``perl Makefile.PL``]"
        & "perl" @( "Makefile.PL" )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    }
}

set-PSdebug -off
exit $exit_val
