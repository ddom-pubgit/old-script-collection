# Tape Monitor Script

A simple script to monitor the connection of Tape hardware on a Tape Server

## Accepted Parameters

-DriveCheck 

Description: Script will check for number of Drives instead of number of Changers.

## Instructions

1. Run the script from an Administrative Powershell prompt
2. The script will write to C:\temp\tapemonitor.log by default. This can be changed in the first few lines
3. By Default, the script checks for the number of Tape Changers attached. This is useful for monitoring for things like if the Changer goes offline in Windows (e.g., Magazine door opened, faulty door latch, etc)
4. Use of the -DriveCheck Flag will monitor the drives themselves
5. For each operating mode, the script behaves as follows:
- We collect a "Working Count", a baseline when all devices show as connected in Windows and log the connected devices
- For 1 week, we check every 10 seconds to see if the current device count matches the Working Count
- If there is a difference, the script reports it and logs the current connected devices, then terminaes.

Set the variables at the beginning of the script, and let it run. 

If the customer must disconnect the hardware for unexpected maintenance, remind them to restat the script. 