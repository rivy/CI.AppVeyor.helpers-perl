# log relevant environment variables
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

write-host ""

$CI_vars = @(
    # configuration environment variables
    # * user config vars
    'AUTHOR_TESTING', 'RELEASE_TESTING',
    'TEST_ALL', 'TEST_AUTHOR', 'TEST_RELEASE',
    # # * configuration variables
    # 'AUTOMATED_TESTING',
    # 'COVERAGE',
    # 'CI_CACHE_DIR',
    # 'CI_DEBUG', 'CI_DEBUG_PERL_INSTALL',
    # 'CI_HELPER_API_VERSION',
    # 'CI_HELPER_BRANCH', 'CI_HELPER_REPO', 'CI_HELPERS',
    # 'CI_TEMP_DIR',
    # 'CI_SKIP', 'CI_SKIP_TEST',
    # 'DEVEL_COVER_OPTIONS',
    # 'DIST_EXTRA_DEPS','DIST_SUPPRESS_DEPS', 'DIST_SUPPRESS_RECS',
    # 'DIST_TOOLING',
    # 'HARNESS_OPTIONS','HARNESS_PERL_SWITCHES', 'HARNESS_TIMER'
    # 'make',
    # 'OS_unsupported',
    # 'PERL5OPT',
    # 'TEST_FILES', 'TEST_METHOD'
    @()
    );
$output=false
$CI_vars |% { if ( $_ -ne $null ) { $val = $(get-item env:$_ -ea silent).value; if ( $val -ne $null ) { write-host "$_=$val"; $output=true } } }
if ( $output ) { write-host "." }

$CI_vars = @(
    # configuration environment variables
    # # * user config vars
    # 'AUTHOR_TESTING', 'RELEASE_TESTING',
    # 'TEST_ALL', 'TEST_AUTHOR', 'TEST_RELEASE',
    # * configuration variables
    'AUTOMATED_TESTING',
    'COVERAGE',
    'CI_CACHE_DIR',
    'CI_DEBUG', 'CI_DEBUG_PERL_INSTALL',
    'CI_HELPER_API_VERSION',
    'CI_HELPER_BRANCH', 'CI_HELPER_REPO', 'CI_HELPERS',
    'CI_TEMP_DIR',
    'CI_SKIP', 'CI_SKIP_TEST',
    'DEVEL_COVER_OPTIONS',
    'DIST_EXTRA_DEPS','DIST_SUPPRESS_DEPS', 'DIST_SUPPRESS_RECS',
    'DIST_TOOLING',
    'HARNESS_OPTIONS','HARNESS_PERL_SWITCHES', 'HARNESS_TIMER'
    'make',
    'OS_unsupported',
    'PERL5OPT',
    'TEST_FILES', 'TEST_METHOD',
    @()
    );
$CI_vars |% { if ( $_ -ne $null ) { $val = $(get-item env:$_ -ea silent).value; write-host "$_=$val" } }

write-host ""

set-PSdebug -off
exit $exit_val
