<# A very simple script to monitor the connected tape devices. 
If the count of expected devices drops below the set number, we write to the log and terminate the script.
The script checks every 10 seconds for the connected devices.
Every minute, it will log if All devices are successfully connected.
#>

param (
    [switch]$AllCheck = $false,
    [switch]$DriveCheck = $false,
	[switch]$Iscsi = $false,
	[switch]$Events = $false
    )
#Configuration variables. Adjust these as necessary for the environment
$logpath = "C:\temp\TapeMonitorLogging"
$logfilefullpath = "$logpath\TapeMonitorLog.log"
$Duration = "60480" #Value should be (total duration in seconds)/10. Default is 1 week. The script should not be aggressive, so feel free to run it for weeks even

function Write-Log {
    param(
        [string[]]$LogText
        )
	$logentry = "$(Get-Date) ::: "	
    Add-Content -Path $logfilefullpath -Value "$logentry $LogText"
    }

function Get-DeviceCount {
    $Drives = gwmi -Class Win32_TapeDrive
    $Changers = Get-WmiObject Win32_PnPSignedDriver | where {($_.DEVICECLASS -eq "MEDIUMCHANGER")}
    if($AllCheck){
		$DeviceNum = $Drives.Count + $Changers.Count
    }
    elseif($DriveCheck){
		$DeviceNum = $Drives.Count
	} else {
		$DeviceNum = $Changers.Count
	}
return $DeviceNum
}

function Get-IscsiInformation {
	$iscsiTargets = Get-IscsiTarget | Where-Object{$_.NodeAddress -like  "*vtl*" -or $_.NodeAddress -like "*amazon*"}
	Return $iscsiTargets
}

$WorkingCount = Get-DeviceCount
if($iscsi){$WorkingIscsi = Get-IscsiInformation}
if(!(Test-Path $logpath)){New-Item -ItemType Directory -Path $logpath | Out-Null}
Write-Log -LogText "Baseline Value: $WorkingCount"
Write-Log -LogText ((Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location) | Out-String)
Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | where {($_.DEVICECLASS -eq "MEDIUMCHANGER")} | Out-String)
Write-Log -LogText ($WorkingIscsi | Out-String)
Write-Host "Script has started monitoring. It will auto-stop once an issue is detected or after 1 week"
for($i=0;$i -lt "$Duration"; $i++){
	$TestCount = Get-DeviceCount
	if ($WorkingCount -gt $TestCount){
		Write-Log -LogText "One of the connected Devices has fallen offline"
		Write-Log -LogText "Windows was not able to see the device via the gwmi commands"
		Write-Log -LogText "The script will now terminate, please add this log to your case"
		Write-Log -LogText "Current Value: $TestCount"
		Write-Log -LogText ((Get-WmiObject Win32_PnPSignedDriver | Where-Object {($_.DEVICECLASS -eq "TapeDrive")} | Select-Object -Property Description, Location) | Out-String)
		Write-Log -LogText (Get-WmiObject Win32_PnPSignedDriver | where {($_.DEVICECLASS -eq "MEDIUMCHANGER")} | Out-String)
		if($iscsi){
			Write-Log -LogText "Current iscsi Target Status:"
			$CurrentIscsi = Get-IscsiInformation
			Write-Log -LogText ($CurrentIscsi | Out-String)
		}
		if($events){
				Write-Host -ForegroundColor Yellow "Getting Windows Events. This may take up to several minutes. For very active machines, it may take longer"
				[System.IO.Directory]::CreateDirectory("$logpath\Events") | Out-Null
				$Application=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='Application'").BackupEventLog("$logpath\Events\Application.evtx")
				$System=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='System'").BackupEventLog("$logpath\Events\System.evtx")
				#Events in CSV are only for the last 2 days.
				$ApplicationCSV=Get-EventLog -LogName Application -After (Get-Date).AddDays(-2) |  Select-Object eventID, entrytype, source, message, timegenerated | Export-Csv $logpath\Events\Application.csv
				$SystemCSV=Get-EventLog -LogName System -After (Get-Date).AddDays(-2) |  Select-Object eventID, entrytype, source, message, timegenerated | Export-Csv $logpath\Events\System.csv
				Write-Host -ForegroundColor Yellow "Done."
		}	
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