#-------------------------------------------------------------------------------
# SNB - Schweizerische Nationalbank, Informatik
# Systemgruppe PluS
#-------------------------------------------------------------------------------
#
# Owner    : CHN
# Homedir  : %SystemDrive%\SNB\bin
# Script   : TapeRegUpdater.ps1
#
# Date     : 26.08.2021
# Version  : 1.0
# Author   : PluS CHN
#
# Comment  : Update the Veeam TapeDevices Registry Value based on the XML dump file
#
# Usage    : TapeRegUpdater.ps1 [-verbose] [-trace] [-dryrun]
#
# Changes  : Date        Name  Remarks
#            26.08.2021  CHN   - First version
#            30.08.2021  CHN   - tested and finished first usable version
#
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------- parameters
param (
    [switch] $quiet   = $false,
    [switch] $verbose = $false,
    [switch] $trace   = $false,
    [switch] $dryrun  = $false
)

#--------------------------------------------------------------------- variables
if ($trace)   { $verbose = $true  }    # if trace is set, verbose has to be set!
if ($verbose) { $quiet   = $false } # if any verbosity is set, quiet cannot be set!

$logDir      = "C:\Logs"
$dateString  = Get-Date -Format yyyy-MM-dd_HHmm
$logFileName = "veeam_tapereg_update_${dateString}.log"
$fullLogPath = "${logDir}\${logFileName}"
$hostName    = $env:COMPUTERNAME
$TapeSVCPath = "C:\Program Files (x86)\Veeam\Backup Tape"
$TapeSVCExe  = "${TapeSVCPath}\VeeamTapeSvc.exe"
$TapeSVCDump = "C:\temp\TapeSVCDump"

#--------------------------------------------------------------------- functions
function info ([string]$msg) {                                            # info
    $ActualDate = Get-Date -format yyyy-MM-dd` HH:mm:ss
    if (-not $quiet) {
        Write-Host -ForegroundColor Green $ActualDate "INFO : ${msg}"
    }
    Add-Content -Path $fullLogPath -Value "${ActualDate} INFO : ${msg}"
}

function debug ([string]$msg) {                                          # debug
    $ActualDate = Get-Date -format yyyy-MM-dd` HH:mm:ss
    if ($verbose) {
        Write-Host -ForegroundColor Cyan $ActualDate "DEBUG: ${msg}"
    }
    Add-Content -Path $fullLogPath -Value "${ActualDate} DEBUG: ${msg}"
}

function trace ([string]$msg) {                                          # trace
    $ActualDate = Get-Date -format yyyy-MM-dd` HH:mm:ss
    if ($trace) {
        Write-Host -ForegroundColor Yellow $ActualDate "TRACE: ${msg}"
    }
    Add-Content -Path $fullLogPath -Value "${ActualDate} TRACE: ${msg}"
}

function error ([string]$msg) {                                          # error
    $ActualDate = Get-Date -format yyyy-MM-dd` HH:mm:ss
    if ($verbose) {
        Write-Host -ForegroundColor Red $ActualDate "ERROR: " $msg
    }
    Add-Content -Path $fullLogPath -Value "${ActualDate} ERROR: ${msg}"
}

function cleanupFiles ([int]$age = 7) {
    debug "now running the cleanupFiles function to delete files older than $age days..."
    $filesToDelete = (Get-ChildItem $logDir -Recurse -File -Filter "veeam_tapereg*" | `
        Where-Object CreationTime -lt (Get-Date).AddDays(-$age))
    $filesToDelete += (Get-ChildItem $TapeSVCDump -Recurse -File -Filter "*dumpinformation.xml" | `
        Where-Object CreationTime -lt (Get-Date).AddDays(-$age))
        
    if ($dryrun) {
        ForEach ($file in $filesToDelete) {
            debug "would delete file $file"
        }
    } else {
        ForEach ($file in $filesToDelete) {
            Remove-Item "${logDir}\${file}"
            if ($? -ne 0) {
                error "could not delete file ${logDir}\${file}"
                $rc = $false
            } else {
                debug "deleted file ${logDir}\${file}"
            }
        }
        info "removed veeam_tapereg* logfiles older than $age days"
    }

}

