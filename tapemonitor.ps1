<# A very simple script to monitor the connected tape devices. 
If the count of expected devices drops below the set number, we write to the log and terminate the script.
The script checks every 10 seconds for the connected devices.
Every minute, it will log if All devices are successfully connected.
#>

param (
    [switch]$DriveCheck = $false
    )
#Configuration variables. Adjust these as necessary for the environment

$logpath = "C:\temp\TapeMonitorLog.log"
$Duration = "60480" #Value should be (total duration in seconds)/10. Default is 1 week. The script should not be aggressive, so feel free to run it for weeks even

function Write-Log {
    param(
        [string[]]$LogText
        )
	$logentry = "$(Get-Date) ::: "	
    Add-Content -Path $logpath -Value "$logentry $LogText"
    }

function Get-DeviceCount {
	if($DriveCheck){
		$Drives = gwmi -Class Win32_TapeDrive
		$DeviceNum = $Drives.Count
	} else {
		$Changers = gwmi -Namespace root\wmi -Class mschangerparameters
		$DeviceNum = $Changers.Count
	}
return $DeviceNum
}

$WorkingCount = Get-DeviceCount

Write-Log -LogText "Baseline Value: $WorkingCount"
Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location)
Write-Log -LogText (gwmi -Namespace root\wmi -Class mschangerparameters)

for($i=0;$i -lt "$Duration"; $i++){
$TestCount = Get-DeviceCount
	if ($WorkingCount -gt $TestCount){
		Write-Log -LogText "One of the connected Devices has fallen offline"
		Write-Log -LogText "Windows was not able to see the device via the gwmi commands"
		Write-Log -LogText "The script will now terminate, please add this log to your case"
		Write-Log -LogText "Current Value: $TestCount"
		Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location)
		Write-Log -LogText (gwmi -Namespace root\wmi -Class mschangerparameters)s
		explorer.exe $logpath
		exit
	}
	elseif($i % 6 -eq "0"){
		Write-Log -LogText "All Devices Connected"
		Start-sleep 10
		}
    else {
    start-sleep 10}
	}