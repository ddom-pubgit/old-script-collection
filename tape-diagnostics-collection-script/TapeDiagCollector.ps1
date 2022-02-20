#################
##Version 1.1.3##
#################

param (
    [switch]$AllEventLogs = $false
    )
	
function End-Script {
		Write-Host -ForegroundColor Yellow "The log collection is complete. Please add the folder $Tapelogs to an archive (.zip, .7z), located in  $LogPath, and upload the archive to the FTP provided by Veeam Technical Support"	
		Explorer.exe $LogPath
}	
	
#Check for .Net 4.5
$NetValid = $false
$NetChk = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 378389
If ($NetChk -eq $true){ $NetValid = $true }

#Set Version
$scriptversion = "1.1.3"

Start-Sleep 1
Write-Warning -Message "This script is provided as is as a courtesy for collecting logs and Registry Entries related to SCSI devices from the Tape Server. Please be aware that due to certain Microsoft Operations, there may be a short burst of high CPU activity, and that some Windows Versions and GPOs may affect script execution. There is no support provided for this script; if it fails, we ask that you please proceed to collect the required information manually as instructed by your Support Engineer"
Start-Sleep 1
Write-Host "`nChecking elevation rights"
Start-Sleep 1
#Checking elevation rights 
if (!(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Write-Host -ForegroundColor Yellow "You're running PowerShell without elevated rights. Please open a PowerShell window as an Administrator. Shell will close in 10 seconds automatically."
  Start-Sleep 10
  Exit
}
else {Write-Host -ForegroundColor Green "You're running PowerShell as an Administrator. Starting data collection."}


#Create log directory entries
$LogPath="C:\Temp"
$LogName="TapeDiagnosticLogs" +"_$scriptversion" +"_$((Get-Date).ToString("ddMMyyyy"))"
$TapeLogs=$LogPath+'\'+$LogName
$RegkeyExports=$TapeLogs+'\'+'REGKEYS'
$TapeSVCPath ="C:\Program Files (x86)\Veeam\Backup Tape"
$TapeSVCDumpFolder=$TapeLogs+'\'+'TapeSVCDump'
$GWMICommands=$TapeLogs+'\'+'GMWIOutputs'
$EventsFolder=$TapeLogs+'\'+'Events'

#Checking for C:\Temp presence
if(!(Test-Path $LogPath)){
   Write-Host -ForegroundColor Red "C:\Temp folder is not found. Creating it to store temporary files"
   [System.IO.Directory]::CreateDirectory($LogPath) | Out-Null
}

#Checking for Tape Service
if(!(Test-Path $TapeSVCPath)){
   Write-Host -ForegroundColor Red "The Normal Veeam Tape Service Path $TapeSVCPath is not found. Please ensure the script is being run on the tape server requested by Veeam Support"
   Remove-Item $TapeLogs -ErrorAction SilentlyContinue
   #STOP HERE
   Exit
} 

#Creating TapeDiagnosticLogs folder
if (Test-Path $TapeLogs) {Remove-Item $TapeLogs -Force -Recurse -ErrorAction SilentlyContinue}
[system.io.directory]::CreateDirectory($TapeLogs) | Out-Null


#############################
#### tape service dump ######
#############################

Write-Host -ForegroundColor Yellow "Collecting Veeam Tape Service Dump"
[System.IO.Directory]::CreateDirectory($TapeSvcDumpFolder) | Out-Null
$SvcDumpProcessTime = Measure-Command {Start-Process -NoNewWindow -WorkingDirectory $TapeSVCPath -FilePath $TapeSVCPath\VeeamTapeSvc.exe -ArgumentList '-dump' -Wait}
New-Item -Path $TapeSvcDumpFolder\Processing_time_seconds_$($SvcDumpProcessTime.Seconds) | out-null
#Above will be temporary debug stuff for awhile, just curious on how long this actually takes.
#probably can remove this sleep now :/
sleep 1
###TODO - probably, I need to figure out how to set a timeout for the above since sometiems TapeService can get stuck. ###
$dumpresult = Get-item $TapeSVCPath\dumpinformation.xml
if (($dumpresult.Length/1KB) -lt "2"){
	Set-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value 'The script has detected that the dump.xml is unusually small.'
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value 'Please note how long the manual service dump takes'
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value 'Still check the tape dump - if you have a standalone drive, it will be small and you can disregard this message'
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value "Also check the GWMICommands\ChangerData.log and GWMICommands\ChangerInfo.log -- it is expected that changers without a driver will not show here"
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value "If they show as unknown device, then it means we're using native SCSI commands and that there is no changer driver installed in most cases."
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value "You need to validate from the other (check svc.veeamtape and also the above two script logs) what the tape hardware setup is"
	Add-Content -Path "$TapeSVCDumpFolder\READTHISIFYOUSEEIT.log" -Value 'If the above does not apply, Please report this to David Domask, and run the tape svc dump manually as administrator'
	Get-Childitem $TapeSVCPath\dumpinformation.xml | Copy-Item -Destination $TapeSvcDumpFolder}
else {	Get-Childitem $TapeSVCPath\dumpinformation.xml | Copy-Item -Destination $TapeSvcDumpFolder }
Write-Host -ForegroundColor Yellow "Done"

#############################
#### GWMI Command Outputs####
#############################

Write-Host -ForegroundColor Yellow "Collecting Driver and Tape Information (Errors during this step may be safely ignored)"
[System.IO.Directory]::CreateDirectory($GWMICommands) | Out-Null
gwmi -Class Win32_TapeDrive | out-file $GWMICommands\TapeInfo.log
gwmi -Class Win32_PnPEntity | ? {$_.deviceid -match "changer" } | out-file $GWMICommands\ChangerInfo.log
gwmi -Namespace root\wmi -Class mschangerparameters | out-file $GWMICommands\ChangerData.log
driverquery /v /fo csv | out-file $GWMICommands\drivers.csv
#I think the above is not so useful since we mostly care about the medium changer + device drivers. 
Get-WmiObject Win32_PnPSignedDriver | where {($_.DEVICECLASS -eq "MEDIUMCHANGER" -or $_.DEVICECLASS -eq "TapeDrive")} | out-file $GWMICommands\TapeDriverOutput.log

#############################
#### regkey collection ######
#############################
Write-Host -ForegroundColor Yellow "Collecting Tape Services Diagnostics informtion"
[System.IO.Directory]::CreateDirectory($RegkeyExports) | Out-Null
Reg export HKEY_LOCAL_MACHINE\SOFTWARE\VeeaM $RegkeyExports\VeeaM.log
Reg export HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\VeeaM\ $RegkeyExports\Wow64Veeam.log
Reg export HKLM\System\CurrentControlSet\Enum\SCSI $RegkeyExports\EnumSCSI.log
Reg export HKLM\HARDWARE\DEVICEMAP\Scsi $RegkeyExports\DevicemapSCSI.log


##################
#### EVENTS ######
##################


if ($AllEventLogs -eq $True){
	Write-Host -ForegroundColor Yellow "Getting All Windows Events; collection may take several minutes"
	[System.IO.Directory]::CreateDirectory($EventsFolder) | Out-Null
	$evts = wevtutil el
	$i = 0
		foreach ($evt in $evts){
			$EventPath = mkdir $EventsFolder\$evt
			$EventName = $evt | split-path -leaf
			wevtutil epl $evt $EventPath\$EventName.evtx 
			wevtutil al $EventPath\$EventName.evtx /l:en-US # first command exports all logs in $evt to evtx file, second "archives" them, adding english locale
			$i++
			Write-Progress -Activity "Gathering Events..." -CurrentOperation "Collecting $evt" -Status "Progress:" -PercentComplete (($i/$evts.Count) * 100)
			}
	Write-Host -ForegroundColor Yellow "Done."
	} 
else 
	{
	Start-Sleep 1
	Write-Host -ForegroundColor Yellow "Getting Windows Events. This may take up to several minutes. For very active machines, it may take longer"
	[System.IO.Directory]::CreateDirectory($EventsFolder) | Out-Null
	$Application=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='Application'").BackupEventLog("$EventsFolder\Application.evtx")
	$System=(Get-WmiObject -Class Win32_NTEventlogFile -Filter "LogFIleName='System'").BackupEventLog("$EventsFolder\System.evtx")
	#Events in CSV are only for the last 7 days.
	$ApplicationCSV=Get-EventLog -LogName Application -After (Get-Date).AddDays(-7) |  select eventID, entrytype, source, message, timegenerated | Export-Csv $EventsFolder\Application.csv
	$SystemCSV=Get-EventLog -LogName System -After (Get-Date).AddDays(-7) |  select eventID, entrytype, source, message, timegenerated | Export-Csv $EventsFolder\System.csv
	Write-Host -ForegroundColor Yellow "Done."
}


#######################
#### Compression ######
#######################

#As supported servers may use a PS version that does not have built-in compression, using the .NET compression.filesystem to ensure we can actually make a zip. If for whatever reason it just is not possible, we give up and just leave it as is. 

If ($NetValid -eq $true){
		Write-Host -ForegroundColor Yellow "Compressing Directory"
		If(Test-path $LogPath\$LogName.zip) {Remove-item $LogPath\$LogName.zip}
		Add-Type -assembly "system.io.compression.filesystem"
		[io.compression.zipfile]::CreateFromDirectory($TapeLogs, "$LogPath\$LogName.zip") 
			if (!(Test-Path $LogPath\$LogName.zip)) {
				End-Script
			} else {
		Write-Host "Done."
		Write-Host -ForegroundColor Yellow "Deleting Temp Files"
		Remove-Item -r -fo $TapeLogs
		Write-Host "Done."
		Write-Host -ForegroundColor Yellow "The data has been collected. Please upload $TapeLogs.zip, located in $LogPath, to the FTP provided by Veeam Technical Support" 
		Explorer.exe $LogPath
		}
	}	
else {
	End-Script
} 