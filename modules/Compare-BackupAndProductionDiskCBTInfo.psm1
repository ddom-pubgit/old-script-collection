function Compare-BackupAndProducionDiskCBTInfo {
	param(
		[Object[]]$BackupDisk,
		[Object[]]$SnapshotData
		)
	$Disk = $SnapshotData.SnapDisks| Where-Object{$_.Key -eq $BackupDisk.Key}
	$Offset = 0
	$GBChanged = 0
	$Changes = $SnapshotData.VmView.QueryChangedDiskAreas($SnapshotData.Snapview.MoRef,$Disk.Key,$Offset,$BackupDisk.ChangeID)
	$GBChanged += ($Changes.ChangedArea | %{$_.Length} | Measure-Object -sum).sum/1024/1024/1024
	$LastChange = $Changes.ChangedArea | Sort-Object Start | select -Last 1
	#$Offset = $LastChange.Start + $LastChange.Length
	echo "$VMName $($BackupDisk.DiskName) $GBChanged GB changed since last backup on $($Backup.CreationTime)" | Out-Host
	}