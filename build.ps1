<#
.SYNOPSIS
    KaijuISO - The Ultimate ISO Creator Tool
    
.DESCRIPTION
    A production-grade GUI tool to create ISO files from folders using oscdimg.
    Optimized for Windows 10/11 and PowerShell 7 Environment.

.PARAMETER None
    No parameters required. The script launches a GUI.

.NOTES
    Version:        1.9.0
    Author:         Kitichote Amornrattanabongkot (Senior System Engineer)
    Department:     IFM/O - EP
    Organization:   PTT Digital Solutions
    Created:        2025-08-21
    Last Updated:   2026-02-10
    
    Security Level: Internal Use Only
    Contact:        [Internal Email or Teams Link] (Do not put mobile number)
#>

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

Write-Host "--- KaijuISO Builder for PowerShell 7 ---" -ForegroundColor Magenta

# --- CONFIG ---
$SourceFile  = Join-Path $root 'KaijuISO.ps1' 
$ReleaseFile = Join-Path $root 'KaijuISO.release.ps1'
$ExeFile     = Join-Path $root 'KaijuISO.exe'
$OscdImgExe  = Join-Path $root 'oscdimg.exe'
$IconFile    = Join-Path $root 'kaijuiso_icon.ico'

# 1. Check Files
if (-not (Test-Path $SourceFile)) { Write-Error "Source file not found!"; exit }
if (-not (Test-Path $OscdImgExe)) { Write-Error "oscdimg.exe not found!"; exit }

# 2. Read and Replace Base64
Write-Host "Encoding Binaries..." -ForegroundColor Cyan
$b64Oscd = [Convert]::ToBase64String([IO.File]::ReadAllBytes($OscdImgExe))
$b64Icon = [Convert]::ToBase64String([IO.File]::ReadAllBytes($IconFile))

Write-Host "Creating Release Script..." -ForegroundColor Cyan
$content = Get-Content $SourceFile -Raw -Encoding UTF8
$content = $content.Replace("'__OSCDIMG_B64__'", "'$b64Oscd'")
$content = $content.Replace("'__ICON_B64__'", "'$b64Icon'")
[IO.File]::WriteAllText($ReleaseFile, $content, [System.Text.Encoding]::UTF8)

# 3. Clean up old EXE
if (Test-Path $ExeFile) { 
    Write-Host "Removing old EXE..." -ForegroundColor Yellow
    Remove-Item $ExeFile -Force -ErrorAction SilentlyContinue 
}

# 4. Compile to EXE using PS2EXE (Native PS7 Call)
Write-Host "Compiling to EXE..." -ForegroundColor Yellow

# ตรวจสอบว่ามีคำสั่ง Invoke-PS2EXE หรือไม่
if (Get-Command Invoke-PS2EXE -ErrorAction SilentlyContinue) {
    try {
        # เรียกใช้แบบพื้นฐานที่สุดสำหรับ PS7
        Invoke-PS2EXE -InputFile $ReleaseFile `
                      -OutputFile $ExeFile `
                      -IconFile $IconFile `
                      -NoConsole `
                      -Title "KaijuISO" `
                      -Product "KaijuISO Creator"
                      
        Write-Host "`n[SUCCESS] Created: $ExeFile" -ForegroundColor Green
    }
    catch {
        Write-Error "Compilation Failed: $($_.Exception.Message)"
    }
}
else {
    Write-Warning "PS2EXE module missing! Please run: Install-Module ps2exe -Scope CurrentUser -Force"
}

Read-Host "Press Enter to finish..."