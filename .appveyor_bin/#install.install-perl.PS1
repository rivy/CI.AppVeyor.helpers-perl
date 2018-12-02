# install ~ install Perl binary package
if ( $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( ! $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#install.install-perl.BAT"
if ( $LASTEXITCODE -neq 0 ) { $exit_val = $LASTEXITCODE }

## configure
write-host -nonewline "Configuring Perl ... "

$env:PATH = "C:\strawberry\c\bin;C:\strawberry\perl\site\bin;C:\strawberry\perl\bin;${env:PATH}"

$env:make = $(& "perl" @('-MConfig', '-e', '"print $Config{make}"') )
if ( $LASTEXITCODE -neq 0 ) { $exit_val = $LASTEXITCODE }

write-host "done"

set-PSdebug -off
exit $exit_val
