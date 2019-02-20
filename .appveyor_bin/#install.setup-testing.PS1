# install ~ setup TEST_METHOD and TEST_FILES
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if (($null -eq $env:TEST_METHOD) -and ("${env:DIST_TOOLING}".trim() -ieq "build")) { $env:TEST_METHOD = "perl Build test" }
if (($null -eq $env:TEST_METHOD) -and ("${env:DIST_TOOLING}".trim() -ieq "make")) { $env:TEST_METHOD = "${env:make} test" }
if ($null -eq $env:TEST_METHOD) {
    # use `perl -S prove -bl` instead of `prove -bl`; increases robustness by avoiding buggy pl2bat in some perl versions (specifically, Perl v5.12)
    $env:TEST_METHOD = "perl -S prove -bl"
    if ($null -eq $env:TEST_FILES) {
        $files = @()
        if ((get-item 't' -ea ignore) -is [IO.DirectoryInfo]) { $files += 't' }
        if ( $env:AUTHOR_TESTING -or $env:RELEASE_TESTING ) {
            if ((get-item 'xt' -ea ignore) -is [IO.DirectoryInfo]) { $files += 'xt' }
            }
        $env:TEST_FILES = $files -join " "
        }
}

set-PSdebug -off
exit $exit_val
