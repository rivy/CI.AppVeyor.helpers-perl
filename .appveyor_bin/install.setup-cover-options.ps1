# setup DEVEL_COVER_OPTIONS

if (! $env:DEVEL_COVER_OPTIONS) {
	$options = @()
	if ( $env:DIST_TOOLING -ieq "build" ) { $options += '-ignore,^_build/' }
	if ( ! $env:DIST_TOOLING ) {
		if ((get-item 't' -ea ignore) -is [IO.DirectoryInfo]) { $options += $options += '-ignore,^t/' }
		if ((get-item 'xt' -ea ignore) -is [IO.DirectoryInfo]) { $options += $options += '-ignore,^xt/' }
		}
    $env:DEVEL_COVER_OPTIONS = $options -join ","
    # write-host "env:COVERAGE = $env:COVERAGE"
}
