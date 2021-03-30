# Surebackup Retry Watcher

A simple script to watch and retry failed SureBackup Jobs perpetually. 

## Instructions

The script runs as a watcher loop every hour, so simply start the script and forget about it.

## Workflow

1. Collect a list of all surebackup jobs
2. Those which are failed, queue them for processing
3. Run through all SureBackup Jobs sequentially (regrettably sequential is a must right now; the script has no logic for handling two jobs wanting the same vLab)
4. Log the result, then continue on
5. Wait an hour (configurable), and repeat