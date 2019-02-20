# install ~ install any needed code coverage dependencies
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $null -eq $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( ($null -eq $env:CI_SKIP) -and ($null -eq $env:OS_unsupported) -and ($null -ne $env:COVERAGE) ) {
    # install coverage support
    & "${env:CI_HELPERS}\cpanm-mods_only.BAT" @( '--no-interactive', '--no-man-pages', '--notest', '--quiet', '--skip-satisfied', 'Devel::Cover' )
    if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }
    ($env:COVERAGE).split() | foreach {
        # echo "\"${env:CI_HELPERS}\cpanm-mods_only.BAT\" --no-interactive --no-man-pages --notest --quiet --skip-satisfied Devel::Cover::Report::$_"
        if ( "$_".trim() -ieq "Coveralls" ) {
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
