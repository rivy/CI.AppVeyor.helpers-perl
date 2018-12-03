# install ~ install any needed code coverage dependencies
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_HELPERS -eq $null ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( ($env:CI_SKIP -eq $null) -and ($env:OS_unsupported -eq $null) -and ($env:COVERAGE -ne $null) ) {
    # install coverage support
    & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', 'Devel::Cover' )
    if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    ($env:COVERAGE).split() | foreach {
        # echo "\"${env:CI_HELPERS}\cpanm-mods_only.BAT\" --no-interactive --no-man-pages --notest --quiet --skip-satisfied Devel::Cover::Report::$_"
        if ( $_ -ieq "Coveralls" ) {
            ## override for flawed default "Coveralls"; use patched version from personal github repo
            # "${env:CI_HELPERS}\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet --skip-satisfied https://github.com/rivy/perl.Devel-Cover-Report-Coveralls.git
            & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', 'https://github.com/rivy/perl.Devel-Cover-Report-Coveralls.git' )
            if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
        } else {
            # "${env:CI_HELPERS}\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet --skip-satisfied Devel::Cover::Report::$_
            & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', "Devel::Cover::Report::$_" )
            if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
        }
    }
}

set-PSdebug -off
exit $exit_val
