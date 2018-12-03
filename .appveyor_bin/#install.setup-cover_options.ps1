# install ~ setup DEVEL_COVER_OPTIONS
# * options used by `cover`
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:DEVEL_COVER_OPTIONS -eq $null ) {
	$options = @()
	if ( $env:DIST_TOOLING -ieq "build" ) { $options += '-ignore,^_build/' }
	if ( $env:DIST_TOOLING -eq $null ) {
		if ((get-item 't' -ea ignore) -is [IO.DirectoryInfo]) { $options += '-ignore,^t/' }
		if ((get-item 'xt' -ea ignore) -is [IO.DirectoryInfo]) { $options += '-ignore,^xt/' }
		}
    $env:DEVEL_COVER_OPTIONS = $options -join ","
}

set-PSdebug -off
exit $exit_val
