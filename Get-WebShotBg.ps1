#=============================================================================
# Get-WebshotBg
# Captures a screenshot of a specified webpage
# and sets current desktop background to that.
#
# chlf.dev
# June 2025
#
# Usage:
# Get-WebShotBg -URL <url> [-WIDTH <width> -HEIGHT <height>]
#
# If WIDTH and/or HEIGHT not specifed, system primary display will be used.
#============================================================================

Param(
    [string]$URL,
    [int]$WIDTH = 0,
    [int]$HEIGHT = 0
)

$WORKDIR="$env:temp\WSBG\"

# Make workdir
New-Item -Path $WORKDIR -ItemType Directory -Force


# Detect host display resolution
if ($WIDTH -eq 0 -or $HEIGHT -eq 0){
    Add-Type -AssemblyName System.Windows.Forms
    $WIDTH = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $HEIGHT = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
}

# Capture Image
Start-Process -FilePath "msedge.exe" -ArgumentList "--headless", "--window-size=$WIDTH,$HEIGHT", "--virtual-time-budget=1000", "--screenshot=$WORKDIR\wsbg.png", "`"$URL`"" -Wait

# Set Background
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallPaper -Value "$WORKDIR\wsbg.png"
Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll, UpdatePerUserSystemParameters"
