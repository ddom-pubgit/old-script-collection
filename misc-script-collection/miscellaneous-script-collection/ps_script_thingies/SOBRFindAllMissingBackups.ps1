$missingFiles = @()
$AllBackups = Get-VBRBackup | Where-Object ($_.RepositoryType -eq "ExtendableRepository")
Foreach($Backup in $Backups){
	$MissingStorages = [Veeam.backup.Core.CStorageExtentAssociation]::GetUnassociatedStorages($($backup.id))
	foreach($Storage in $MissingStorages){
			$tempObj = [PSCustomObject]@{
				BackupName = $Backup.Name
				StorageName = $Storage.PartialPath
				IsAvailable = $Storage.IsAvailable
			}
			$missingFiles += $tempObj
	}
}
$missingFiles | Export-CSV -Path "some path" -NoTypeInformation