# ==============================
# Multi-File/Folder KaijuISO Creator GUI 
# Author: Kitichote Amornrattanabongkot
# Email: cupidfunk@gmail.com
# Create Date: 2025-08-21
# Modified Date: 2026-02-10
# Application: KaijuISO Creator
# Version: 1.9.0
# Description: A PowerShell script to create ISO files from multiple files or folders using oscdimg.
# This script provides a GUI for users to drag and drop files/folders, start the ISO creation process, and view progress.
# Requirements: PowerShell, oscdimg utility (part of Windows ADK)
# ==============================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

$AppName = 'KaijuISO'
$BaseDir = Join-Path $env:LOCALAPPDATA $AppName
$startupLog = Join-Path $BaseDir 'startup.log'
New-Item -ItemType Directory -Path $BaseDir -Force | Out-Null

function SLog([string]$m) {
    try { Add-Content -Path $startupLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff') $m" } catch {}
}

SLog "BEGIN"

# catch แบบ global (ช่วยตอน exe เปิดไม่ขึ้น)
try {
    [System.Windows.Forms.Application]::add_ThreadException({
        param($sender, $e)
        SLog "ThreadException: $($e.Exception.ToString())"
    })
} catch {}

try {
    [AppDomain]::CurrentDomain.add_UnhandledException({
        param($sender, $e)
        SLog "UnhandledException: $($e.ExceptionObject.ToString())"
    })
} catch {}

# === Payload dir ===
$PayloadDir = Join-Path $env:LOCALAPPDATA "KaijuISO\payload"
New-Item -ItemType Directory -Path $PayloadDir -Force | Out-Null

$oscdimgPath = Join-Path $PayloadDir "oscdimg.exe"
$iconPath    = Join-Path $PayloadDir "kaijuiso_icon.ico"

function Get-CleanB64([string]$s, [string]$tokenName) {
    $t = ($s -replace '\s','')  # ลบ \r \n space ทั้งหมด
    if ([string]::IsNullOrWhiteSpace($t) -or $t -like "*__${tokenName}__*") {
        throw "Embedded $tokenName base64 is not set."
    }
    return $t
}

function Write-EmbeddedFile([string]$Path, [string]$B64, [string]$tokenName) {
    $dir = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $clean = Get-CleanB64 $B64 $tokenName
    $bytes = [Convert]::FromBase64String($clean)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

# === IMPORTANT: 2 ตัวนี้ต้องเป็น "base64 ล้วนๆ" เท่านั้น ===
$EmbeddedOscdimgB64 = @'
__OSCDIMG_B64__
'@

$EmbeddedIconB64 = @'
__ICON_B64__
'@

try {
    if (-not (Test-Path $oscdimgPath)) { Write-EmbeddedFile $oscdimgPath $EmbeddedOscdimgB64 'OSCDIMG_B64' }
    if (-not (Test-Path $iconPath))    { Write-EmbeddedFile $iconPath    $EmbeddedIconB64    'ICON_B64' }
    SLog "Payload extracted ok: $PayloadDir"
}
catch {
    SLog "PAYLOAD ERROR: $($_.Exception.ToString())"
    [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Payload error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit
}

# ลบตอนปิด (สะอาดสุด)
function Cleanup-Payload {
    try { Remove-Item $PayloadDir -Recurse -Force -ErrorAction SilentlyContinue } catch {}
    SLog "Payload cleaned"
}

try {
    if ([string]::IsNullOrWhiteSpace($EmbeddedOscdimgB64)) { throw "Embedded oscdimg base64 is empty." }
    if ([string]::IsNullOrWhiteSpace($EmbeddedIconB64))    { throw "Embedded icon base64 is empty." }

    # if (-not (Test-Path $oscdimgPath)) { Write-EmbeddedFile $oscdimgPath $EmbeddedOscdimgB64 }
    # if (-not (Test-Path $iconPath))    { Write-EmbeddedFile $iconPath    $EmbeddedIconB64 }
}
catch {
    [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Payload error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    exit
}

# === Resolve app dir (ps1/exe) ===
$AppDir = if ($PSCommandPath) { Split-Path -Parent $PSCommandPath } else { [System.AppDomain]::CurrentDomain.BaseDirectory.TrimEnd('\') }
Set-Location -Path $AppDir

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "KaijuISO"
$form.Size = New-Object System.Drawing.Size(700,500)
$form.StartPosition = "CenterScreen"

# icon: prefer exe icon, fallback payload icon (no file-lock)
function Get-IconNoLock([string]$path) {
    $bytes = [IO.File]::ReadAllBytes($path)
    $ms = New-Object IO.MemoryStream(,$bytes)
    $ico = New-Object System.Drawing.Icon($ms)
    $clone = $ico.Clone()
    $ico.Dispose()
    $ms.Dispose()
    return $clone
}

$form.ShowIcon = $true
try {
    $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    if ($exePath -and $exePath -notmatch '(?i)\\(powershell|pwsh)\.exe$') {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    } elseif (Test-Path $iconPath) {
        $form.Icon = Get-IconNoLock $iconPath
    }
} catch { SLog "Icon load failed: $($_.Exception.Message)" }


try {
    $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
} catch {}

if (-not $form.Icon -and (Test-Path $iconPath)) {
    $form.Icon = Get-IconNoLock $iconPath
}

try {
    [void]$form.ShowDialog()
}
finally {
    Cleanup-Payload
}
# ---- (ส่วน GUI ของคุณที่เหลือ ใส่ต่อได้ตามเดิม) ----
# *** สำคัญ: เวลา Start Process ให้ set $global:currentProc หลัง Start สำเร็จ ***
