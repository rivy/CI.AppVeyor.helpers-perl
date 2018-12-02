# install ~ install any needed code coverage dependencies
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if (-not $env:CI_SKIP -and -not $env:OS_unsupported -and $env:COVERAGE) {
    # install coverage support
    & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', 'Devel::Cover' )
    if ( $LASTEXITCODE -neq 0 ) { $exit_val = $LASTEXITCODE }
    ($env:COVERAGE).split() | foreach {
        # echo "\"${env:CI_HELPERS}\cpanm-mods_only.BAT\" --no-interactive --no-man-pages --notest --quiet --skip-satisfied Devel::Cover::Report::$_"
        if ( $_ -ieq "Coveralls" ) {
            ## override for flawed default "Coveralls"; use patched version from personal github repo
            # "${env:CI_HELPERS}\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet --skip-satisfied https://github.com/rivy/perl.Devel-Cover-Report-Coveralls.git
            & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', 'https://github.com/rivy/perl.Devel-Cover-Report-Coveralls.git' )
            if ( $LASTEXITCODE -neq 0 ) { $exit_val = $LASTEXITCODE }
        } else {
            # "${env:CI_HELPERS}\cpanm-mods_only.BAT" --no-interactive --no-man-pages --notest --quiet --skip-satisfied Devel::Cover::Report::$_
            & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', "Devel::Cover::Report::$_" )
            if ( $LASTEXITCODE -neq 0 ) { $exit_val = $LASTEXITCODE }
        }
    }
}

set-PSdebug -off
exit $exit_val
