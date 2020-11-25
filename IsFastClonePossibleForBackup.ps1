<# script returns the blocksize of Storages for a Backup and also the Repository Information.
Works for Scaleout Repos and also Local Windows/Linux (should work for XFS)
Not Tested with CloudConnect Repos
Currently breaks with Agent backups (all types) when returning storages, will be fixed in next version
#>

<#Todo:

- Add validation rules for EpAgentBackups (not returned by Get-VBRRestorepoint)
- Add validation rules for why Fastclone is not posssible on a given repository
#>

param (
    [string]$BackupName
    )

Add-PSSnapin VeeamPSSnapin

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
		#[Parameter(Mandatory=$true, Position=1)]
		#[Object[]]$Repository
	)
	$Storages = $Backup[0].GetAllStorages()
	$Repository = $Backup.FindRepository()[0]
	$StoragePathsandBlocksize  = @()
	if($Repository.Type -eq "ExtendableRepository"){
		foreach($Storage in $Storages){
			$Extent = $Repository.FindExtentRepo($Storage.Id)
			$job = $Backup.FindJob()
			$StoragePathsandBlocksize += New-Object -TypeName psobject -Property @{Extent=$Extent.Name;Path=$($Extent.Path.ToString(),$job.Name.ToString(),$Storage.filepath -join "\");BlockSize=$Storage.BlockAlignmentSize;CreationTime=$Storage.CreationTime}
			}
	} else {
		$StoragePathsandBlocksize += $Storages | Sort-Object -Property CreationTime -Descending | Select-Object -Property PartialPath,BlockAlignmentSize
	}
	return $StoragePathsandBlocksize
}


$Backup = Get-VBRBackup -Name $BackupName
$RestorePoints = Get-VBRRestorePoint -Backup $Backup
$TargetRepository = $Backup.FindRepository()[0] #Jobs with Offloads in Copy Mode will return multiple entries from FindRepository() but both will be PerformanceTier. Safe to simply set the first
#$StoragesStats = $RestorePoints.FindStorage() |Sort-Object -Property CreationTime -Descending |Select-Object -Property Partialpath,BlockAlignmentSize
$StoragesStats = Get-StoragesPathsAndBlocksizeFromBackup -Backup $Backup
$RepositoryData = @()

If($TargetRepository.Type -eq 'ExtendableRepository'){
		$ExtentList = Get-ExtentFromScaleout -ScaleoutRepoName $TargetRepository.Name
		Foreach($Extent in $ExtentList){
			Get-RepositoryTypeAndInfo -RepositoryToCheck $Extent
		}
	
	$RepositoryData | Out-Host
	$StoragesStats| Sort-Object -Property Creationtime | Select-Object -Property Extent,Path,Blocksize | Out-Host
} else {
	Get-RepositoryTypeAndInfo -RepositoryToCheck $TargetRepository
	$RepositoryData | Out-Host
	$StoragesStats | Out-Host
}
	
