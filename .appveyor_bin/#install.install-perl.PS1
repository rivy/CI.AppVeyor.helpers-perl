# install ~ install Perl binary package
if ( $env:CI_DEBUG -ne $null ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $env:CI_HELPERS -eq $null ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

& "${env:CI_HELPERS}\#install.install-perl.BAT"
if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }

## configure
write-host -nonewline "Configuring Perl ... "

$env:PATH = "C:\strawberry\c\bin;C:\strawberry\perl\site\bin;C:\strawberry\perl\bin;${env:PATH}"

$env:make = $(& 'CMD' @('/x/c', 'perl -MConfig -e "print $Config{make}" 2>NUL') )
if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }

write-host "done"

set-PSdebug -off
exit $exit_val
