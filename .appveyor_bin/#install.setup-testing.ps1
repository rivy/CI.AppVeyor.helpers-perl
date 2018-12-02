# setup TEST_METHOD and TEST_FILES
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

if ((! $env:TEST_METHOD) -and ($env:DIST_TOOLING -ieq "build")) { $env:TEST_METHOD = "perl Build test" }
if ((! $env:TEST_METHOD) -and ($env:DIST_TOOLING -ieq "make")) { $env:TEST_METHOD = "${env:make} test" }
if (! $env:TEST_METHOD) {
    $env:TEST_METHOD = "prove -bl"
    if (! $env:TEST_FILES) {
        $files = @()
        if ((get-item 't' -ea ignore) -is [IO.DirectoryInfo]) { $files += 't' }
        if ( $env:AUTHOR_TESTING -or $env:RELEASE_TESTING ) {
            if ((get-item 'xt' -ea ignore) -is [IO.DirectoryInfo]) { $files += 'xt' }
            }
        $env:TEST_FILES = $files -join " "
        }
}

set-PSdebug -off
