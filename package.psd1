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
        