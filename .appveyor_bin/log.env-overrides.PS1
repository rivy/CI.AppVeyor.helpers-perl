# highlight any non-default (ie, non-null) environment vars (from the set of configuration vars)
# ref: http://www.powertheshell.com/input_psv3 @@ https://archive.is/D7z8m
# ref: https://kevinmarquette.github.io/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about @@ https://archive.is/Ln6cg

@($Input) | & {

  $data_a = @($Input)
  #write-host "count = $($data_a.count)"
  if ( $data_a.count -eq 0 ) { $data_a = @(get-childitem env:) }
  $data = @{}
  $data_a |% { $data[$_.key]=$_.value }

  $vars = @(
    # * configuration environment variables expected to be null
    # 'AUTOMATED_TESTING',
    'AUTHOR_TESTING', 'RELEASE_TESTING',
    'TEST_ALL', 'TEST_AUTHOR', 'TEST_RELEASE',
    'COVERAGE',
    # 'CI_CACHE_DIR',
    'CI_DEBUG', 'CI_DEBUG_PERL_INSTALL',
    # 'CI_HELPER_API_VERSION',
    'CI_HELPER_BRANCH', 'CI_HELPER_REPO', 'CI_HELPERS',
    'CI_TEMP_DIR',
    'CI_SKIP', 'CI_SKIP_TEST',
    'DEVEL_COVER_OPTIONS',
    'DIST_EXTRA_DEPS','DIST_SUPPRESS_DEPS','DIST_TOOLING',
    'HARNESS_OPTIONS','HARNESS_PERL_SWITCHES', 'HARNESS_TIMER'
    'PERL5OPT',
    'OS_unsupported',
    'TEST_FILES', 'TEST_METHOD'
    );

  $overrides = @();

  #$vars |% { $v = (get-item env:$_ -ea silent).value; if ($v -ne $null) { $overrides += "$_=$v" }}
  $vars |% { $v = $data[$_]; if ($v -ne $null) { $overrides += "$_=$v" }}

  if ( $overrides ) { write-host -fore yellow $($(@("") + $overrides + @("")) -join "`r`n") }

}
