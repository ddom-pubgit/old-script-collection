<# A very simple script to monitor the connected tape changers. 
If the count of expected changers drops below the set number, we write to the log and terminate the script.
The script checks every 10 seconds for the connected devices.
Every minute, it will log if both devices are successfully connected.
Editing to check for drives is simple, just change the gwmi query to fetch drives:
gwmi -Class Win32_TapeDrive
#>

for($i=0;$i -lt '60480'; $i++){
$params = gwmi -Namespace root\wmi -Class mschangerparameters
if (!($params.Length -eq '2')){
	add-content -path 'C:\temp\tapemonitor.log'	-value (Get-Date)
	add-content -path 'C:\temp\tapemonitor.log' -value "$($params.InstanceName)"
	add-content -path 'C:\temp\tapemonitor.log' -value "This is the only connected Library"
	add-content -path 'C:\temp\tapemonitor.log' -value "Windows was not able to see the other connected device"
    add-content -path 'C:\temp\tapemonitor.log' -value "The script will now terminate, please provide the log to Veeam"
    explorer.exe "C:\temp"
    exit
	}
	elseif($i % 6 -eq '0'){
		add-content -path 'C:\temp\tapemonitor.log'	-value (Get-Date)
		add-content -path 'C:\temp\tapemonitor.log'	-value "Both Libraries Connected"
		Start-sleep 10
		}
    else {
    start-sleep 10}
	}