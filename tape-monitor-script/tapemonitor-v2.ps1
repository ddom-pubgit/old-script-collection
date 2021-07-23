<# A very simple script to monitor the connected tape devices. 
If the count of expected devices drops below the set number, we write to the log and terminate the script.
The script checks every 10 seconds for the connected devices.
Every minute, it will log if All devices are successfully connected.
#>

param (
    [switch]$DriveCheck = $false,
	[switch]$iscsi = $false,
	[switch]$events = $false
    )
#Configuration variables. Adjust these as necessary for the environment

$logfilefullpath = "C:\temp\TapeMonitorLog.log"
$logpath = "C:\temp"
$Duration = "60480" #Value should be (total duration in seconds)/10. Default is 1 week. The script should not be aggressive, so feel free to run it for weeks even

function Write-Log {
    param(
        [string[]]$LogText
        )
	$logentry = "$(Get-Date) ::: "	
    Add-Content -Path $logfilefullpath -Value "$logentry $LogText"
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
if(!(Test-Path $logpath)){New-Item -ItemType Directory -Path $logpath}
Write-Log -LogText "Baseline Value: $WorkingCount"
Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location)
Write-Log -LogText (gwmi -Namespace root\wmi -Class mschangerparameters)

for($i=0;$i -lt "$Duration"; $i++){
$TestCount = Get-DeviceCount
	if ($WorkingCount -gt $TestCount){
		if($iscsi){
			
		Write-Log -LogText "One of the connected Devices has fallen offline"
		Write-Log -LogText "Windows was not able to see the device via the gwmi commands"
		Write-Log -LogText "The script will now terminate, please add this log to your case"
		Write-Log -LogText "Current Value: $TestCount"
		Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location)
		Write-Log -LogText (gwmi -Namespace root\wmi -Class mschangerparameters)s
		if($events){
				Write-Host -ForegroundColor Yellow "Getting Windows Events. This may take up to several minutes. For very active machines, it may take longer"
				[System.IO.Directory]::CreateDirectory("$logpath\Events") | Out-Null
				$Application=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='Application'").BackupEventLog("$logpath\Events\Application.evtx")
				$System=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='System'").BackupEventLog("$logpath\Events\System.evtx")
				#Events in CSV are only for the last 2 days.
				$ApplicationCSV=Get-EventLog -LogName Application -After (Get-Date).AddDays(-2) |  select eventID, entrytype, source, message, timegenerated | Export-Csv $logpath\Events\Application.csv
				$SystemCSV=Get-EventLog -LogName System -After (Get-Date).AddDays(-2) |  select eventID, entrytype, source, message, timegenerated | Export-Csv $logpath\Events\System.csv
				Write-Host -ForegroundColor Yellow "Done."
		}	
		explorer.exe $logfilefullpath
		exit
	}
	elseif($i % 6 -eq "0"){
		Write-Log -LogText "All Devices Connected"
		Start-sleep 10
		}
    else {
    start-sleep 10}
	}