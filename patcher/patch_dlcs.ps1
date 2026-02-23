$dlcs="1B","1C","1D","1E","13","14","15","16","17","18","19","20","21","22","23","24","25","27","29"
$base_dir="2_PUT_JAPANESE_DLCS_HERE"
# in case someone copies top level NPJH50343
if (Test-Path "$base_dir\NPJH50343" -PathType Container){
	$base_dir="2_PUT_JAPANESE_DLCS_HERE\NPJH50343"
}
$patches_dir="patches\DLC"
$patched_dir="3_GET_PATCHED_CONTENT_HERE\NPJH50343"

foreach($i in $dlcs){
	$name="DL$i"
	if (Test-Path "$base_dir\${name}\${name}_DATA.EDAT" -PathType Leaf){
		if (!(Test-Path "$patched_dir\${name}" -PathType Container)){
			New-Item -ItemType Directory -Path "$patched_dir\${name}" | Out-Null
		}
		Write-Host "Patching $name"
		.\xdelta.exe -d -f -s "$base_dir\${name}\${name}_DATA.EDAT" "$patches_dir\${name}_DATA.EDAT.xdelta" "$patched_dir\${name}\${name}_DATA.EDAT"
		Copy-Item -Path "$base_dir\${name}\${name}.EDAT" -Destination "$patched_dir\${name}" | Out-Null
		if (Test-Path "$base_dir\${name}\S" -PathType Container){
			Copy-Item -Path "$base_dir\${name}\S" -Destination "$patched_dir\${name}" -Recurse -Force | Out-Null
		}
	} else {
		Write-Host "Missing original DLC for: $name. Check your DLC source, you're missing a file!"
	}
}

Write-Host "Completed."
Write-Host "Copy the contents of '$patched_dir' to 'memstick\PSP\GAME\NPJH50343' directory."
Write-Host "Note that the patch excluded duplicates of E2 on-disk content."
Write-Host "If you have a prior installation of DLCs in memstick, delete them first."