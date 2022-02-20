function Find-InfraItemSection {
	param(
		[string]$InfrastructureItem
		)
	$StartSection = $LastFullContent.FindIndex({$args[0] -like "*$InfrastructureItem*"})
	$EndSection = $LastFullContent.FindLastIndex({$args[0] -like "*$InfrastructureItem*"})
	$result = $LastFullContent[$StartSection..$EndSection]
	Return $result
}

function Clean-MessyChars{
	 param(
		[int]$i,
		[object]$DataToClean
		)
	$DataTemp = $DataToClean[$i].Split(":")[1] + $DataToClean[$i+1]
	$DataTemp = $DataTemp.Trim().Split().TrimStart(":","{",'"').TrimEnd(":","}",'"') -Join " "
	$DataClean = $DataToClean[$i].Split("{")[0] + $DataTemp
	Return $DataClean
}
	
function Make-AllEntryCleaner {
	 param(
		[string]$RawLine
		)
	[System.Collections.ArrayList]$CleanData = @()
	$DataToClean = $RawLine.Split(",")	
	$DataToClean[0] = $DataToClean[0].split()[12]+" " +  $DataToClean[0].Split()[13]
	foreach($d in $DataToClean){
		$CleanData += $d.Trim()
		}
	Return $CleanData
}

function Fix-RepositoryCleanData {
	param(
		[object]$RepoCleanData
		)
	[System.Collections.ArrayList]$RepoCleanData = $RepoCleanData	
	$type = $RepoCleanData[1].Trim().Split()[1]
	$RepoCleanData[4] = Clean-MessyChars -i "4" -DataToClean $RepoCleanData
	$RepoCleanData[6] = Clean-MessyChars -i "6" -DataToClean $RepoCleanData
	if($type -eq "DDboost" -or $type -eq "HPStoreOnceIntegration"){
		$flag = $true
		$RepoCleanData[16] =  Clean-MessyChars -i "16" -DataToClean $RepoCleanData
		}	
	$RepoCleanData.RemoveAt(5)
	$RepoCleanData.RemoveAt(5)
	$RepoCleanData.RemoveAt(5)
	if($flag){$RepoCleanData.RemoveAt(14)}
	Return $RepoCleanData
}
 
function Build-InfrastructureObject {
	param(
		[Object]$RawData
		)
	$InfraHash = @{}
	foreach($d in $RawData){
		$key = $d.Split()[0].Trim($UndesireableCharacters)
		$value = $d.Split()[1]
		$InfraHash.Add($key,$value)
		}
	$InfraObject = [PSCustomObject]$InfraHash
	Return $InfraObject
}	

#WIP
function Create-InfraItemObject {
	param(
	[Object]$InfraItemData
	)
	$CleanData  = Make-AllEntryCleaner -RawData $InfraItemData
	if($
	$ProxyObject = Build-InfrastructureObject -RawData $CleanData
	Return $ProxyObject
}

function Build-RepositoryObject {
	param(
	[Object]$RepoData
	)
	$CleanData = $Make-AllEntryCleaner -RawData $RepoData
	$CleanData = Fix-RepositoryCleanData -RepoCleanData $CleanData
	$RepoObject = Build-InfrastructureObject -RawData $CleanData
	Return $RepoObject
}

	

###### Staging Variables #######

$UndesireableCharacters = @(":","{","}","[","]",'"',",") 
[Collections.Generic.List[Object]]$content = Get-Content "path to VMC" #Make Selector
$startingPointIndex = $content.FindLastIndex({$args[0] -like '*STARTCOLLECTINFRASTATISTIC*'})
$lastlineIndex = $content.FindLastIndex({$args[0] -like "*Veeam Metrics Collector stopped*"})
[Collections.Generic.List[Object]]$LastFullContent = $content[$startingPointIndex..$lastlineIndex]


$InfrastructureItems = @(
[PSCustomObject]@{Type='HOSTS';SearchValue="INFRASTRUCTURE HOSTS DETAILS"}
[PSCustomObject]@{Type='PROXIES';SearchValue="CURRENT PROXIES"}
[PSCustomObject]@{Type='REPOSITORIES';SearchValue="CURRENT REPOSITORIES"}
[PSCustomObject]@{Type='TAPE';SearchValue="TAPE INFRASTRUCTURE CONFIGURATION"}
)

				
###### Get Infrastructure Sections ######




Foreach($item in $InfrastructureItems){
	New-Variable -Name "$($item.Type)LIST" -Value (Find-InfraItemSection -InfrastructureItem $($item.SearchValue))
}

$AllProxies = @()
$AllRepositories = @()
$AllHosts = @()
$AllTapeServers = @()

for($i=1;$i -lt $PROXIESLIST.Length-1;$i++){
	$AllProxies += Create-ProxyObject -PInput $PROXIESLIST[$i]
}

