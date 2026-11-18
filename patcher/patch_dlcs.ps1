#Requires -Version 7.0
[CmdletBinding()]
$ErrorActionPreference = "Stop"

$dlcs = @("1B","1C","1D","1E","13","14","15","16","17","18","19","20","21","22","23","24","25","27","29")
$baseDir = Join-Path $PSScriptRoot "2_PUT_JAPANESE_DLCS_HERE"

# Accept either a direct DLC folder layout or a nested NPJH50343 folder.
$nestedDir = Join-Path $baseDir "NPJH50343"
if (Test-Path -LiteralPath $nestedDir -PathType Container) {
    $baseDir = $nestedDir
}

$patchesDir = Join-Path $PSScriptRoot "patches/DLC"
$patchedDir = Join-Path $PSScriptRoot "3_GET_PATCHED_CONTENT_HERE/NPJH50343"
$xdelta = Join-Path $PSScriptRoot "xdelta.exe"

if (-not (Test-Path -LiteralPath $xdelta -PathType Leaf)) {
    throw "xdelta.exe was not found beside this script: $xdelta"
}
if (-not (Test-Path -LiteralPath $baseDir -PathType Container)) {
    throw "DLC input folder was not found: $baseDir"
}
if (-not (Test-Path -LiteralPath $patchesDir -PathType Container)) {
    throw "DLC patches folder was not found: $patchesDir"
}

New-Item -ItemType Directory -Path $patchedDir -Force | Out-Null

$missing = [System.Collections.Generic.List[string]]::new()
$failed = [System.Collections.Generic.List[string]]::new()

foreach ($i in $dlcs) {
    $name = "DL$i"
    $sourceDir = Join-Path $baseDir $name
    $sourceData = Join-Path $sourceDir "${name}_DATA.EDAT"
    $sourceEdat = Join-Path $sourceDir "${name}.EDAT"
    $patchFile = Join-Path $patchesDir "${name}_DATA.EDAT.xdelta"
    $destinationDir = Join-Path $patchedDir $name
    $destinationData = Join-Path $destinationDir "${name}_DATA.EDAT"

    if (-not (Test-Path -LiteralPath $sourceData -PathType Leaf) -or
        -not (Test-Path -LiteralPath $sourceEdat -PathType Leaf)) {
        Write-Warning "Missing original DLC files for $name. Skipping."
        $missing.Add($name)
        continue
    }
    if (-not (Test-Path -LiteralPath $patchFile -PathType Leaf)) {
        Write-Warning "Missing patch file for $name`: $patchFile. Skipping."
        $failed.Add($name)
        continue
    }

    New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    Write-Host "Patching $name"

    & $xdelta -d -f -s $sourceData $patchFile $destinationData
    if ($LASTEXITCODE -ne 0) {
        Write-Error "xdelta.exe failed for $name with exit code $LASTEXITCODE."
        $failed.Add($name)
        continue
    }

    Copy-Item -LiteralPath $sourceEdat -Destination $destinationDir -Force
    $sourceS = Join-Path $sourceDir "S"
    if (Test-Path -LiteralPath $sourceS -PathType Container) {
        Copy-Item -LiteralPath $sourceS -Destination $destinationDir -Recurse -Force
    }
}

if ($failed.Count -gt 0) {
    throw "DLC patching failed for: $($failed -join ', '). Check the messages above."
}

if ($missing.Count -gt 0) {
    Write-Warning "Some DLCs were skipped because their original files were missing: $($missing -join ', ')"
}

Write-Host ""
Write-Host "DLC patching completed."
Write-Host "Copy the contents of '$patchedDir' to 'memstick\PSP\GAME\NPJH50343'."
Write-Host "Note that the patch excluded duplicates of E2 on-disk content."
Write-Host "If you have a prior installation of DLCs in memstick, delete them first."
