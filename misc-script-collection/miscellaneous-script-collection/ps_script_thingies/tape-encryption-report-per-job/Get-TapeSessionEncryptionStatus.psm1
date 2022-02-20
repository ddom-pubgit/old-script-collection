function Get-TapeSessionEncryptionStatus {
    param(
        $Session
        )
    $taskSession = Get-VBRTaskSession -Session $Session
    $EncryptionData = @()
    foreach($tSess in $taskSession){
	    $datem = "" | select TaskName, Encryption
	    $LoggerEncryptionTitle = $tSess.Logger.GetLog().GetRecordsSortedByOrdinalId() | ?{$_.Title -like '*encryption*'}
        if($LoggerEncryptionTitle){
	        $status = $LoggerEncryptionTitle.Title.ToString().Split(",")[1]
	        $datem.Encryption = $status
	        $datem.TaskName = $tSess.Name
	        $EncryptionData += $datem
            }
	    }
    return $EncryptionData
    }