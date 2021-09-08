# Stop Eternally Running Tasks

A simple script to assist with stopping eternally running tasks. Currently works for Hypervisor Jobs (VMware/HyperV Backup jobs and Backup copies) and Tape Jobs. Will check for Agents if there is demand.

## How to use

1. Copy the script to the Veeam Server (there is a hard check for this, must be Veeam Server)
2. Open an Administrative Powershell Session or Veeam Console Powershell Session
3. If desired, get specific job with Get-VBRJob or Get-VBRTapeJob and pass it to -BackupJob or -TapeJob respectively
4. Follow the prompts from the pop-up Windows to select the Job, the affected Job Session, and the affected Task Session

## Description of issue

At times, there may be instances when a task within a job continues to show as "running" even though the job has long since been stopped and failed.

This is purely a cosmetic issue, and usually it's due to an unexpected shutdown or disconnect between the Veeam Server and the Configuration Database. The Task never received the "close" command, so it continues to count time as if it were still running. 

No data is actually being moved, this has no impact on other items, it just looks unpleasant.

Please see the longer description here:

https://xwiki.support2.veeam.local/bin/view/Personal-Spaces/DDomask/Gracefully-Resolving-Eternally-Running-Task-Sessions/

## Reporting issues

Please just write me if there are issues, but the script should be very straight forward.

