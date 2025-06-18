$fileName = "CS_script.lnk"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$filePath = Join-Path -Path $desktopPath -ChildPath $fileName

if (Test-Path -Path $filePath -PathType Leaf) {
# Message
    Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
    "Shortcut already installed $shortcutPath", 
    "Installation Complete", 
    [System.Windows.Forms.MessageBoxButtons]::OK, 
    [System.Windows.Forms.MessageBoxIcon]::Information
)
Write-Host "Shortcut already installed $shortcutPath" -ForegroundColor Green

} else {
    Write-Host "File not found on desktop."


# Define the path to the shortcut and the target PowerShell command
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'CS_script.lnk')
$targetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$arguments = '-NoProfile -ExecutionPolicy Bypass -Command "irm https://catsmoker.github.io/w | iex"'

# Define the URL for the icon and the path to save it locally
$iconUrl = "https://catsmoker.github.io/web/assets/ico/favicon.ico"
New-Item -ItemType Directory -Path "C:\Catsmoker\icon" -Force | Out-Null
$localIconPath = "C:\Catsmoker\icon\favicon.ico"

# Download the icon
Invoke-WebRequest -Uri $iconUrl -OutFile $localIconPath -UseBasicParsing

# Create the shortcut
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.Arguments = $arguments
$shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($targetPath)
$shortcut.IconLocation = $localIconPath
$shortcut.Save()

# Open the shortcut properties and try to trigger 'Run as administrator'
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace([System.IO.Path]::GetDirectoryName($shortcutPath))
$item = $folder.ParseName([System.IO.Path]::GetFileName($shortcutPath))

# Launch Properties dialog and send keys
$item.InvokeVerb("Properties")
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("%d")         # ALT+D: open Advanced
Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait(" ")          # SPACE: check the box
Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")    # ENTER: close Advanced
Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")    # ENTER: close Properties

# Message
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
    "Shortcut created successfully $shortcutPath", 
    "Installation Complete", 
    [System.Windows.Forms.MessageBoxButtons]::OK, 
    [System.Windows.Forms.MessageBoxIcon]::Information
)
Write-Host "Shortcut created successfully $shortcutPath" -ForegroundColor Green

}
