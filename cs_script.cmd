@echo off
setlocal EnableDelayedExpansion

:: Check if the script is running with administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    :: The script is not running as admin, restart with elevation
    echo Requesting administrative privileges...
    set "batchPath=%~f0"
    :: Start a new Command Prompt with elevated privileges
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%batchPath%\"' -Verb RunAs"
    goto menu
)

goto menu

::============================================================================
::
::
::   Homepages: https://github.com/catsmoker/cs_script.bat
::   
::
::   Please Check my website: https://catsmoker.github.io
::
::
::       Email: boulhada08@gmail.com
::
::============================================================================

:menu
cls
echo                                               cs Script v1.6 (by catsmoker) https://catsmoker.github.io
echo                                                                run as administrator
echo                                                              "windows 10 & 11 64bit only"
echo Select an option:
echo 1. Scan, Fix, clean Windows
echo 2. Download Specific Applications
echo 3. Activate Windows
echo 4. Download Atlas OS Playbook and AME Wizard
echo x. Exit

powershell -Command "$null = New-Item -Path ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'CS Downloads')) -ItemType Directory -ErrorAction SilentlyContinue"

set /p choice=Enter your choice (1-5): 

if "%choice%"=="1" goto scan_fix_windows
if "%choice%"=="2" goto download_apps
if "%choice%"=="3" goto activate_windows
if "%choice%"=="4" goto ame_playbook
if "%choice%"=="x" goto exit_script
echo Invalid choice. Please enter a number between 1 and 5 or x.
goto menu

:scan_fix_windows
cls

:: Clean Windows Temp folder
echo Cleaning Windows Temp folder...
del /q /f /s %temp%\*

:: Clean System Temp folder
echo Cleaning System Temp folder...
del /q /f /s C:\Windows\Temp\*

:: Clean Prefetch folder
echo Cleaning Prefetch folder...
del /q /f /s C:\Windows\Prefetch\*

:: Clean Internet Explorer cache
echo Cleaning Internet Explorer cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

:: Clean Recycle Bin
echo Emptying Recycle Bin...
rd /s /q C:\$Recycle.Bin

:: Run Disk Cleanup
echo Running Disk Cleanup...
cleanmgr /sagerun:1

echo Cleanup complete.

echo Scanning and fixing Windows...
sfc /scannow

echo Running DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth

echo Done!
pause
goto menu

:download_apps
cls
echo Downloading specific applications...
echo Select an option:
echo 1. Upgrade all packages
echo 2. Firefox
echo 3. qBittorrent
echo 4. Neat Download Manager
echo 5. mem reduct
echo 6. VLC
echo 7. bcuninstaller
echo x. Exit

set /p choice=Enter your choice (1-7): 

if "%choice%"=="1" goto upgrade
if "%choice%"=="2" goto Firefox
if "%choice%"=="3" goto qBittorrent
if "%choice%"=="4" goto neat
if "%choice%"=="5" goto mem
if "%choice%"=="6" goto vlc
if "%choice%"=="7" goto BCU
if "%choice%"=="x" goto menu
echo Invalid choice. Please enter a number between 1 and 7 or x.
goto download_apps

:upgrade
cls
echo Upgrading all packages using winget...
winget upgrade --all
if %errorlevel% neq 0 (
    echo please go to https://winget.run/
    pause
    goto menu
)
echo Done!
pause
goto menu

:vlc
cls
echo Installing VLC...
winget install -e --id VideoLAN.VLC
if %errorlevel% neq 0 (
    echo Installation failed. Please go to https://www.videolan.org/vlc/
    pause
    goto menu
)
echo Done!
pause
goto menu

:Firefox
cls
echo Installing Firefox...
winget install -e --id Mozilla.Firefox
if %errorlevel% neq 0 (
    echo Installation failed. Please go to https://www.mozilla.org/en-US/firefox/new/
    pause
    goto menu
)
echo Done!
pause
goto menu

:qBittorrent
cls
echo Installing qBittorrent...
winget install -e --id qBittorrent.qBittorrent
if %errorlevel% neq 0 (
    echo Installation failed. Please go to https://www.qbittorrent.org/download
    pause
    goto menu
)
echo Done!
pause
goto menu

:neat
cls
echo Installing Neat Download Manager...
winget install -e --id JavadMotallebi.NeatDownloadManager
if %errorlevel% neq 0 (
    echo winget installation failed.
    echo Please go to https://www.neatdownloadmanager.com/index.php/en/
    powershell -Command "Invoke-WebRequest -Uri 'https://www.neatdownloadmanager.com/file/NeatDM_setup.exe' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'NeatDM_setup.exe'))"
    start /wait %USERPROFILE%\Desktop\NeatDM_setup.exe
    echo Installation complete.
    pause
    goto menu
)
echo Done!
pause
goto menu

:mem
cls
echo Downloading mem reduct...
winget install -e --id Henry++.MemReduct
if %errorlevel% neq 0 (
    echo Installation failed. Please go to https://github.com/henrypp/memreduct/releases
    pause
    goto menu
)
echo Done!
pause
goto menu

:BCU
cls
echo Downloading BC Uninstaller...
winget install -e --id Klocman.BulkCrapUninstaller
if %errorlevel% neq 0 (
    echo Installation failed. Please go to https://www.bcuninstaller.com/
    pause
    goto menu
)
echo Done!
pause
goto menu

:activate_windows
cls
echo Activating Windows...
echo                             use PowerShell (Recommended)
echo       1. Right-click on the Windows start menu and select PowerShell or Terminal (Not CMD).
echo       2. Copy and paste the code below and press enter
echo       3. "irm https://get.activated.win | iex"
powershell -Command "irm https://get.activated.win | iex"
echo -or open this in your browser-
echo https://github.com/massgravel/Microsoft-Activation-Scripts?tab=readme-ov-file#download--how-to-use-it
start https://github.com/massgravel/Microsoft-Activation-Scripts?tab=readme-ov-file#download--how-to-use-it
echo Done!
pause
goto menu

:ame_playbook
cls
echo Downloading Atlas OS playbook...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Atlas-OS/Atlas/releases/download/0.4.0/AtlasPlaybook_v0.4.0.zip' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'CS Downloads', 'AtlasPlaybook_v0.4.0.zip'))"
if %errorlevel% neq 0 (
    echo Failed to download Atlas OS playbook. Please visit https://atlasos.net/
    start https://atlasos.net/
    pause
    goto menu
)
echo Downloading AME Wizard to Desktop...
powershell -Command "Invoke-WebRequest -Uri 'https://download.ameliorated.io/AME%20Wizard%20Beta.zip' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'CS Downloads', 'AME Wizard Beta.zip'))"
if %errorlevel% neq 0 (
    echo Failed to download AME Wizard. Please visit https://ameliorated.io/
    start https://ameliorated.io/
    pause
    goto menu
)

echo Downloads completed successfully!
pause
goto menu

:exit_script
cls
echo Exiting script.
start https://catsmoker.github.io
:: End of script
exit /b
