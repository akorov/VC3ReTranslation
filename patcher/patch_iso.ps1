$base_dir="1_PUT_JAPANESE_ISO_HERE"
$patches_dir="patches\ISO"
$patched_dir="3_GET_PATCHED_CONTENT_HERE"
$patched_name="Valkyria Chronicles 3 E2 - English ReTranslation.iso"

$jp_psn_md5 = "02CD1C0BB42181BD34D2FE711FB0558D"
$jp_umd_5CB_md5 = "5CB612D3062149C15130A73383A627D2"

$iso_name = Get-ChildItem -Path $base_dir\*.iso -Name | Select-Object -First 1
$res=$false

Write-Host "Checking md5 hash of ISO: $base_dir\$iso_name"
$input_hash =  $(Get-FileHash -Path "$base_dir\$iso_name" -Algorithm md5).Hash
Write-Host "Provided ISO MD5: $input_hash"
if($jp_psn_md5 -eq $input_hash){
	Write-Host "ISO matches PSN version"
	Write-Host "Patching ISO: $base_dir\$iso_name"
	.\xdelta.exe -d -f -s "$base_dir\$iso_name" "$patches_dir\JP-PSN_02C_to_EN.xdelta" "$patched_dir\$patched_name"
	$res=$?
} elseif($jp_umd_5CB_md5 -eq $input_hash){
	Write-Host "ISO matches UMD version"
	Write-Host "Patching ISO: $base_dir\$iso_name"
	.\xdelta.exe -d -f -s "$base_dir\$iso_name" "$patches_dir\JP-UMD_5CB_to_EN.xdelta" "$patched_dir\$patched_name"
	$res=$?
} else {
	Write-Host "ISO does not match any supported hashes:"
	Write-Host "1. 02CD1C0BB42181BD34D2FE711FB0558D (PSN ISO)"
	Write-Host "2. 5CB612D3062149C15130A73383A627D2 (UMD ISO)"
	Exit 1
}
if($res){
	Write-Host "Finished. The patched ISO can be found at: $patched_dir\$patched_name"
} else {
	Write-Host "An error has occured when patching. Error code: $res"
	Exit 1
}