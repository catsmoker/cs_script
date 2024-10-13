# Set the global error action preference to continue
$ErrorActionPreference = "Continue"

# Function to remove a registry value if it exists
function Remove-RegistryValue {
    param (
        [Parameter(Mandatory = $true)]
        [string]$RegistryPath,

        [Parameter(Mandatory = $true)]
        [string]$ValueName
    )

    # Check if the registry path exists
    if (Test-Path -Path $RegistryPath) {
        # Attempt to retrieve the registry value
        $registryValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue

        if ($registryValue) {
            # Remove the registry value
            Remove-ItemProperty -Path $RegistryPath -Name $ValueName -Force
            Write-Host "Registry value '$ValueName' removed from '$RegistryPath'."
        } else {
            Write-Host "Registry value '$ValueName' not found in '$RegistryPath'."
        }
    } else {
        Write-Host "Registry path '$RegistryPath' not found."
    }
}

# Log first startup event
$logFile = "$env:HOMEDRIVE\windows\LogFirstRun.txt"
"FirstStartup has worked" | Out-File -FilePath $logFile -Append -NoClobber

# Taskbar cleanup
$taskbarPath = "$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
if (Test-Path -Path $taskbarPath) {
    # Delete all files from the Taskbar directory
    Get-ChildItem -Path $taskbarPath -File | Remove-Item -Force
    Write-Host "Taskbar items cleared."
} else {
    Write-Host "Taskbar path not found."
}

# Remove specific registry values related to taskbar favorites
$taskbandPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
$taskbandValues = @("FavoritesRemovedChanges", "FavoritesChanges", "Favorites")
foreach ($value in $taskbandValues) {
    Remove-RegistryValue -RegistryPath $taskbandPath -ValueName $value
}

# Edge icon removal from the desktop
$desktopPath = "$env:USERPROFILE\Desktop"
$edgeShortcutFiles = Get-ChildItem -Path $desktopPath -Filter "*Edge*.lnk" -ErrorAction SilentlyContinue

if ($edgeShortcutFiles) {
    foreach ($shortcutFile in $edgeShortcutFiles) {
        Remove-Item -Path $shortcutFile.FullName -Force
        Write-Host "Edge shortcut '$($shortcutFile.Name)' removed from the desktop."
    }
} else {
    Write-Host "No Edge shortcuts found on the desktop."
}

# Remove all desktop shortcuts (.lnk files)
Remove-Item -Path "$desktopPath\*.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:HOMEDRIVE\Users\Default\Desktop\*.lnk" -Force -ErrorAction SilentlyContinue

# ************************************************
# Create cs_script shortcut on the desktop
# ************************************************
$command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command 'irm https://catsmoker.github.io/w | iex'"
$shortcutPath = Join-Path $desktopPath 'cs_script.lnk'

# Create the shortcut object
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)

# Set shortcut icon if available
$iconPath = "$env:HOMEDRIVE\Windows\cs_script.png"
if (Test-Path -Path $iconPath) {
    $shortcut.IconLocation = $iconPath
}

# Configure shortcut properties
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$command`""
$shortcut.Save()

# Modify shortcut to run as administrator
$bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes($shortcutPath, $bytes)

Write-Host "Shortcut created at: $shortcutPath with 'Run as Administrator' enabled."

# ************************************************
# Optional Feature: Disable "Recall" if it exists
# ************************************************
try {
    $recallFeature = Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "Recall" }
    if ($recallFeature) {
        Disable-WindowsOptionalFeature -Online -FeatureName "Recall" -Remove
        Write-Host "Optional feature 'Recall' disabled and removed."
    } else {
        Write-Host "Optional feature 'Recall' not found."
    }
} catch {
    Write-Host "An error occurred while attempting to disable the 'Recall' feature."
}
