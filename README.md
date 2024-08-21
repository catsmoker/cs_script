# Windows Automation Script

This script automates several tasks on a Windows system, including system maintenance, downloading and installing applications, and more. It’s designed to streamline the setup and maintenance process by performing a series of automated actions.

This will render as:

## Installation

To download and run the script
```

 powershell -Command "Invoke-WebRequest -Uri 'https://github.com/catsmoker/cs_script/releases/download/script/cs_script.ps1' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'cs_script.ps1'))" 

```

## Features

1. **Scan and Fix Windows**: Runs the System File Checker (SFC) and DISM to scan and repair system files.
2. **Clean Windows**: Performs system cleanup tasks to free up disk space and improve performance.
3. **Download and Install Applications**: Downloads and installs the some applications.
4. **Activate windows**: Attempts to activate windows. Note: Activation may require manual intervention or a separate tool.
5. **Download Atlas OS Playbook and ame wizard**: Downloads the Atlas OS playbook and ame wizard for your reference.

## Attention
The script is designed to run on Windows 10 & 11 (64-bit only).

### Recommendation
- It is recommended to use the provided `.ps1` script for streamlined execution.
