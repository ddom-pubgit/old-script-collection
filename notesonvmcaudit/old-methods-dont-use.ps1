 function Clean-MessyChars{
	 param(
		[int]$i
		)
	$DataTemp = $DataSplit[$i].Split(":")[1] + $DataSplit[$i+1]
	$DataTemp = $DataTemp.Trim().Split().TrimStart(":","{",'"').TrimEnd(":","}",'"') -Join " "
	$DataClean = $DataSplit[$i].Split("{")[0] + $DataTemp
	Return $DataClean
}

 function Make-EntryCleaner {
	 param(
		[string]$RawLine
		)
	[System.Collections.ArrayList]$CleanData = @()
	$DataSplit = $RawLine.Split(",")
	$type = $DataSplit[1].Trim().Split()[1]
	$DataSplit[0] = $DataSplit[0].split()[12]+" " +  $DataSplit[0].Split()[13]
	$DataSplit[4] = Clean-MessyChars -i "4"
	$DataSplit[6] = Clean-MessyChars -i "6"
	if($type -eq "DDboost"){
		$flag = $true
		$DataSplit[16] =  Clean-MessyChars -i "16"
	}
	if($type -eq "HPStoreOnceIntegration"){
		$flag = $true
		$DataSplit[16] =  Clean-MessyChars -i "16"
	}
	foreach($d in $DataSplit){
		$CleanData += $d.Trim()
		}
	$CleanData.RemoveAt(5)
	$CleanData.RemoveAt(5)
	$CleanData.RemoveAt(5)
	if($flag){$CleanData.RemoveAt(14)}
	Return $CleanData
 }	