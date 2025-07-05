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

$WORKDIR="$env:temp\WSBG"
$BGFILE="$WORKDIR\wsbg.png"

# Make workdir
New-Item -Path $WORKDIR -ItemType Directory -Force


# Detect host display resolution
if ($WIDTH -eq 0 -or $HEIGHT -eq 0){
    Add-Type -AssemblyName System.Windows.Forms
    $WIDTH = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $HEIGHT = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
}

# Capture Image
Write-Host "Fetching screenshot from ${URL}"
Start-Process -FilePath "msedge.exe" -ArgumentList "--headless", "--window-size=$WIDTH,$HEIGHT", "--virtual-time-budget=5000", "--timeout=5000", "--screenshot=$BGFILE", "`"$URL`"" -Wait

# Set Background
# Reference: https://c-nergy.be/blog/?p=15291
$CODE = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
    }
 } 
'@

add-type $CODE 

[Win32.Wallpaper]::SetWallpaper($BGFILE)