# Windows Automation Script

This script automates several tasks on a Windows system, including system maintenance, downloading and installing applications, and more. It’s designed to streamline the setup and maintenance process by performing a series of automated actions.

This will render as:

## Installation

To download and run the script, use the following PowerShell command:

```powershell
powershell -Command "Invoke-RestMethod -Uri 'https://github.com/catsmoker/cs_script/releases/download/script/cs_script.cmd' -OutFile 'cs_script.cmd'; Start-Process 'cmd.exe' -ArgumentList '/c cs_script.cmd' -Wait"
```


## Features

1. **Scan and Fix Windows**: runs the System File Checker (SFC)&(DISM) to scan and repair system files.
2. **Download and Install Applications**: Downloads and installs the some applications.
3. **Activate windows**: Attempts to activate windows. Note: Activation may require manual intervention or a separate tool.
4. **Download Atlas OS Playbook and ame wizard**: Downloads the Atlas OS playbook and ame wizard for your reference.

## Attention
the script runs only in windows 10 & 11 -64Bit-
