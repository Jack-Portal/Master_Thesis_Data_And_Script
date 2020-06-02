$logs = Import-Csv -Path '.\Log_Compliant_parsed_l2.csv'
$services = Get-Content -Path '.\all_services_compliant_l2.txt'
$prereq = Get-Content -Path '.\check_prereq_l2.txt'
$ports = Get-Content -Path '.\compliant_port_l2.txt'
$tests = Get-Content -Path '.\all_atomic_tests_run_2.txt'
$scan = Import-Csv -Path '.\Windows_advanced_scan_compliant_l2.csv'

$output_path = '.\Analysis_Output_l2.txt'

function WriteFile{
    param(  [String]$Value,
            [String]$Path = $output_path  )
    Add-Content -Path $Path -Value $Value
}

$levels_count = @{}
$sources_count = @{}
$tasks_count = @{}
$atomic = 0

foreach($line in $logs){
    if ($line.Level -in $levels_count.Keys){
        $levels_count[$line.Level] += 1
    } else {
        $levels_count[$line.Level] = 1
    }

    if ($line.Source -in $sources_count.Keys){
        $sources_count[$line.Source] += 1
    } else {
        $sources_count[$line.Source] = 1
    }

    if ($line.'Task Category' -in $tasks_count.Keys){
        $tasks_count[$line.'Task Category'] += 1
    } else {
        $tasks_count[$line.'Task Category'] = 1
    }

    if ($line.'More Information'.Contains('Atomic')){
        $atomic += 1
    }
    else { if ($line.'More Information'.Contains('atomic')){
        $atomic += 1
    }
    else { if ($line.'More Information'.Contains('ATOMIC')){
        $atomic += 1
    }}}
}

WriteFile -Value 'Log Analysis:'

WriteFile -Value ('Events : ' + $logs.Count)
WriteFile -Value ('Containing Atomic : ' + $atomic)
WriteFile -Value ''
WriteFile -Value 'Levels:'
foreach($l in $levels_count.Keys){
    WriteFile -Value ($l + ' : ' + $levels_count[$l])
}
WriteFile -Value ''
WriteFile -Value 'Sources:'
foreach($s in $sources_count.Keys){
    WriteFile -Value ($s + ' : ' + $sources_count[$s])
}
WriteFile -Value ''
WriteFile -Value 'Tasks: '
foreach($t in $tasks_count.Keys){
    WriteFile -Value ($t + ' : ' + $tasks_count[$t])
}

#-----------------------------------------------------------

$running = 0
$stopped = 0

foreach($line in $services){
    if ($line.StartsWith('Running')){
        $running += 1
    } else {
        $stopped += 1
    }
}

WriteFile -Value ''
WriteFile -Value ''
WriteFile -Value 'Services Analysis:'
WriteFile -Value ''
WriteFile -Value ('Running : ' + $running)
WriteFile -Value ('Stopped : ' + $stopped)

#-----------------------------------------------------------

$UDP = 0
$TCP = 0

foreach($line in $ports){
    if ($line.StartsWith('  TCP')){
        $TCP += 1
    } else {
        if ($line.StartsWith('  UDP')){
            $UDP += 1
        }
    }
}

WriteFile -Value ''
WriteFile -Value ''
WriteFile -Value 'Ports Analysis:'
WriteFile -Value ''
WriteFile -Value ('All : ' + ($UDP + $TCP))
WriteFile -Value ('TCP : ' + $TCP)
WriteFile -Value ('UDP : ' + $UDP)

#-----------------------------------------------------------

$met = 0
$not = 0

foreach($line in $prereq){
    if ($line.StartsWith('Prerequisites met:')){
        $met += 1
    } else {
        if ($line.StartsWith('Prerequisites not met:')){
            $not += 1
        }
    }
}

WriteFile -Value ''
WriteFile -Value ''
WriteFile -Value 'Prereq Analysis:'
WriteFile -Value ''
WriteFile -Value ('Met : ' + $met)
WriteFile -Value ('Not Met : ' + $not)

#-----------------------------------------------------------

$timeout = 0
$e = 0
$done = 0

foreach($line in $tests){
    if ($line.StartsWith('Done executing test:')){
        $done += 1
    } else {
        if ($line.Contains('TerminatingError')){
            $e += 1
            $done -= 1
        } else {
            if ($line.StartsWith('Process Timed out after 15 seconds')){
                $timeout += 1
                $done -= 1
            }
        }
    }
}

WriteFile -Value ''
WriteFile -Value ''
WriteFile -Value 'Test Analysis:'
WriteFile -Value ''
WriteFile -Value ('Done : ' + $done)
WriteFile -Value ('Error : ' + $e)
WriteFile -Value ('Timeout : ' + $timeout)

#-----------------------------------------------------------

$Risk_count = @{}

foreach($line in $scan){
    if ($line.Risk -in $Risk_count.Keys){
        $Risk_count[$line.Risk] += 1
    } else {
        $Risk_count[$line.Risk] = 1
    }
}

WriteFile -Value ''
WriteFile -Value ''
WriteFile -Value 'Scan Analysis:'
WriteFile -Value ''
WriteFile -Value 'Vulnerabilities:'
foreach($r in $Risk_count.Keys){
    if ($r -ne 'None'){
        WriteFile -Value ($r + ' : ' + $Risk_count[$r])
    }
}
WriteFile -Value ''
WriteFile -Value 'Informative Results:'
WriteFile -Value ('None : ' + $Risk_count['None'])