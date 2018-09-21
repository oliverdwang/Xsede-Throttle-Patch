#USER SETTINGS
$xtu_path = 'C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client\XTUCli.exe' #Directory
$run_once = $false #Boolean
$static_bat_update_rate = 30 #Seconds
$static_ac_update_rate = 5 #Seconds
$undervolt = -80 #Millivolts
$bat_long_boost = 15 #Watts
$bat_short_boost = 25 #Watts
$bat_boost_time = 96 #Seconds, max 96
$ac_long_boost = 15 #Watts
$ac_short_boost = 25 #Watts
$ac_boost_time = 96 #Seconds, max 96

#ADVANCED SETTINGS
#If the sum of all CPU utilization percentages is less than this value
#AND the actual TDP is lower than what is defined above, reset values
$aggregate_utilization_trigger = 100


#END OF SETTINGS

#Check if on battery
$isBattery=$false
$isBattery = (Get-WmiObject -Class Win32_Battery -ea 0).BatteryStatus

#Start XTU CLI interface
$status = get-service -name "XTU3SERVICE" | Select-Object {$_.status} | format-wide
if ($status -ne "Running") { start-service -name "XTU3SERVICE"}

#Undervolt on initial run
& $xtu_path -t -id 34 -v $undervolt

do {
    #Get current TDP
    $TDP = & $xtu_path -t -id 1000

    #Get current CPU utilization
    $util_core_0 = & $xtu_path -t -id 90
    $util_core_1 = & $xtu_path -t -id 91
    $util_core_2 = & $xtu_path -t -id 92
    $util_core_3 = & $xtu_path -t -id 93
    $util_sum = $util_core_0 + $util_core_1 + $util_core_2 + $util_core_3

	if($isBattery -eq $true) {
		# If running on battery
        
        #If the current TDP is less than or equal to the user set TDPs AND any core is at >aggregate_utilization_trigger%, reset values
        if((($TDP -le $bat_long_boost) -or ($TDP -le $bat_short_boost)) -and ($util_sum -ge $aggregate_utilization_trigger)) {
            #Set long boost
		    & $xtu_path -t -id 48 -v $bat_long_boost
		    #Set short boost
		    & $xtu_path -t -id 47 -v $bat_short_boost
		    #Set boost time
		    & $xtu_path -t -id 66 -v $bat_boost_time
        }
        
        #If user only wants to run once, skip delay
        if($run_once -eq $false) {
            Start-Sleep $static_bat_update_rate
        }
	} else {
		#If running on AC

        if((($TDP -le $ac_long_boost) -or ($TDP -le $ac_short_boost)) -and ($util_sum -ge $aggregate_utilization_trigger)) {
		    #Set long boost
		    & $xtu_path -t -id 48 -v $ac_long_boost
	    	#Set short boost
		    & $xtu_path -t -id 47 -v $ac_short_boost
		    #Set boost time
		    & $xtu_path -t -id 66 -v $ac_boost_time
        }
        
        #If user only wants to run once, skip delay
        if($run_once -eq $false) {
            Start-Sleep $static_ac_update_rate
        }
	}
} while ($run_once -eq $false)

#If user only wants to run once, program will exit loop and stop
stop-process -id $PID -force