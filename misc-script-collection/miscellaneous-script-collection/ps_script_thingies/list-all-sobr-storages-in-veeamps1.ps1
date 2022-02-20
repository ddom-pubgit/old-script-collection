Add-PSSnapin VeeamPssnapin

#change the name of the below line to your Scale-out Repository
$repo = Get-VBRBackupRepository -ScaleOut -name 'nixsobr-minio-ct'
$sobrjob = Get-VBRJob | ?{$_.Info.TargetRepositoryId -eq $repo.id}
$paths = @()

foreach($job in $sobrjob){
    $somesobr = [Veeam.Backup.Core.CBackup]::GetAllByJob($job.Id)
        $realsobr = $somesobr.GetRepository()
    $somestorages = @($somesobr.GetAllStorages())
        foreach($st in $somestorages) {
            $ext = $realsobr.FindExtentRepo($st.Id)
            $paths += New-Object -TypeName psobject -Property @{ext=$ext.Name;path=$($ext.Path.ToString(),$job.Name.ToString(),$st.filepath -join "\")}
        }
    }
$paths