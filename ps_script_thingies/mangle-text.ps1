function Mangle-Text {                     
	param(
		[string]$InputText
	)
	$chararray = $InputText.ToCharArray("0",$($InputText.length))
	$i = 0
	foreach($item in $chararray){
		$random = Get-Random -Maximum 2
		If($random -eq 1 ){
			$chararray[$i] = $item.ToString().ToLower()
		} else {
		$chararray[$i] = $item.ToString().ToUpper()
		}$i++
	}
	$mangled = $chararray -Join ""
	Return $mangled
}