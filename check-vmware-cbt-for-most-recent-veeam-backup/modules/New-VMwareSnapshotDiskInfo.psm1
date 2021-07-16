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