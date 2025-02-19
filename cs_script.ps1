#============================================================================
#
# WARNING: DO NOT modify this file!
#
#============================================================================
<#
.NOTES
    Author         : catsmoker
    Email          : catsmoker.lab@gmail.com
    Website        : https://catsmoker.github.io
    GitHub         : https://github.com/catsmoker/cs_script
    Version        : 1.8
#>

#region Initialization and Admin Check
Write-Host "Checking if running as administrator..." -ForegroundColor Cyan
$adminCheck = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $adminCheck.IsInRole($adminRole)) {
    $separator = "============================================================="
    $adminMessage = "Attention Required!"
    Write-Host $separator -ForegroundColor Yellow
    Write-Host $adminMessage -ForegroundColor Red -BackgroundColor Black
    Write-Host "Oops! This script requires administrator privileges to run." -ForegroundColor Magenta
    Write-Host "Attempting to relaunch with elevated rights... Please wait." -ForegroundColor Green
    Write-Host $separator -ForegroundColor Yellow

    # Restart the script with administrative privileges
    try {
        $newProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
        exit
    } catch {
        Write-Host "Failed to restart with administrator privileges. Please run this script as an administrator." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Script is running as administrator." -ForegroundColor Green
}
#endregion

#region OS Version Check
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Major -lt 10 -or ($osVersion.Major -eq 10 -and $osVersion.Minor -lt 0)) {
    Write-Host "This script is only supported on Windows 10 or newer." -ForegroundColor Red
    Write-Host "Your current OS version is $($osVersion.Major).$($osVersion.Minor)." -ForegroundColor Yellow
    exit
}
#endregion

#region Shortcut Creation
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'CS_script.lnk')
$targetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"powershell.exe -NoProfile -ExecutionPolicy Bypass -Command 'irm https://catsmoker.github.io/w | iex'`""
$iconUrl = "https://catsmoker.github.io/web/assets/ico/favicon.ico"
$localIconPath = "C:\favicon.ico"

try {
    Invoke-WebRequest -Uri $iconUrl -OutFile $localIconPath -ErrorAction Stop
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Arguments = $arguments
    $shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($targetPath)
    $shortcut.IconLocation = $localIconPath
    $shortcut.Save()
    Write-Host "Shortcut created successfully on the desktop." -ForegroundColor Green
} catch {
    Write-Host "Failed to create shortcut: $_" -ForegroundColor Red
}
#endregion

#region GUI Setup
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Main Form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "CS Script v1.8 by catsmoker"
$mainForm.Size = New-Object System.Drawing.Size(800, 600)
$mainForm.StartPosition = "CenterScreen"
$mainForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$mainForm.ForeColor = [System.Drawing.Color]::White
$mainForm.FormBorderStyle = 'FixedDialog'
$mainForm.MaximizeBox = $false

# Title and Subtitle Labels
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "CS Script v1.8"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.Size = New-Object System.Drawing.Size(400, 40)
$titleLabel.Location = New-Object System.Drawing.Point(200, 20)
$titleLabel.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center
$mainForm.Controls.Add($titleLabel)

$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "by catsmoker | https://catsmoker.github.io"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
$subtitleLabel.Size = New-Object System.Drawing.Size(400, 20)
$subtitleLabel.Location = New-Object System.Drawing.Point(200, 60)
$subtitleLabel.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center
$mainForm.Controls.Add($subtitleLabel)

# Buttons
$buttons = @(
    @{Text = "Clean Windows"; Action = { Clean-Windows }},
    @{Text = "Scan and Fix Windows"; Action = { Fix-Windows }},
    @{Text = "Apps/Upgrades"; Action = { Download-Apps }},
    @{Text = "Activate Windows"; Action = { Activate-Windows }},
    @{Text = "Windows Update"; Action = { windows-ps }},
    @{Text = "CTT Windows Utility"; Action = { CTT }},
    @{Text = "Exit"; Action = { Exit-Script }}
)

$y = 120
foreach ($button in $buttons) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $button.Text
    $btn.Size = New-Object System.Drawing.Size(200, 40)
    $btn.Location = New-Object System.Drawing.Point(50, $y)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(70, 130, 180)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0
    $btn.Add_Click($button.Action)
    $mainForm.Controls.Add($btn)
    $y += 60
}

# Progress Bar and Status Label
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(500, 20)
$progressBar.Location = New-Object System.Drawing.Point(50, 530)
$progressBar.Style = 'Continuous'
$mainForm.Controls.Add($progressBar)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready"
$statusLabel.Size = New-Object System.Drawing.Size(500, 20)
$statusLabel.Location = New-Object System.Drawing.Point(50, 560)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$mainForm.Controls.Add($statusLabel)
#endregion

