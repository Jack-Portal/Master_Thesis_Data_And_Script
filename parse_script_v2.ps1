$non_parsed_file = '.\test1_Compliant\Log_Compliant_test1.csv'
$parsed_file = '.\test1_Compliant\Log_Compliant_test1_parsed.csv'

$non_parsed = Get-Content -Path $non_parsed_file
$parsed = Get-Content -Path $parsed_file

$parsing_dict = @{}


'''
for ($i = 0; $i -lt $parsed.Count; $i +=1 ){
    if ($non_parsed[$i] -ne $parsed[$i]){
        Write-Host $parsed[$i]
    }
}'''

for ($i = 0; $i -lt $parsed.Count; $i +=1 ){
    if ($non_parsed[$i].StartsWith(" 	Path:")){
        $key = $non_parsed[$i]
    }
    if ($parsed[$i].StartsWith(" 	Path:")){
        $parsing_dict[$key] = $parsed[$i]
    }
}

$dict_save_file = '.\parsing_dict.txt'

foreach($key in $parsing_dict.Keys){
    Add-Content -Path $dict_save_file -Value ($key + ' SPLIT_PARSE_DICT ' + $parsing_dict[$key])
}

$new_dict = @{}

foreach($line in (Get-Content -Path $dict_save_file)){
    $val = $line.Substring(($line.IndexOf(' SPLIT_PARSE_DICT ') + ' SPLIT_PARSE_DICT '.Length))
    $key = $line.Substring(0, $line.IndexOf(' SPLIT_PARSE_DICT '))
    $new_dict[$key] = $val
}

foreach($key in $new_dict.Keys){
    Write-Host '>-------------------------------'
    Write-Host $key
    Write-Host $parsing_dict[$key]
    Write-Host '-------------------------------<'
    Write-Host ''
}


#$export_file = '.\Export_test_1_compliant_log.csv'
#$parsed_export_file = '.\Export_test_1_compliant_log_parsed.csv'#
#
#$export = Get-Content -Path $export_file#
#
#
#foreach($l in $export){
#    if ($parsing_dict[$l]){
#            Write-Host '>SUBSTITUTION-------------------'
#        Write-Host $l
#        Write-Host $parsing_dict[$l]
#        Write-Host '-------------------------------<'
#        Write-Host ''
#        Add-Content -Path $parsed_export_file -Value $parsing_dict[$l]
#    }
#    else {
#        Add-Content -Path $parsed_export_file -Value $l
#    }
#}
#
#'''