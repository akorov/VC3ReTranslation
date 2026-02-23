Write-Host "======= Patching VC3 ISO ======="
& "$PSScriptRoot\patch_iso.ps1"
Write-Host ""
Write-Host "======= Patching VC3 DLCS ======="
& "$PSScriptRoot\patch_dlcs.ps1"
Read-Host -Prompt "Press any key to quit" | Out-Null