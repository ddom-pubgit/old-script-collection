Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{Multiselect = $true}

[void]$FileBrowser.ShowDialog()

$allSettings = New-Object System.Collections.ArrayList
$AllJobOptions = New-Object System.Collections.ArrayList
#$JobDates = New-Object System.Collections.Arraylist
$XMLPretty = New-Object System.Collections.Arraylist
$hash = @{}
$i = 0

foreach ($files in $FileBrowser) { 

$LogFile = $FileBrowser.Filenames
$JobOptionsXML =  @(Get-Content $Logfile | Select-String -Pattern 'Job Options:')
    foreach ($xml in $JobOptionsXML) { 
        $dates = [string]$xml[0] | Select-String -Pattern "((0|1)\d{1}).((0|1|2)\d{1}).((19|20)\d{2}) (2[0-3]|[01]?[0-9]):([0-5]?[0-9]):([0-5]?[0-9])?"
        $TempJobDate = $dates.Matches
        #$JobDates.Add(($dates.Matches))
        [string]$JobSettings = $xml
        $ConvertToXml = ($JobSettings.Split("[")[2]) + ($JobSettings.Split("[")[3])
        $CleanString = $ConvertToXml.Substring(0,$ConvertToXml.Length-1)
        [xml]$JobSettingsXML = $CleanString
        $XMLPretty.Add(($JobSettingsXML)) 
        $hash.add($i, @($TempJobDate, $JobSettingsXML))
        $i++
        }
}




#([0-1]?\d|2[0-3])(?::([0-5]?\d))?(?::([0-5]?\d)) > Works so far
#(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d) > Improvement?
#(2[0-3]|[01]?[0-9]):([0-5]?[0-9]):([0-5]?[0-9]) > supposedly better
