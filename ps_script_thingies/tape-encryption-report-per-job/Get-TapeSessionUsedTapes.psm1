<# the following values must be defined earlier in your script for this function to work:

    $DBserver = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLSERVERNAME').SqlserverName
    $DBInstance = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLInstanceName').SQLInstanceName
    $DBName = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLDatabaseName').SqlDatabaseName
	
The script will check for $DBServer and if it's not defined, it will Error the script
#>

function Get-TapeSesssionUsedTapes {
    param(
        [string[]]$SessionID
        )
	if(!$DBServer){
		Write-Host -ForegroundColor red '$DBServer value not found. Define $DBServer, $DBInstance, and $DBName beforehand to use this function'
		Write-Host -ForegroundColor red 'See comments on function for details'
		Return
	}
    $aux_data = invoke-sqlcmd -ServerInstance "$DBServer\$DBInstance" -Query "use [$DBName]; select aux_data from [backup.model.jobsessions] where id = '$SessionID'"
    [xml]$tapesxml = $aux_data.aux_data
    if($tapesxml.TapeAuxData.TapeMediums){
        $tapeNames = $tapesxml.TapeAuxData.TapeMediums.TapeMedium.Name
        }
    Return $tapeNames
}
