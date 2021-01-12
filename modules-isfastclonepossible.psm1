function Get-WindowsRepositoryInfo {
    param(
        [string[]]$RepositoryID
        )
		$WinRepositoryInfo = [Veeam.Backup.Core.CWindowsRepository]::FindByRepository("$RepositoryID")
		return $WinRepositoryInfo
	}
	
function Get-LinuxRepositoryInfo {
    param(
        [string[]]$RepositoryID
        )
		$LinuxRepositoryInfo = [Veeam.Backup.Core.CLinuxRepository]::FindByRepository("$RepositoryID") 
		return $LinuxRepositoryInfo
	}

function Get-CIFSRepositoryInfo {
	param(
		[string[]]$RepositoryID
		)
		$CIFSRepositoryInfo = [Veeam.Backup.Core.CCifsRepository]::FindByRepository("$RepositoryID") 
		return $CIFSRepositoryInfo
	}

function Get-ExtentFromScaleout {
	param(
		[string[]]$ScaleoutRepoName
		)
		$ScaleoutRepo = Get-VBRBackupRepository -Scaleout -Name $ScaleoutRepoName
		$ScaleOutExtents = $ScaleoutRepo.Extent.Repository 
		return $ScaleOutExtents
	}

function Show-IsFastClonePossibleandClusterSize {
	param(
		[Object[]]$BackupRepositoryInfo
		)
		$RepositoryInformation = [ordered]@{
			RepositoryName = $RepositoryToCheck.Name
			RepositoryType = $RepositoryToCheck.Type
			FastClonePossible = ($BackupRepositoryInfo.IsVirtualSyntheticEnabled -and $BackupRepositoryInfo.IsVirtualSyntheticAvailable)
			RepoClusterSize = $BackupRepositoryInfo.ClusterSize
			IsDedupEnabledWinOnly = $BackupRepositoryInfo.IsDedupEnabled
		}
		return $RepositoryInformation
	}

function Get-RepositoryTypeAndInfo {
	param(
		[Object[]]$RepositoryToCheck
	)
	If($RepositoryToCheck.Type -eq "LinuxLocal"){
		$RepoInfo = Get-LinuxRepositoryInfo -RepositoryID $RepositoryToCheck.id
	} elseif ($RepositoryToCheck.Type -eq "CifsShare") {
		$RepoInfo = Get-CIFSRepositoryInfo -RepositoryID $RepositoryToCheck.id
	} elseif ($RepositoryToCheck.Type -eq "WinLocal"){
		$RepoInfo = Get-WindowsRepositoryInfo -RepositoryID $RepositoryToCheck.id
	}
	$RepositoryData += (Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $RepoInfo)
	return	$RepositoryData
} 	
function Get-StoragesPathsAndBlocksizeFromBackup {
	param(
		[Parameter(Mandatory=$true, Position=0)]
		[Object[]]$Backup
	)
	if($Backup.JobType -eq 'EpAgentBackup' -or $Backup.Jobtype -eq 'SimpleBackupCopyPolicy'){
		$Storages = $Backup[0].GetallChildrenStorages() | Sort-Object -Property PartialPath, CreationTime -Descending
	} else {
		$Storages = $Backup[0].GetAllStorages() | Sort-Object -Property PartialPath, CreationTime -Descending
	}
	$Repository = $Backup.FindRepository()[0]
	$StoragePathsandBlocksize  = @()
	if($Repository.Type -eq "ExtendableRepository"){
		foreach($Storage in $Storages){
			$Extent = $Repository.FindExtentRepo($Storage.Id)
			$job = $Backup.FindJob()
			$StoragePathsandBlocksize += New-Object -TypeName psobject -Property @{Extent=$Extent.Name;Path=$($Extent.Path.ToString(),$job.Name.ToString(),$Storage.filepath -join "\");BlockSize=$Storage.BlockAlignmentSize;CreationTime=$Storage.CreationTime}
			}
	} else {
		$StoragePathsandBlocksize += $Storages | Sort-Object -Property PartialPath, CreationTime -Descending | Select-Object -Property PartialPath,BlockAlignmentSize
	}
	return $StoragePathsandBlocksize
}