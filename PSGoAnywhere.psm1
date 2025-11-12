# ---------------------------------------
# PSGoAnywhere PowerShell Module Loader
# ---------------------------------------

# Require PowerShell 7+ for this module
#Requires -Version 7.0

$script:ModuleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Verbose "Loading PSGoAnywhere module from $ModuleRoot..."

$privateFunctions = Get-ChildItem -Path (Join-Path $ModuleRoot 'Private') -Filter '*.ps1' -ErrorAction SilentlyContinue
foreach ($function in $privateFunctions) {
    Write-Verbose "Dot-sourcing private function: $($function.Name)"
    . $function.FullName
}

$publicFunctions = Get-ChildItem -Path (Join-Path $ModuleRoot 'Public') -Filter '*.ps1' -ErrorAction SilentlyContinue
foreach ($function in $publicFunctions) {
    Write-Verbose "Dot-sourcing public function: $($function.Name)"
    . $function.FullName
}

$exportFunctions = $publicFunctions | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }

Write-Verbose "Exporting public functions: $($exportFunctions -join ', ')"

Export-ModuleMember -Function $exportFunctions