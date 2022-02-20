# Tape Diagnostics Collection Script

A simple script for collecting relevant tape information for tape cases. 

## Getting Started

Download the script from git or from the (forthcoming) xwiki page. Send to clients. Get Logs. Profit.

## Purpose

To assist in the collecting relevant information from tape servers and to reduce the amount of fetching required by customers. The script automates the collection of a number of commands to be run on tape servers when troubleshooting tape hardware issues. 

### Usage

Note:
* Must be run from an Administrative Powershell prompt
* Must be run on the Tape Server in question

The script only has 2 modes; Normal and All Event Logs.

All modes collect the following information:

* gwmi information about drives and tapes, and also driver information about connected Changers and Tape Drives
* registry keys for scsi nodes and also Veeam Nodes
* Windows Event logs~*

Each mode collects Event logs differently and is intended for different audiences.

**Normal** 

Intended for T1 during basic tape troubleshooting. No parameter required. 

* Collects only System and Application Log in both evtx and csv format.


**All Event Logs**

Enabled by running the script with the **-AllEventLogs** parameter

Intended for use prior to escalation, collects __all event logs__ on the system in evtx format with the locale metadata. 

This process can take several minutes. 

