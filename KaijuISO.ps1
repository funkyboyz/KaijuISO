# ==============================
# Multi-File/Folder KaijuISO Creator GUI 
# Author: Kitichote Amornrattanabongkot - Senior System Engineer - IFM/O - EP
# Email: zKitichote.a@pttdigital.com
# Date: 2025-08-21
# Application: KaijuISO Creator
# License: IFM/O - EP Infrastructure Internal Use Only
# Version: 1.0
# Description: A PowerShell script to create ISO files from multiple files or folders using oscdimg.
# This script provides a GUI for users to drag and drop files/folders, start the ISO creation process, and view progress.
# Requirements: PowerShell, oscdimg utility (part of Windows ADK)
# ==============================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

# === Check if Running as Release or Source ===
$EmbeddedOscdimgB64 = '__OSCDIMG_B64__'
$EmbeddedIconB64    = '__ICON_B64__'

# === Payload Setup ===
$AppName = 'KaijuISO'
$PayloadDir = Join-Path $env:LOCALAPPDATA "$AppName\payload"
$oscdimgPath = Join-Path $PayloadDir "oscdimg.exe"
$iconPath    = Join-Path $PayloadDir "kaijuiso_icon.ico"

# Function to extract embedded resources
function Extract-Resource {
    param ($Path, $B64)
    if ($B64 -eq '__OSCDIMG_B64__' -or $B64 -eq '__ICON_B64__') { return }
    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            $bytes = [Convert]::FromBase64String($B64)
            [IO.File]::WriteAllBytes($Path, $bytes)
        }
    } catch {}
}

