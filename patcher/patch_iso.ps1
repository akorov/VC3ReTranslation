#Requires -Version 7.0
[CmdletBinding()]
$ErrorActionPreference = "Stop"

$baseDir = Join-Path $PSScriptRoot "1_PUT_JAPANESE_ISO_HERE"
$patchesDir = Join-Path $PSScriptRoot "patches/ISO"
$patchedDir = Join-Path $PSScriptRoot "3_GET_PATCHED_CONTENT_HERE"
$patchedName = "Valkyria Chronicles 3 E2 - English ReTranslation.iso"

$jpPsnMd5 = "02CD1C0BB42181BD34D2FE711FB0558D"
$jpUmd5CbMd5 = "5CB612D3062149C15130A73383A627D2"
$xdelta = Join-Path $PSScriptRoot "xdelta.exe"

if (-not (Test-Path -LiteralPath $xdelta -PathType Leaf)) {
    throw "xdelta.exe was not found beside this script: $xdelta"
}
if (-not (Test-Path -LiteralPath $baseDir -PathType Container)) {
    throw "ISO input folder was not found: $baseDir"
}
if (-not (Test-Path -LiteralPath $patchesDir -PathType Container)) {
    throw "ISO patches folder was not found: $patchesDir"
}

$isos = @(Get-ChildItem -LiteralPath $baseDir -File -Filter "*.iso")
if ($isos.Count -eq 0) {
    throw "No .iso file was found in '$baseDir'. Put exactly one supported Japanese ISO in that folder."
}
if ($isos.Count -gt 1) {
    throw "More than one .iso file was found in '$baseDir'. Leave only the ISO you want to patch."
}
$iso = $isos[0]

Write-Host "Checking MD5 hash of ISO: $($iso.FullName)"
$inputHash = (Get-FileHash -LiteralPath $iso.FullName -Algorithm MD5).Hash.ToUpperInvariant()
Write-Host "Provided ISO MD5: $inputHash"

if ($inputHash -eq $jpPsnMd5) {
    $patchFile = Join-Path $patchesDir "JP-PSN_02C_to_EN.xdelta"
    Write-Host "ISO matches PSN version"
}
elseif ($inputHash -eq $jpUmd5CbMd5) {
    $patchFile = Join-Path $patchesDir "JP-UMD_5CB_to_EN.xdelta"
    Write-Host "ISO matches UMD version"
}
else {
    Write-Host "ISO does not match any supported hashes:"
    Write-Host "1. $jpPsnMd5 (PSN ISO)"
    Write-Host "2. $jpUmd5CbMd5 (UMD ISO)"
    throw "Unsupported ISO. No patch was applied."
}

if (-not (Test-Path -LiteralPath $patchFile -PathType Leaf)) {
    throw "Required patch file was not found: $patchFile"
}

New-Item -ItemType Directory -Path $patchedDir -Force | Out-Null
$outputIso = Join-Path $patchedDir $patchedName

Write-Host "Patching ISO: $($iso.FullName)"
& $xdelta -d -f -s $iso.FullName $patchFile $outputIso
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    throw "xdelta.exe failed while patching the ISO. Exit code: $exitCode"
}
if (-not (Test-Path -LiteralPath $outputIso -PathType Leaf)) {
    throw "xdelta.exe returned success, but the output ISO was not created: $outputIso"
}

Write-Host "Finished. The patched ISO can be found at: $outputIso"