#region Functions
Function Clean-Windows {
    $statusLabel.Text = "Cleaning Windows..."
    $progressBar.Value = 0

    # Clean Temp Folders
    $tempPaths = @([System.IO.Path]::GetTempPath(), $env:TEMP)
    foreach ($path in $tempPaths) {
        Write-Host "Clearing temp folder: $path"
        $files = Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        $count = 0
        foreach ($file in $files) {
            $count++
            $progressBar.Value = ($count / $files.Count) * 100
            Remove-Item -Path $file.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # Clean Recycle Bin
    Write-Host "Emptying Recycle Bin..."
    (New-Object -ComObject Shell.Application).NameSpace(0xA).Items() | ForEach-Object { $_.InvokeVerb("delete") }

    # Flush DNS Cache
    Write-Host "Flushing DNS Cache..."
    Start-Process "ipconfig" -ArgumentList "/flushdns" -NoNewWindow -Wait

    # Clear Windows Update Cache
    Write-Host "Clearing Windows Update Cache..."
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue

    # Clear Thumbnail Cache
    Write-Host "Clearing Thumbnail Cache..."
    Remove-Item -Path "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue

    $progressBar.Value = 100
    $statusLabel.Text = "Cleanup completed!"
}

Function Fix-Windows {
    $statusLabel.Text = "Scanning and fixing Windows..."
    $progressBar.Value = 0

    # Run system repair commands
    $commands = @(
        @{Name = "chkdsk"; Args = "/scan /perf"},
        @{Name = "sfc"; Args = "/scannow"},
        @{Name = "DISM"; Args = "/Online /Cleanup-Image /RestoreHealth"}
    )

    foreach ($cmd in $commands) {
        Write-Host "Running $($cmd.Name)..."
        Start-Process -FilePath "$($cmd.Name).exe" -ArgumentList $cmd.Args -NoNewWindow -Wait
    }

    # Repair Windows System Files
    Write-Host "Repairing Windows System Files..."
    Start-Process "powershell" -ArgumentList "Repair-WindowsImage -Online -RestoreHealth" -NoNewWindow -Wait

    # Reset Windows Update Components
    Write-Host "Resetting Windows Update Components..."
    Start-Process "powershell" -ArgumentList "Reset-WindowsUpdateComponents" -NoNewWindow -Wait

    $progressBar.Value = 100
    $statusLabel.Text = "Fix completed!"
}

Function Download-Apps {
    $statusLabel.Text = "Opening Apps/Drivers menu..."
    $statusLabel.Text = "Opening Apps/Drivers menu..."
    # Check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not installed. Attempting to install..."

        # Download the latest version of the App Installer from the Microsoft Store
        $installerUrl = "https://aka.ms/getwinget"
        
        # Define the path for the installer
        $installerPath = "$env:TEMP\AppInstaller.msixbundle"

        # Download the installer
        try {
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
            Write-Host "Downloaded winget installer."

            # Install the downloaded package
            Add-AppxPackage -Path $installerPath
            Write-Host "winget installation completed."
        } catch {
            Write-Host "Failed to download or install winget. Please try again."
            Write-Host $_.Exception.Message
            Pause
            return
        }
    } else {
        Write-Host "winget is already installed."
    }

    # Load necessary assemblies for GUI
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the main form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Install Software | cs_script by catsmoker"
    $Form.Size = New-Object System.Drawing.Size(450, 600)
    $Form.StartPosition = "CenterScreen"
    $Form.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)  # Dark background
    $Form.FormBorderStyle = 'FixedDialog'
    $Form.MaximizeBox = $false

    # Create a label
    $Label = New-Object System.Windows.Forms.Label
    $Label.Location = New-Object System.Drawing.Size(20, 20)
    $Label.Size = New-Object System.Drawing.Size(400, 30)
    $Label.Text = "Select software to install:"
    $Label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $Label.ForeColor = [System.Drawing.Color]::White
    $Form.Controls.Add($Label)

    # Create a Panel to hold the checkboxes
    $Panel = New-Object System.Windows.Forms.Panel
    $Panel.Location = New-Object System.Drawing.Size(20, 60)
    $Panel.Size = New-Object System.Drawing.Size(400, 400)  # Adjust height for 15 items with room for scrolling
    $Panel.AutoScroll = $true  # Enable scrolling
    $Panel.BorderStyle = 'FixedSingle'
    $Panel.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 35)  # Slightly darker panel background
    $Form.Controls.Add($Panel)

    # Create a list of software items
    $softwareItems = @{
        "Ungoogled Chromium" = "eloston.ungoogled-chromium"
        "Mozilla Firefox" = "Mozilla.Firefox"
        "Waterfox" = "Waterfox.Waterfox"
        "Brave Browser" = "Brave.Brave"
        "Google Chrome" = "Google.Chrome"
        "LibreWolf" = "LibreWolf.LibreWolf"
        "Tor Browser" = "TorProject.TorBrowser"
        "Discord" = "Discord.Discord"
        "Discord Canary" = "Discord.Discord.Canary"
        "Steam" = "Valve.Steam"
        "Playnite" = "Playnite.Playnite"
        "Heroic" = "HeroicGamesLauncher.HeroicGamesLauncher"
        "Everything" = "voidtools.Everything"
        "Mozilla Thunderbird" = "Mozilla.Thunderbird"
        "foobar2000" = "PeterPawlowski.foobar2000"
        "IrfanView" = "IrfanSkiljan.IrfanView"
        "Git" = "Git.Git"
        "VLC" = "VideoLAN.VLC"
        "PuTTY" = "PuTTY.PuTTY"
        "Ditto" = "Ditto.Ditto"
        "7-Zip" = "7zip.7zip"
        "Teamspeak" = "TeamSpeakSystems.TeamSpeakClient"
        "Spotify" = "Spotify.Spotify"
        "OBS Studio" = "OBSProject.OBSStudio"
        "MSI Afterburner" = "Guru3D.Afterburner"
        "CPU-Z" = "CPUID.CPU-Z"
        "GPU-Z" = "TechPowerUp.GPU-Z"
        "Notepad++" = "Notepad++.Notepad++"
        "VSCode" = "Microsoft.VisualStudioCode"
        "VSCodium" = "VSCodium.VSCodium"
        "BCUninstaller" = "Klocman.BulkCrapUninstaller"
        "HWiNFO" = "REALiX.HWiNFO"
        "Lightshot" = "Skillbrains.Lightshot"
        "ShareX" = "ShareX.ShareX"
        "Snipping Tool" = "9MZ95KL8MR0L"
        "ExplorerPatcher" = "valinet.ExplorerPatcher"
        "MemReduct" = "Henry++.MemReduct"
    }

    # Add checkboxes for each software item
    $y = 0
    foreach ($name in $softwareItems.Keys) {
        $checkbox = New-Object System.Windows.Forms.CheckBox
        $checkbox.Location = New-Object System.Drawing.Size(10, $y)
        $checkbox.Size = New-Object System.Drawing.Size(360, 25)
        $checkbox.Text = $name
        $checkbox.Name = $softwareItems[$name]
        $checkbox.ForeColor = [System.Drawing.Color]::White
        $checkbox.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 35)
        $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $Panel.Controls.Add($checkbox)
        $y += 30
    }

    # Create Install button
    $InstallButton = New-Object System.Windows.Forms.Button
    $InstallButton.Location = New-Object System.Drawing.Size(185, 480)
    $InstallButton.Size = New-Object System.Drawing.Size(100, 40)
    $InstallButton.Text = "Install"
    $InstallButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $InstallButton.BackColor = [System.Drawing.Color]::FromArgb(70, 130, 180)  # SteelBlue color
    $InstallButton.ForeColor = [System.Drawing.Color]::White
    $InstallButton.FlatStyle = 'Flat'
    $InstallButton.FlatAppearance.BorderSize = 0
    $InstallButton.Add_Click({
        $checkedBoxes = $Panel.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Checked }
        if ($checkedBoxes.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Please select at least one software package to install.", "No package selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            # Run the upgrade command first
            Start-Process "winget" -ArgumentList "upgrade --all" -NoNewWindow -Wait

            $installPackages = $checkedBoxes | ForEach-Object { $_.Name }

            # Run the installation commands
            foreach ($package in $installPackages) {
                Start-Process "winget" -ArgumentList "install -e --id $package --accept-package-agreements --accept-source-agreements --disable-interactivity --force" -NoNewWindow
            }

            [System.Windows.Forms.MessageBox]::Show("Installation started. Please wait for the processes to complete.", "Installation Started", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    })
    $Form.Controls.Add($InstallButton)

    # Show the form
    [void] $Form.ShowDialog()
    $statusLabel.Text = "Ready"
}

