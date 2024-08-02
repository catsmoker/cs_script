@echo off
setlocal EnableDelayedExpansion

::============================================================================
::
::   cs Script v1.1 (catsmoker) 
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
echo Select an option:
echo 1. Scan and Fix Windows
echo 2. Download Specific Applications
echo 3. Activate windows
echo 4. Download Atlas OS Playbook
echo 5. Exit

set /p choice=Enter your choice (1-5):

if "%choice%"=="1" goto scan_fix_windows
if "%choice%"=="2" goto download_apps
if "%choice%"=="3" goto activate_windows
if "%choice%"=="4" goto download_atlas_os_playbook
if "%choice%"=="5" goto exit_script
echo Invalid choice. Please enter a number between 1 and 5.
goto menu

:scan_fix_windows
cls
echo Scanning and fixing Windows...
sfc /scannow
if %errorlevel% neq 0 (
    echo sfc encountered an issue. Check the log for details.
    pause
    exit /b %errorlevel%
)
echo Running DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% neq 0 (
    echo DISM RestoreHealth encountered an issue. Check the log for details.
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu

:download_apps
cls
echo Downloading specific applications...
echo Select an option:
echo 1. vlc
echo 2. Firefox
echo 3. qBittorrent         not working
echo 4. neat                not working
echo 5. upgrade
echo 6. Exit

set /p choice=Enter your choice (1-6):

if "%choice%"=="1" goto vlc
if "%choice%"=="2" goto Firefox
if "%choice%"=="3" goto aqBittorrent
if "%choice%"=="4" goto neat
if "%choice%"=="5" goto upgrade
if "%choice%"=="6" goto exit_script
echo Invalid choice. Please enter a number between 1 and 6.
goto menu

:upgrade
cls
echo Upgrading all packages using winget...
winget upgrade --all
if %errorlevel% neq 0 (
    echo please go to https://winget.run/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu
:vlc
cls
echo Installing VLC...
winget install -e --id VideoLAN.VLC
if %errorlevel% neq 0 (
    echo please go to https://www.videolan.org/vlc/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu
:Firefox
cls
echo Installing Firefox...
winget install -e --id Mozilla.Firefox
if %errorlevel% neq 0 (
    echo please go to https://www.mozilla.org/en-US/firefox/new/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu
:qBittorrent
cls
echo Installing qBittorrent...
winget install -e --id qBittorrent.qBittorrent
if %errorlevel% neq 0 (
    echo please go to https://www.qbittorrent.org/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu
:neat
cls
echo Installing Neat Download Manager...
winget install -e --id JavadMotallebi.NeatDownloadManager
if %errorlevel% neq 0 (
    echo please go to https://www.neatdownloadmanager.com/index.php/en/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu

:activate_windows
cls
echo Activating windows...
echo open this in your browser...
https://github.com/massgravel/Microsoft-Activation-Scripts?tab=readme-ov-file#download--how-to-use-it
echo Done!
pause
goto menu

:download_atlas_os_playbook
cls
echo Downloading Atlas OS playbook...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Atlas-OS/Atlas/releases/download/0.4.0/AtlasPlaybook_v0.4.0.zip' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'AtlasPlaybook_v0.4.0.zip'))"
if %errorlevel% neq 0 (
    echo please go to https://atlasos.net/
    pause
    exit /b %errorlevel%
)
echo Downloading ame to Desktop / not working cuz of %20...
powershell -Command "Invoke-WebRequest -Uri 'https://download.ameliorated.io/AME%20Wizard%20Beta.zip' -OutFile ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'AME Wizard Beta.zip'))"
if %errorlevel% neq 0 (
    echo please go to https://ameliorated.io/
    pause
    exit /b %errorlevel%
)
echo Done!
pause
goto menu

:exit_script
cls
echo Exiting script.
pause
exit /b
