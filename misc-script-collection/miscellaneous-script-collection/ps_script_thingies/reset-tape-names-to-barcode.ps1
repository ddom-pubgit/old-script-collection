$tapes = Get-VBRTapeMedium
foreach ($tape in $tapes){
    $barcode = $tape.barcode
    $tname = $tape.name
    if($tname -ne $barcode){
        Set-VBRTapeMedium -Medium $tape -Name $barcode
		}
    }
