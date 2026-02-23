$base_dir="1_PUT_JAPANESE_ISO_HERE"
$patches_dir="patches\ISO"
$patched_dir="3_GET_PATCHED_CONTENT_HERE"
$iso_name = Get-ChildItem -Path $base_dir\*.iso -Name | Select-Object -First 1
$jp_md5 = "02CD1C0BB42181BD34D2FE711FB0558D"
Write-Host "Checking md5 hash of ISO: $base_dir\$iso_name"
$input_hash =  $(Get-FileHash -Path "$base_dir\$iso_name" -Algorithm md5).Hash
if($jp_md5 -ne $input_hash){
	Write-Host "Provided iso does not match expected hash."
	Write-Host "Expected: $jp_md5"
	Write-Host "Got: $input_hash"
	Write-Host "Provide the correct ISO (Japanese PSN Extra Edition)"
	Exit 1
}

Write-Host "Patching ISO: $base_dir\$iso_name"
.\xdelta.exe -d -f -s "$base_dir\$iso_name" "$patches_dir\JP_to_EN.xdelta" "$patched_dir\Valkyria Chronicles 3 E2 - English ReTranslation.iso"
if($?){
	Write-Host "Finished. The patched ISO will be at: $patched_dir\Valkyria Chronicles 3 E2 - English ReTranslation.iso"
} else {
	Write-Host "An error has occured when patching."
}