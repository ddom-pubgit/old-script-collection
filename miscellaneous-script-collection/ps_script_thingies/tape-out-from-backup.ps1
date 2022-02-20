add-pssnapin VeeamPSSnapin

$VM = Read-Host -Prompt 'Name of Server for File Tape-out (case-sensitive)'
$Job = Read-Host -Prompt 'Name of Backup Job (case-sensitive)'
$Files = Read-Host -Prompt 'Path of Files to Backup'
$server = Read-Host -Prompt 'Name of Mount Server where FLR is Mounted (As shown in Veeam)'
$mediaPool = Read-Host -Prompt 'Name of Media Pool to backup Full Backups'


$result=Get-VBRBackup | where {$_.jobname -eq $Job} | Get-VBRRestorePoint | where {$_.name -eq $VM} | Sort-Object creationtime | Select-Object -First 1 | Start-VBRWindowsFileRestore
$flrmountpoint = ($result.MountSession.MountedDevices | ? {$_.DriveLetter -eq (split-path -Qualifier $Files)})
$file = $flrmountpoint.MountPoint + (split-path -NoQualifier $Files)
$tapeServer = Get-VBRServer -Name $server
$object = New-VBRFileToTapeObject -Server $tapeServer -Path $file
$tapejob = Add-VBRFileToTapeJob -Name "Tapeout from Backup of $VM" -FullBackupMediaPool $mediapool -Description "Tapeout from existing backup files from $VM Backup File. Files are retrieved from FLR Mount. No Restore to Original Location, only Copy To" -Object $object

Start-VBRJob -Job $tapejob -RunAsync