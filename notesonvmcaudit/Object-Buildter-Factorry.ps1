 foreach($i in $Splitter){
	if($i.Endswith(":")){Write-host "Item Name $($i.Trim(":",'"'))"}
	elseif($i.EndsWith(",")){Write-host "Value is $($i.Trim(",","}",'"'))"}
 }
  
$UndesireableCharacters = @(":","{","}","[","]",'"',",") 
		
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
	
	
	
	
	
<# OLD DON'T USE	
 function Make-EntryCleaner {
	 param(
		[string]$RawLine
		)
	[System.Collections.ArrayList]$CleanData = @()	
	$DataToClean = $RawLine.Split(",")
	$DataToClean[0] = $DataToClean[0].split()[12]+" " +  $DataToClean[0].Split()[13]
	$DataTemp = $DataToClean[4].Split(":")[1] + $DataToClean[5]
	$DataTemp = $DataTemp.Trim().Split().TrimStart(":","{",'"').TrimEnd(":","}",'"') -Join " "
	$DataToClean[4] = $DataToClean[4].Split("{")[0] + $DataTemp
	$DataTemp = $DataToClean[6].Split(":")[1] +$DataToClean[7]
	$DataTemp = $DataTemp.Trim().Split().TrimStart(":","{",'"').TrimEnd(":","}",'"') -Join " "
	$DataToClean[6] = $DataToClean[6].Split(":")[0] + $DataTemp
	if($DataToClean[1].Split{",")[1] -eq "DDboost"){
		$DataTemp = $DataToClean[16].Split(":")[1] +$DataToClean[17]
		$DataTemp = $DataTemp.Trim().Split().TrimStart(":","{",'"').TrimEnd(":","}",'"') -Join " "
		
	foreach($d in $DataToClean){
		$CleanData += $d.Trim()
		}
	$CleanData.RemoveAt(5)
	$CleanData.RemoveAt(6)
	if($CleanData[18]){$CleanData.RemoveAt(18)}
	Return $CleanData
 }
 
 function Make-EntryCleaner {
	 param(
		[string]$RawLine
		)
	[System.Collections.ArrayList]$CleanData = @()
	$DataToClean = $RawLine.Split(",")
	$type = $DataToClean[1].Trim().Split()[1]
	$DataToClean[0] = $DataToClean[0].split()[12]+" " +  $DataToClean[0].Split()[13]
	$DataToClean[4] = Clean-MessyChars -i "4"
	$DataToClean[6] = Clean-MessyChars -i "6"
	if($type -eq "DDboost"){
		$flag = $true
		$DataToClean[16] =  Clean-MessyChars -i "16"
	}
	if($type -eq "HPStoreOnceIntegration"){
		$flag = $true
		$DataToClean[16] =  Clean-MessyChars -i "16"
	}
	foreach($d in $DataToClean){
		$CleanData += $d.Trim()
		}
	$CleanData.RemoveAt(5)
	$CleanData.RemoveAt(5)
	$CleanData.RemoveAt(5)
	if($flag){$CleanData.RemoveAt(14)}
	Return $CleanData
 }	
 
 #>
 
