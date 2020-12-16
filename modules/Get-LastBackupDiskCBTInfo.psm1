function Get-LastBackupDiskCBTInfo {
	param (
		[object[]]$Backup
		)
		$LastBackupDiskCBTInfo = ($backup.GetLastOibs()|Where-Object {$_.VMname -eq "$VMname"})AuxData.DisksInfos
		return $LastBackupDiskCBTInfo
		}