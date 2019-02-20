# install ~ install Perl binary package
if ( $null -ne $env:CI_DEBUG ) { set-PSdebug -trace 1 }

$exit_val = 0

if ( $null -eq $env:CI_HELPERS ) { $env:CI_HELPERS = [IO.Path]::GetFullPath(".") }

if ( $null -ne $env:CI_SKIP ) {
    write-host "info: perl install/config not done (CI_SKIP enabled)"
} elseif ( $null -ne $env:OS_unsupported ) {
    write-host "info: perl install/config not done (OS unsupported)"
} else {
    if ( $null -eq $env:perl_version ) { $env:perl_version = "latest" }

    ## refine "generic" perl versions
    if ( $env:perl_version -ieq "5.8.8" ) { $env:perl_version = "5.8.8.4" }
    if ( $env:perl_version -ieq "5.8.9" ) { $env:perl_version = "5.8.9.5" }
    if ( $env:perl_version -ieq "5.8" )   { $env:perl_version = "5.8.9.5" }
    if ( $env:perl_version -ieq "5.10" )  { $env:perl_version = "5.10.1.2" }
    if ( $env:perl_version -ieq "5.12" )  { $env:perl_version = "5.12.3.0" }
    if ( $env:perl_version -ieq "5.14" )  { $env:perl_version = "5.14.4.1" }
    if ( $env:perl_version -ieq "5.16" )  { $env:perl_version = "5.16.3.1" }
    if ( $env:perl_version -ieq "5.18" )  { $env:perl_version = "5.18.4.1" }
    if ( $env:perl_version -ieq "5.20" )  { $env:perl_version = "5.20.3.3" }
    if ( $env:perl_version -ieq "5.22" )  { $env:perl_version = "5.22.3.1" }
    if ( $env:perl_version -ieq "5.24" )  { $env:perl_version = "5.24.4.1" }
    if ( $env:perl_version -ieq "5.26" )  { $env:perl_version = "5.26.2.1" }
    if ( $env:perl_version -ieq "5.28" )  { $env:perl_version = "5.28.0.1" }

    ## "known" perl binaries
    # * StrawberryPerl direct download URIs
    $direct_URI = @{}
    $direct_URI['5.8.8.4']  = "http://strawberryperl.com/download/5.8.8/strawberry-perl-5.8.8.4.zip"
    $direct_URI['5.8.9.5']  = "http://strawberryperl.com/download/5.8.9/strawberry-perl-5.8.9.5.zip"
    $direct_URI['5.10.1.2'] = "http://strawberryperl.com/download/5.10.1.2/strawberry-perl-5.10.1.2-portable.zip"
    $direct_URI['5.12.3.0'] = "http://strawberryperl.com/download/5.12.3.0/strawberry-perl-5.12.3.0-portable.zip"
    $direct_URI['5.14.4.1'] = "http://strawberryperl.com/download/5.14.4.1/strawberry-perl-5.14.4.1-64bit-portable.zip"
    $direct_URI['5.16.3.1'] = "http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit-portable.zip"
    # ... perl versions after this are available via `cinst`
    $direct_URI['5.18.4.1'] = "http://strawberryperl.com/download/5.18.4.1/strawberry-perl-5.18.4.1-64bit-portable.zip"
    $direct_URI['5.20.3.3'] = "http://strawberryperl.com/download/5.20.3.3/strawberry-perl-5.20.3.3-64bit-portable.zip"
    $direct_URI['5.22.3.1'] = "http://strawberryperl.com/download/5.22.3.1/strawberry-perl-5.22.3.1-64bit-portable.zip"
    $direct_URI['5.24.4.1'] = "http://strawberryperl.com/download/5.24.4.1/strawberry-perl-5.24.4.1-64bit-portable.zip"
    $direct_URI['5.26.2.1'] = "http://strawberryperl.com/download/5.26.2.1/strawberry-perl-5.26.2.1-64bit-portable.zip"
    $direct_URI['5.28.0.1'] = "http://strawberryperl.com/download/5.28.0.1/strawberry-perl-5.28.0.1-64bit-portable.zip"
    $direct_URI['latest']   = $direct_URI['5.28.0.1']

    # * StrawberryPerl mirror download URIs
    $mirror_URI = @{}
    $mirror_URI['5.8.8.4']  = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.8.8.4.zip"
    $mirror_URI['5.8.9.5']  = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.8.9.5.zip"
    $mirror_URI['5.10.1.2'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.10.1.2-portable.zip"
    $mirror_URI['5.12.3.0'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.12.3.0-portable.zip"
    $mirror_URI['5.14.4.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.14.4.1-64bit-portable.zip"
    $mirror_URI['5.16.3.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.16.3.1-64bit-portable.zip"
    # ... perl versions after this are available via `cinst`
    $mirror_URI['5.18.4.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.18.4.1-64bit-portable.zip"
    $mirror_URI['5.20.3.3'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.20.3.3-64bit-portable.zip"
    $mirror_URI['5.22.3.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.22.3.1-64bit-portable.zip"
    $mirror_URI['5.24.4.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.24.4.1-64bit-portable.zip"
    $mirror_URI['5.26.2.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.26.2.1-64bit-portable.zip"
    $mirror_URI['5.28.0.1'] = "https://github.com/rivy/CI.AppVeyor.helpers-perl-binaries/releases/download/1.2018.0/strawberry-perl-5.28.0.1-64bit-portable.zip"
    $mirror_URI['latest']   = $mirror_URI['5.28.0.1']

    ## finalize source locations
    $perl_direct_URI = $direct_URI[ $env:perl_version ]
    $perl_mirror_URI = $mirror_URI[ $env:perl_version ]
    # # * some early versions are not available via `cinst` (generally only for certain earlier Perl versions)
    # $download_only = false
    # if ( $env:perl_version -ieq "5.8.8.4" ) { $download_only = true }
    # if ( $env:perl_version -ieq "5.10.1.2") { $download_only = true }

    ## setup download area (CI_CACHE_DIR availability is not assumed)
    $download_dir = $env:CI_CACHE_DIR
    if ( $null -eq $download_dir ) { $download_dir = $env:CI_TEMP_DIR }
    if ( $null -eq $download_dir ) { $download_dir = $env:TEMP }
    if ( $null -eq $download_dir ) { $download_dir = $env:TMP }
    if ( $null -eq $download_dir ) { $download_dir = "C:\." }
    $download_dir = "$download_dir\perl.download"
    if (-not $(get-item $download_dir -ea silent)) { new-item $download_dir -item directory | out-null }

    ## install
    write-host -nonewline "Installing Strawberry Perl "

    $cinst_options = "--yes"
    if ( $env:perl_version -ine "latest" ) { $cinst_options = "$cinst_options --version ${env:perl_version}" }

    $install_complete = $null

    if ( $null -ne $env:CI_DEBUG_PERL_INSTALL ) { $install_complete = $null }

    # * `cinst` is generally about 30s slower to install than via a direct download (and usually ends up downloading the binary from StrawberryPerl.com)
    # * ...> only attempt `cinst` for "latest" version (which may be more up-to-date) or when no direct URI is known
    if ( ($null -eq $install_complete) -and (($env:perl_version -ieq "latest") -or ($null -eq $perl_direct_URI)) ) {
        write-host -nonewline "(${env:perl_version}; via Chocolatey [``cinst $cinst_options StrawberryPerl``]) ... "
        $out = & 'CMD' @( '/x/c', "choco config set cacheLocation `"$download_dir`" 2>&1 && cinst $cinst_options StrawberryPerl 2>&1" )
        if (($LASTEXITCODE -ne 0) -or ($null -ne $env:CI_DEBUG)) { write-host ""; write-host $($out -join "`r`n") }
        if ($LASTEXITCODE -ne 0) {
            write-host "WARN: ``cinst`` of StrawberryPerl failed [ERRORLEVEL=$LASTEXITCODE]" -f yellow
        } else {
            $install_complete = "true.cinst"
            $env:PERL_DOWNLOAD_URI=""
        }
    }

    if ( $null -ne $env:CI_DEBUG_PERL_INSTALL ) { $install_complete = $null }

    if ( ($null -eq $install_complete) -and ($null -ne $perl_direct_URI) ) {
        write-host -nonewline "(${env:perl_version}; from '$perl_direct_URI') ... "
        $out = & 'CMD' @( '/x/c', "curl -# -fL `"$perl_direct_URI`" -o `"$download_dir\perl-${env:perl_version}.zip`" 2>&1 && call 7z -bd -y x `"$download_dir\perl-${env:perl_version}.zip`" -oc:\strawberry 2>&1" )
        if (($LASTEXITCODE -ne 0) -or ($null -ne $env:CI_DEBUG)) { write-host ""; write-host $($out -join "`r`n") }
        if ($LASTEXITCODE -ne 0) {
            write-host "WARN: direct download Perl failed [ERRORLEVEL=$LASTEXITCODE]" -f yellow
        } else {
            $install_complete = "true.direct"
            $env:PERL_DOWNLOAD_URI = $perl_direct_URI
        }
    }

    if ( $null -ne $env:CI_DEBUG_PERL_INSTALL ) { $install_complete = $null }

    if ( ($null -eq $install_complete) -and ($null -ne $perl_mirror_URI) ) {
        write-host -nonewline "(${env:perl_version}; from '$perl_mirror_URI') ... "
        $out = & 'CMD' @( '/x/c', "curl -# -fL `"$perl_mirror_URI`" -o `"$download_dir\perl-${env:perl_version}.zip`" 2>&1 && call 7z -bd -y x `"$download_dir\perl-${env:perl_version}.zip`" -oc:\strawberry 2>&1" )
        if (($LASTEXITCODE -ne 0) -or ($null -ne $env:CI_DEBUG)) { write-host ""; write-host $($out -join "`r`n") }
        if ($LASTEXITCODE -ne 0) {
            write-host "WARN: mirror download Perl failed [ERRORLEVEL=$LASTEXITCODE]" -f yellow
        } else {
            $install_complete = "true.mirror"
            $env:PERL_DOWNLOAD_URI = $perl_mirror_URI
        }
    }

    if ( $null -eq $install_complete ) {
        write-host "ERR!: installation of Perl FAILED" -f red
        $exit_val = 1
    } else {
        write-host "done"

        ## configure
        write-host -nonewline "Configuring Perl ... "

        $env:PATH = "C:\strawberry\c\bin;C:\strawberry\perl\site\bin;C:\strawberry\perl\bin;${env:PATH}"

        $env:make = $(& 'CMD' @('/x/c', 'perl -MConfig -e "print $Config{make}" 2>NUL') )
        if ( $LASTEXITCODE -ne 0 ) { $exit_val = $LASTEXITCODE }

        write-host "done"
    }
}

set-PSdebug -off
exit $exit_val