#-------------------------------------------------------------------------- MAIN
debug "Checking elevation rights"
# Checking elevation rights
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    error "You're running PowerShell without elevated rights. Please open a PowerShell window as an Administrator. Shell will close in 10 seconds automatically."
    Start-Sleep 10
    Exit
} else {
    debug "You're running PowerShell as an Administrator, OK!"
}

# Checking for presence of C:\Logs 
if (-not (Test-Path $fullLogPath)) {
    error "C:\Logs folder is not found! Exiting!"
    Exit $false
}

# Checking for the presence of the Tape Service executable directory
if (-not (Test-Path $TapeSVCPath)) {
    error "The Normal Veeam Tape Service Path $TapeSVCPath is not found."
    Exit $false
}

# Create TapeSVCDump Folder folder (if necessary)
if (-not (Test-Path $TapeSVCDump)) {
    [system.io.directory]::CreateDirectory($TapeSVCDump) | Out-Null
}

# create the C:\Program Files (x86)\Veeam\Backup Tape\dumpinformation.xml file
debug "Collecting Veeam Tape Service Dump"
$SvcDumpProcessTime = Measure-Command {
    Start-Process -NoNewWindow -WorkingDirectory $TapeSVCPath -FilePath $TapeSVCExe -ArgumentList '-dump' -Wait
}
Start-Sleep 1         # sleep for a second for the file to be written completely

# move and rename the freshly created XML file
Get-Childitem -File "$TapeSVCPath\dumpinformation.xml" | Move-Item -Destination "${TapeSVCDump}\${dateString}_dumpinformation.xml"
$dumpresult = Get-item ${TapeSVCDump}\${dateString}_dumpinformation.xml

# read the XML file and translate select values into variables
[xml]$xmldump = Get-Content $dumpresult
$drives       = $xmldump.Devices.Drive       # xml structure of <Devices><Drive>
$drivestatus  = $xmldump.Devices.Drives.DriveStatus # xml Structure of <Devices><Drives><DriveStatus>
$changer      = $xmldump.Devices.Changer.DeviceName # get the media changer name
$server       = $env:COMPUTERNAME                # get the tape server host name

# read the XML structure and fill in hashtable with deviceName and ElementAddress
$driveHash = [ordered]@{}                                  # keep the has sorted
foreach ($drive in $drives) {                      # loop through all the Drives
    $serialNumber = $drive.SerialNumber
    $deviceName   = $drive.DeviceName
    trace "working on Drive ${deviceName} with SerialNumber: ${serialNumber}"
    
    foreach ($status in $drivestatus) {  # get the ElementAddress for each drive
        $statusSerial = $status.SerialNumber # identifying element is the SerialNumber
        trace "working on DriveStatus SerialNumber: $statusSerial"
        if ($statusSerial -eq $serialNumber) {
            $elementAddress = $status.Element.ElementAddress
            trace "serialNumbers S{statusSerial} are equal!"
            $driveHash[$deviceName] = $elementAddress
        }
    } # end foreach status
} # end foreach drive

# translate the hashtable into a string to be used in the registry
$registryArray  = @()
foreach ($key in $driveHash.Keys) {
    $elementAddress = $driveHash[$key]
    $registryArray += "${key}:${elementAddress}"
}
$registryString  = "${server}`n${changer}="
$registryString += ($registryArray -join ",")
debug "registryString: `n$registryString"

# now, update the registry value (if not dryrun):
if (-not $dryrun) {
    info "now setting the registry value..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam Backup and Replication" -Name TapeDevices -Value "$registryString"
}

# finally, make sure the logfiles do not pile up unnecessary
cleanupFiles -age 14

debug "Done!"

