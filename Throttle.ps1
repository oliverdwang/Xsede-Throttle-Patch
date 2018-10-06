# $xtu_path = 'C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client\XTUCli.exe'
# $status = get-service -name "XTU3SERVICE" | Select-Object {$_.status} | format-wide
# if ($status -ne "Running") { start-service -name "XTU3SERVICE"}
# Undervolt Settings in mV
# & $xtu_path -t -id 34 -v -110
# Long Boost Settings in Watts
# & $xtu_path -t -id 48 -v 19
# Short Boost Settings in Watts
# & $xtu_path -t -id 47 -v 25
# Boost Time Settings in seconds (max 96)
# & $xtu_path -t -id 66 -v 96

stop-process -id $PID -force