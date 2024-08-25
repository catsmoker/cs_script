#============================================================================
#
# WARNING: DO NOT modify this file!
#
#============================================================================
<#
.NOTES
    Author         : catsmoker
    Email          : boulhada08@gmail.com
    Website        : https://catsmoker.github.io
    GitHub         : https://github.com/catsmoker/cs_script
    Version        : 1.7
#>

# Set console properties
$Host.UI.RawUI.WindowTitle = "catsmoker: cs_script v1.7"
$host.UI.RawUI.ForegroundColor = "Green"
$host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "This script requires PowerShell 5.0 or newer." -ForegroundColor Red
    Write-Host "Your current PowerShell version is $($PSVersionTable.PSVersion)."
    exit 1
}

# Check OS version
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Major -lt 10 -or ($osVersion.Major -eq 10 -and $osVersion.Build -lt 17763)) {
    Write-Host "This script is only supported on Windows 10 version 1809 (build 17763) or newer." -ForegroundColor Red
    Write-Host "Your current OS version is $($osVersion.Major).$($osVersion.Minor) (Build $($osVersion.Build))."
    exit 1
}

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting administrative privileges..." -ForegroundColor Yellow
    $currentPath = $MyInvocation.MyCommand.Definition
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$currentPath`""
    exit
}

# Unblock the script if blocked
Unblock-File -Path $MyInvocation.MyCommand.Definition

# Verify administrative privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
if ($currentUser.Owner.Value -ne "S-1-5-32-544") {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    Write-Host "Please right-click on PowerShell and select 'Run as Administrator'." -ForegroundColor Red
    exit 1
}

# URL of the cloud script
$cloudScriptUrl = "https://catsmoker.github.io/w"

# Run the cloud-based script
Write-Host "Running the cloud script..." -ForegroundColor Cyan
Start-Process "powershell" -ArgumentList "iwr -useb $cloudScriptUrl | iex"

Write-Host "Script execution completed." -ForegroundColor Green