# Cleanup & Init
try { Get-Process -Name "oscdimg" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue } catch {}
try { New-Item -ItemType Directory -Path $PayloadDir -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
Extract-Resource $oscdimgPath $EmbeddedOscdimgB64
Extract-Resource $iconPath    $EmbeddedIconB64

# === Resolve App Directory ===
$AppDir = if ($PSCommandPath) { Split-Path -Parent $PSCommandPath } else { [System.AppDomain]::CurrentDomain.BaseDirectory.TrimEnd('\') }
Set-Location -Path $AppDir

# === Logging System (LocalAppData) ===
$logDir = Join-Path $env:LOCALAPPDATA "KaijuISO\Logs"
$logFile = $null

try {
    if (-not (Test-Path -LiteralPath $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $logFile = Join-Path $logDir ("KaijuISO_{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
    "--- KaijuISO Log Started $(Get-Date) ---" | Out-File -FilePath $logFile -Encoding UTF8 -Force
} catch { $logFile = $null }

function Write-Log($msg) {
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $line = "$timestamp - $msg"
    try { $logBox.AppendText("$line`r`n"); $logBox.ScrollToCaret() } catch {}
    if ($logFile) { try { Add-Content -LiteralPath $logFile -Value $line -ErrorAction SilentlyContinue } catch {} }
}

# === GUI Setup ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "KaijuISO"
$form.Size = New-Object System.Drawing.Size(700,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Crash Handlers
[System.Windows.Forms.Application]::add_ThreadException({ param($s,$e) Write-Log "CRASH(Thread): $($e.Exception.Message)" })
[System.AppDomain]::CurrentDomain.add_UnhandledException({ param($s,$e) Write-Log "CRASH(Domain): $($e.ExceptionObject)" })

# Icon
try {
    $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    if ($exePath -notmatch '(?i)\\(powershell|pwsh)\.exe$') {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    } elseif (Test-Path -LiteralPath $iconPath) {
        $ms = New-Object IO.MemoryStream(,[IO.File]::ReadAllBytes($iconPath))
        $form.Icon = New-Object System.Drawing.Icon($ms)
        $ms.Dispose()
    }
} catch {}

# Controls
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,10); $listBox.Size = New-Object System.Drawing.Size(660,200)
$listBox.AllowDrop = $true
$listBox.Add_DragEnter({ if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) { $_.Effect = 'Copy' } })
$listBox.Add_DragDrop({ $listBox.Items.AddRange($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) })
$form.Controls.Add($listBox)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10,220); $progressBar.Size = New-Object System.Drawing.Size(660,20)
$form.Controls.Add($progressBar)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10,250); $statusLabel.Size = New-Object System.Drawing.Size(660,40)
$statusLabel.Text = "Ready."
$form.Controls.Add($statusLabel)

$startButton = New-Object System.Windows.Forms.Button; $startButton.Text = "Start"; $startButton.Location = New-Object System.Drawing.Point(10,300)
$cancelButton = New-Object System.Windows.Forms.Button; $cancelButton.Text = "Cancel"; $cancelButton.Location = New-Object System.Drawing.Point(100,300)
$clearButton = New-Object System.Windows.Forms.Button; $clearButton.Text = "Clear"; $clearButton.Location = New-Object System.Drawing.Point(190,300)
$openButton = New-Object System.Windows.Forms.Button; $openButton.Text = "Open Folder"; $openButton.Location = New-Object System.Drawing.Point(280,300)
$form.Controls.AddRange(@($startButton,$cancelButton,$clearButton,$openButton))

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(10,340); $logBox.Size = New-Object System.Drawing.Size(660,110)
$logBox.Multiline = $true; $logBox.ScrollBars = "Vertical"; $logBox.ReadOnly = $true; $logBox.Font = "Consolas,9"
$form.Controls.Add($logBox)

# === Event Handlers ===
$global:cancel = $false
$global:lastIsoPath = $null
$global:currentProc = $null

if ($logFile) { Write-Log "Log path: $logFile" }

$clearButton.Add_Click({ 
    $listBox.Items.Clear()
    $progressBar.Value = 0
    $statusLabel.Text = "List cleared."
    Write-Log "List cleared." 
})

$cancelButton.Add_Click({ 
    $global:cancel = $true
    try { if ($global:currentProc -and -not $global:currentProc.HasExited) { $global:currentProc.Kill() } } catch {}
    Write-Log "Cancelled." 
})

$openButton.Add_Click({ 
    if ($global:lastIsoPath -and (Test-Path -LiteralPath $global:lastIsoPath)) { 
        Start-Process explorer.exe "/select,`"$global:lastIsoPath`"" 
    } else { [System.Windows.Forms.MessageBox]::Show("No ISO created yet.", "Info", 0, 64) }
})

$startButton.Add_Click({
    if ($listBox.Items.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show("Please drop files first.", "Error", 0, 16); return }
    
    # [NEW] Modern Folder Picker Hack (OpenFileDialog with specific settings)
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Title = "Select Destination Folder (Type/Paste path enabled)"
    $ofd.ValidateNames = $false
    $ofd.CheckFileExists = $false
    $ofd.CheckPathExists = $true
    $ofd.FileName = "Select Folder Here" # ชื่อหลอกๆ เพื่อให้กด Open ได้เลย
    
    if ($ofd.ShowDialog() -ne "OK") { return }
    
    # ดึง path ของโฟลเดอร์ออกมาจาก filename ที่เลือก
    $destFolder = [System.IO.Path]::GetDirectoryName($ofd.FileName)

    $global:cancel = $false
    $total = $listBox.Items.Count; $count = 0
    $progressBar.Value = 0
    
    foreach ($item in $listBox.Items) {
        if ($global:cancel) { break }
        $count++
        
        $baseName = if (Test-Path -LiteralPath $item -PathType Leaf) { [System.IO.Path]::GetFileNameWithoutExtension($item) } else { [System.IO.Path]::GetFileName($item) }
        $isoPath = Join-Path $destFolder "$baseName.iso"
        
        $statusLabel.Text = "Processing $count / $total : $baseName"
        Write-Log "Building: $isoPath"

        $tool = if (Test-Path -LiteralPath $oscdimgPath) { $oscdimgPath } else { "oscdimg.exe" }
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $tool
        $psi.Arguments = "-n -m `"$item`" `"$isoPath`""
        $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
        $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true

        try {
            $global:currentProc = [System.Diagnostics.Process]::Start($psi)
            while (-not $global:currentProc.HasExited) {
                $percent = [int](($count / $total) * 100)
                if ($percent -gt 100) { $percent = 100 }
                $progressBar.Value = $percent
                Start-Sleep -Milliseconds 200
                [System.Windows.Forms.Application]::DoEvents() 
            }
            if (Test-Path -LiteralPath $isoPath) { 
                Write-Log "SUCCESS: $isoPath"
                $global:lastIsoPath = $isoPath 
            } else { 
                $errLog = $global:currentProc.StandardError.ReadToEnd()
                if ($errLog -match "complete") { Write-Log "WARNING: Verification skipped (Check folder)." } 
                else { Write-Log "ERROR: $errLog" }
            }
        } catch { Write-Log "EXEC ERROR: $($_.Exception.Message)" }
    }
    $progressBar.Value = 100; $statusLabel.Text = "Done."; Write-Log "All tasks completed."
})

$form.Add_FormClosing({
    try { if ($global:currentProc -and -not $global:currentProc.HasExited) { $global:currentProc.Kill() } } catch {}
    try { Remove-Item $PayloadDir -Recurse -Force -ErrorAction SilentlyContinue } catch {}
})

try { [void]$form.ShowDialog() } catch { Write-Log "CRITICAL GUI FAILURE: $($_.Exception.Message)" }