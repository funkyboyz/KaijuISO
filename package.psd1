<#
.SYNOPSIS
    KaijuISO - The Ultimate ISO Creator Tool
    
.DESCRIPTION
    A lightweight, portable GUI tool to create ISO files from folders using oscdimg.
    Optimized for Windows 10/11 and PowerShell 7 Environment.

.PARAMETER None
    No parameters required. The script launches a GUI.

.NOTES
    Version:        1.9.0
    Author:         Kitichote Amornrattanabongkot
    Role:           Senior System Engineer
    Organization:   Chromatix Computing Solutions (CCS)
    Project:        Personal Open Source Project
    Created:        2025-08-21
    Last Updated:   2026-02-10
    
    License:        MIT License
    GitHub:         https://github.com/funkyboyz/KaijuISO
#>

@{
    Root = '.\KaijuISO.ps1'
    ApplicationIconPath = '.\kaijuiso_icon.ico'
    OutputPath = '.\'
    Package = @{
        Enabled = $true
        Obfuscate = $false
        # DotNetVersion = 'v7.0'       # ใช้ PowerShell 7 / .NET 7
        DotNetVersion = 'v4.6.2'
        SelfContained = $true
        FileVersion = '1.9.0'
        ProductName = 'KaijuISO Creator'
        ProductVersion = '1.9.0'
        RequireElevation = $false
        PackageType = 'Console'
        # icon = 'kaijuiso_icon.ico'
        NoConsole = $true
        HideConsoleWindow = $true
    }
    Bundle = @{
    Enabled = $true      # เปิดการ bundle
    Modules = $true      # รวม module ด้วย
        Files = @(
            'KaijuISO.ps1',
            'oscdimg.exe',
            'kaijuiso_icon.ico'
        )
    }
}
        