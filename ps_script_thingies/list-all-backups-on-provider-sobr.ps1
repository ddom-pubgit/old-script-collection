function Get-StoragesPathsAndTentantPathFromBackup {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Object[]]$Backup
    )
    $Storages = $Backup[0].GetallChildrenStorages() | Sort-Object -Property PartialPath, CreationTime -Descending
    $BackupPaths = $Backup[0].GetPartialPathWithTenantFolder()
    $Repository = $Backup.FindRepository()[0]
    $StoragePathsandBlocksize  = @()
    if($Repository.Type -eq "ExtendableRepository"){
        foreach($Storage in $Storages){
            $Extent = $Repository.FindExtentRepo($Storage.Id)
            $StoragePathsandBlocksize += New-Object -TypeName psobject -Property @{Tenant=$BackupPaths.Elements[0];Extent=$Extent.Name;Path=$($Extent.Path.ToString(),$BackupPaths.Elements[0],$BackupPaths.Elements[1],$Storage.filepath -join "\");CreationTime=$Storage.CreationTime}
            }
    } else {
        $StoragePathsandBlocksize += $Storages | Sort-Object -Property PartialPath, CreationTime -Descending | Select-Object -Property PartialPath,BlockAlignmentSize
    }
    return $StoragePathsandBlocksize
}

$repo = Get-VBRBackupRepository -Scaleout -Name 'Name of SOBR'
$backupsOnSobr = [Veeam.backup.Core.CBackup]::GetInRepository($($repo.id),"True","True","False","True")
$allStoragesOnSobr = @()
Foreach($backup in $backupsOnSobr){
$allStoragesOnSobr += Get-StoragesPathsAndTentantPathFromBackup -backup $backup
}
$allStoragesOnSobr | select-Object -Property Tenant, Path