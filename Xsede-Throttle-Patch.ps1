#USER SETTINGS
$xtu_path = 'C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client\XTUCli.exe'
$static_bat_update_rate = 30 #Seconds
$static_ac_update_rate = 5 #Seconds
$undervolt = -80 #Millivolts
$bat_long_boost = 15 #Watts
$bat_short_boost = 25 #Watts
$bat_boost_time = 96 #Seconds, max 96
$ac_long_boost = 15 #Watts
$ac_short_boost = 25 #Watts
$ac_boost_time = 96 #Seconds, max 96

#Check if on battery
$isBattery=$false
$isBattery = (Get-WmiObject -Class Win32_Battery -ea 0).BatteryStatus

#Start XTU CLI interface
$status = get-service -name "XTU3SERVICE" | Select-Object {$_.status} | format-wide
if ($status -ne "Running") { start-service -name "XTU3SERVICE"}

#Undervolt on initial run
& $xtu_path -t -id 34 -v $undervolt

while($true)
{
	if(isBattery -eq $true)
	{
		# If running on battery
		Start-Sleep $static_bat_update_rate
		# Set long boost
		& $xtu_path -t -id 48 -v $bat_long_boost
		# Set short boost
		& $xtu_path -t -id 47 -v $bat_short_boost
		# Set boost time
		& $xtu_path -t -id 66 -v $bat_boost_time
	} else {
		#If running on AC
		Start-Sleep $static_ac_update_rate
		# Set long boost
		& $xtu_path -t -id 48 -v $ac_long_boost
		# Set short boost
		& $xtu_path -t -id 47 -v $ac_short_boost
		# Set boost time
		& $xtu_path -t -id 66 -v $ac_boost_time
	}
	
	#Apply settings
	stop-process -id $PID -force
}