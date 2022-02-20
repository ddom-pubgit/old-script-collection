<# Quick and dirty script that checks all the instances on a given SQL server for DBs that have trailing spaces.
For troubleshooting SQL Writer is missing errors when manually checking each Instance is impractical.
You can change lines 2 and 3 to your discrection.
We split on the $ from the services, non-named instances (blank ones) will need to be checked manually.
Run from Administrative Shell #>

$services = Get-Service | ?{$_.DisplayName -like 'SQL Server (*'}
New-Item -ItemType file C:\temp\TrailingSpacesDBs.log | Out-Null
$output = Get-Item -Path C:\temp\TrailingSpacesDBs.log
Foreach($service in $services){
	$blanknames = $null
    $Instance = $services[0].ServiceName.ToString().Split("$")[1]
    $blanknames = Invoke-SQLCMD -ServerInstance "localhost\$Instance" -Query "use [master]; select name from sys.databases where name like '% ' or name like ' %'"
    If($blanknames){
    Add-Content -Path $output -Value "$Instance"
    Add-Content -Path $output -Value ""
    Add-Content -path $output -value "$($blanknames.name)"
    }
}

explorer.exe C:\temp

 