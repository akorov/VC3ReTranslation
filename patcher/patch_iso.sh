 #!/usr/bin/env bash

base_dir="1_PUT_JAPANESE_ISO_HERE"
patches_dir="patches/ISO"
patched_dir="3_GET_PATCHED_CONTENT_HERE"
patched_name="Valkyria Chronicles 3 E2 - English ReTranslation.iso"

jp_psn_md5="02CD1C0BB42181BD34D2FE711FB0558D"
jp_umd_5CB_md5="5CB612D3062149C15130A73383A627D2"

if [ ! command -v xdelta3 >/dev/null 2>&1 ]; then
	echo "xdelta3 command not found. Please install it on your system."
	exit 1
fi

iso_name=$(find . -name '*.iso' -printf "%f\n" | head -n1)
res=1

echo "Checking md5 hash of ISO: $base_dir/$iso_name"
input_hash=$(md5sum "$base_dir/$iso_name" | awk '{print $1}' | sed 's/.*/\U&/')
echo "Provided ISO MD5: $input_hash"

if [ "$jp_psn_md5" = "$input_hash" ]; then
	echo "ISO matches PSN version"
	echo "Patching ISO: $base_dir/$iso_name"
	xdelta3 -d -f -s "$base_dir/$iso_name" "$patches_dir/JP-PSN_02C_to_EN.xdelta" "$patched_dir/$patched_name"
	res=$?
elif [ "$jp_umd_5CB_md5" = "$input_hash" ]; then
	echo "ISO matches UMD version"
	echo "Patching ISO: $base_dir/$iso_name"
	xdelta3 -d -f -s "$base_dir/$iso_name" "$patches_dir/JP-UMD_5CB_to_EN.xdelta" "$patched_dir/$patched_name"
	res=$?
else
	echo "ISO does not match any supported hashes:"
	echo "1. 02CD1C0BB42181BD34D2FE711FB0558D (PSN ISO)"
	echo "2. 5CB612D3062149C15130A73383A627D2 (UMD ISO)"
	exit 1
fi

if [ 0 -eq $res ]; then
	echo "Finished. The patched ISO can be found at: $patched_dir/$patched_name"
else
	echo "An error has occured when patching. Error code: $res"
	exit 1
fi