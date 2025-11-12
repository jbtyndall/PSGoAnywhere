@{
    # Module manifest for PSGoAnywhere
    RootModule        = 'PSGoAnywhere.psm1'
    ModuleVersion     = '1.0.0'
    CompatiblePSEditions = @('Core', 'Desktop')

    GUID              = 'c0f2b4c5-2a13-42a2-a4fc-2f7e2eaf0d58'
    Author            = 'John Tyndall (john@tyndall.io)'
    CompanyName       = 'tyndall.io'
    Copyright         = '©2025 John Tyndall. All rights reserved.'
    Description       = 'PowerShell module for managing Fortra GoAnywhere MFT via REST API.'

    # Minimum PowerShell version
    PowerShellVersion = '7.0'

    # Modules that must be imported first
    RequiredModules   = @()

    # Assemblies to load
    RequiredAssemblies = @()

    # Functions to export (public cmdlets)
    FunctionsToExport = @(
        'New-GAClient',
        'Get-GAWebUser',
        'New-GAWebUser',
        'Set-GAWebUser',
        'Remove-GAWebUser'
    )

    # No cmdlets to export
    CmdletsToExport   = @()

    # Only export module-wide variables you intend to expose
    VariablesToExport = @()

    # No aliases exported by default
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags        = @('PowerShell', 'GoAnywhere', 'GoAnywhere MFT', 'Fortra', 'Automation', 'REST', 'UserManagement', 'Integration')
            LicenseUri  = 'https://opensource.org/licenses/MIT'
            ProjectUri  = 'https://github.com/jbtyndall/PSGoAnywhere'
            IconUri     = 'https://www.goanywhere.com/themes/custom/goanywhere/favicon.ico'
            ReleaseNotes = 'Initial release of PSGoAnywhere with Web User management support.'
        }
    }
}