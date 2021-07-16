function Get-LastBackupDiskCBTInfo {
	param (
		[object[]]$Backup
		)
		$LastBackupDiskCBTInfo = ($backup.GetLastOibs()|Where-Object {$_.VMname -eq "$VMname"}).AuxData.DisksInfos
		return $LastBackupDiskCBTInfo
		}
		
function New-VMwareSnapshotDiskInfo {
	param(
		[string[]]$VMName
		)
	$ProductionVM = Get-VM $VmName
	$ProductionVMView = Get-View $ProductionVM
	$Snapshot = New-Snapshot -VM $ProductionVM "Temporary Snapshot for CBT Scripting" -Description "Do not delete, will be automatically cleared"
	$SnapshotView  = Get-View $Snapshot
	$SnapshotDisks = $SnapshotView.Config.Hardware.Device | Where-Object {($_.GetType()).Name -eq "VirtualDisk"} | Sort-Object Key
	$ViewsAndDisks = @{
		VMView = $ProductionVMView
		SnapView = $SnapshotView
		SnapDisks = $SnapshotDisks
		Snapshot = $Snapshot
		}
	return $ViewsAndDisks
	}
	
function Compare-BackupAndProducionDiskCBTInfo {
	param(
		[Object[]]$BackupDisk,
		[Object[]]$SnapshotData
		)
	$Disk = $SnapshotData.SnapDisks| Where-Object{$_.Key -eq $BackupDisk.Key}
	Try {
		$Offset = 0
		$GBChanged = 0
		Do {
			$Changes = $SnapshotData.VmView.QueryChangedDiskAreas($SnapshotData.Snapview.MoRef,$Disk.Key,$Offset,$BackupDisk.ChangeID)
			$GBChanged += ($Changes.ChangedArea | %{$_.Length} | Measure-Object -sum).sum/1024/1024/1024
			$LastChange = $Changes.ChangedArea | Sort-Object Start | select -Last 1
			$Offset = $LastChange.Start + $LastChange.Length
			}
		While ($Disk.CapacityInBytes -gt $Offset -and $Changes.ChangedArea.Count -gt 0)
		}
	Catch {$GBchanged = 'error'}
	echo "$VMName $($BackupDisk.DiskName) $GBChanged GB changed since last backup on $($Backup.CreationTime)" | Out-Host
	}