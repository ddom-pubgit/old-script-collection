asnp VeeamPSSnapin
Get-VBRJob | ?{$_.JobType -eq "Backup"} | foreach{
	$job = $_
    $JobName = $_.Name
    $Backup = Get-VBRBackup -Name $JobName
    $lastsession = $job.FindLastSession()
		foreach($tasksession in $lastsession.GetTaskSessions()) {
			$PointsOnDisk = (get-vbrbackup -Name $job.Name | Get-VBRRestorePoint -Name $tasksession.Name | Measure-Object).Count 
			$RetentionSetting = $job.Options.BackupStorageOptions.RetainCycles
			$SynEnabled = $job.Options.BackupTargetOptions.TransformFullToSyntethic
			$AFEnabled = $job.Options.BackupStorageOptions.EnableFullBackup
		}
		If($PointsOnDisk -gt $RetentionSetting){
						$_ | Get-VBRJobObject | ?{$_.Object.Type -eq "VM"} | Select @{ L="Job"; E={$JobName}}, Name,  @{ L="PointsOnDisk"; E={$PointsOnDisk}}, @{ L="Retention Setting"; E={$RetentionSetting}}, @{ L="SynFull?"; E={$SynEnabled}}, @{ L="AF Enabled?"; E={$AFEnabled}} | Sort -Property Job, Name |  Export-Csv -Append -Path C:\temp\output.csv
						}
}