Function Activate-Windows {
    $statusLabel.Text = "Activating Windows..."
    $progressBar.Value = 0

    # Check if Windows is already activated
    $activationStatus = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.LicenseStatus -eq 1 }).Count
    if ($activationStatus -gt 0) {
        Write-Host "Windows is already activated." -ForegroundColor Green
        $statusLabel.Text = "Windows is already activated."
        return
    }

    # Attempt activation
    try {
        Start-Process "powershell" -ArgumentList "irm https://get.activated.win | iex" -NoNewWindow -Wait
        Write-Host "Windows activation attempt completed." -ForegroundColor Green
    } catch {
        Write-Host "Failed to activate Windows: $_" -ForegroundColor Red
    }

    $progressBar.Value = 100
    $statusLabel.Text = "Windows activation completed!"
}

Function windows-ps {
    $statusLabel.Text = "Running Windows Update..."
    $progressBar.Value = 0

    try {
        Install-Module PSWindowsUpdate -Force -ErrorAction Stop
        Add-WUServiceManager -MicrosoftUpdate -ErrorAction Stop
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot | Out-File "C:\($env.computername-Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force
        Write-Host "Windows Update completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to run Windows Update: $_" -ForegroundColor Red
    }

    $progressBar.Value = 100
    $statusLabel.Text = "Windows Update completed!"
}

Function CTT {
    $statusLabel.Text = "Running CTT Windows Utility..."
    $progressBar.Value = 0

    try {
        Start-Process "powershell" -ArgumentList "iwr -useb https://christitus.com/win | iex" -NoNewWindow -Wait
        Write-Host "CTT Windows Utility completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to run CTT Windows Utility: $_" -ForegroundColor Red
    }

    $progressBar.Value = 100
    $statusLabel.Text = "CTT completed!"
}

Function Exit-Script {
    $mainForm.Close()
}
#endregion

# Show the Main Form
[void]$mainForm.ShowDialog()
