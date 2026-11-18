#Requires -Version 7.0
[CmdletBinding()]
$ErrorActionPreference = "Stop"

try {
    Write-Host "======= Patching VC3 ISO ======="
    & (Join-Path $PSScriptRoot "patch_iso.ps1")
    Write-Host ""
    Write-Host "======= Patching VC3 DLCs ======="
    & (Join-Path $PSScriptRoot "patch_dlcs.ps1")

    Write-Host ""
    Write-Host "All patching steps completed."
}
catch {
    Write-Error $_
    exit 1
}

Read-Host -Prompt "Press Enter to quit"
