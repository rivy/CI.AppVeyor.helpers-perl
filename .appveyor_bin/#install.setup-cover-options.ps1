# setup DEVEL_COVER_OPTIONS
# * options used by `cover`
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

if (! $env:DEVEL_COVER_OPTIONS) {
	$options = @()
	if ( $env:DIST_TOOLING -ieq "build" ) { $options += '-ignore,^_build/' }
	if ( ! $env:DIST_TOOLING ) {
		if ((get-item 't' -ea ignore) -is [IO.DirectoryInfo]) { $options += '-ignore,^t/' }
		if ((get-item 'xt' -ea ignore) -is [IO.DirectoryInfo]) { $options += '-ignore,^xt/' }
		}
    $env:DEVEL_COVER_OPTIONS = $options -join ","
}

set-PSdebug -off
