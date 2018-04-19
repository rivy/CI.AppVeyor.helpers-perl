# check code coverage

if ($env:COVERAGE) {
    # determine coverage support (signaled by <COVERAGE_TYPE>_TOKEN environment vars)
    $s = $env:COVERAGE
    $coverage = @()
    $s.split() | foreach {
        $name = "env:\"+$_.ToUpper()+"_TOKEN"
        $val = (get-item $("env:\"+$_.ToUpper()+"_TOKEN") -ea ignore).value
        # write-host "$name = '$val'"
        # write-host "`$val.length = $($val.length)"
        if ($val.length -gt 0) {
            $coverage += $_
            write-host "info: '$_' coverage is configured and enabled"
          } else { write-host -f yellow "info: skipping '$_' coverage (missing '$($_.ToUpper() + '_TOKEN')')" }
        }
    $env:COVERAGE = $coverage -join " "
    # write-host "env:COVERAGE = $env:COVERAGE"
}
