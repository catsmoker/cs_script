# Windows Automation Script

![Screenshot 2025-05-29 145504](https://github.com/user-attachments/assets/583073c5-1ea0-4d7b-837b-06cd45cc9a28)

This script leverages free, open-source tools to automate various tasks on a Windows system, such as system maintenance, application installation, and more. It is designed to streamline the setup and maintenance process, making it easier to manage your Windows environment with minimal manual intervention.

## Installation

put this in powershell not cmd
```
irm catsmoker.github.io/w | iex
```
or use the installation .exe in releases

## Attention
The script is designed to run on Windows 10 & 11 only.

## Features Overview

### System Maintenance
- **Clean Windows**  
  Removes temporary files, clears Recycle Bin, flushes DNS cache, and cleans event logs
- **Scan and Fix Windows**  
  Runs chkdsk, sfc /scannow, and DISM to repair system files
- **Virus Scan**  
  Runs Windows Malicious Software Removal Tool (MRT)

### Software Management
- **Apps/Upgrades**  
  Winget-based software installer/updater with 30+ popular applications
- **Activate IDM**  
  Activates Internet Download Manager
- **Activate Windows/Office**  
  Windows and Office activation script

### Network Tools
- **DNS Configuration**  
  Set Google/Cloudflare DNS or reset to DHCP
- **Network Information**  
  View detailed network configuration
- **Adapter Management**  
  Reset network adapters and flush DNS
- **Routing Table**  
  View network routing information
- **Winsock Reset**  
  Reset Windows networking to default

### Registry Tools
- **Registry Cleaner**  
  Safe removal of temporary registry entries
- **Registry Backup**  
  Full registry backup to .reg file
- **Registry Restore**  
  Restore registry from backup
- **Registry Optimizer**  
  Performance tweaks for better system responsiveness

### System Utilities
- **Windows Update**  
  PSWindowsUpdate module for update management
- **System Report**  
  Generate comprehensive system diagnostics
- **CTT Windows Utility**  
  Launch Chris Titus Tech's optimization tool
- **Add Shortcut**  
  Create desktop shortcut for easy access

## Detailed Function Documentation

### System Maintenance Functions

#### Clean Windows
- Cleans global and user temp folders
- Empties Recycle Bin
- Flushes DNS cache
- Clears all Windows event logs
- Cleans Windows prefetch data

#### Scan and Fix Windows
1. Runs `chkdsk /scan /perf`
2. Runs `sfc /scannow`
3. Runs `DISM /Online /Cleanup-Image /RestoreHealth`

#### Virus Scan (MRT)
- Automatically downloads MRT if missing
- Runs full system scan
- Logs results

### Software Management

#### Apps/Upgrades
Supported applications include:
- Browsers: Chrome, Firefox, Brave, Tor, etc.
- Media: VLC, Spotify, foobar2000
- Utilities: 7-Zip, Everything, ShareX
- Development: Git, VSCode, Notepad++
- Gaming: Steam, Playnite, Heroic

#### Activation Tools
- IDM activation via external script
- Windows/Office activation via MAS

### Network Tools

#### DNS Configuration
Presets available:
- Google DNS: 8.8.8.8, 8.8.4.4
- Cloudflare DNS: 1.1.1.1, 1.0.0.1
- Custom DNS input
- DHCP reset

#### Network Diagnostics
- IP configuration viewer
- Adapter reset (disable/enable)
- Winsock catalog reset
- IP release/renew

### Registry Tools

#### Cleaning
Targets safe-to-remove keys:
- Recent documents history
- Run command history
- Open/save dialog history

#### Backup/Restore
- Full registry export to .reg file
- Selective restore from backup
- Automatic backup naming with timestamp

#### Optimization
Tweaks include:
- Disable NTFS last access time
- Enable large system cache
- Disable paging executive
- Adjust I/O page lock limit

### System Utilities

#### Windows Update
- Installs PSWindowsUpdate module
- Checks for Microsoft updates
- Installs all available updates
- Automatic reboot if needed

#### System Report
Generates report with:
- System information
- Network configuration
- Installed programs
- Running services
- Disk information

## System Requirements
- Windows 10/11
- PowerShell 5.1+
- Administrator privileges
- Internet connection (for some features)

## Usage
1. Run script as Administrator
2. Select desired function from GUI
3. Follow on-screen instructions
4. Reboot when recommended

## License
Free for personal use

## Credits
Developed by [catsmoker](https://catsmoker.github.io)

Includes components from:
- Microsoft
- Chris Titus Tech
- Community contributors
