 #!/usr/bin/env bash
 
dlcs=("1B" "1C" "1D" "1E" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "27" "29")
base_dir="2_PUT_JAPANESE_DLCS_HERE"

if [ ! command -v xdelta3 >/dev/null 2>&1 ]; then
	echo "xdelta3 command not found. Please install it on your system."
	exit 1
fi

# in case someone copies top level NPJH50343
if [ -d "$base_dir/NPJH50343" ]; then
	base_dir="2_PUT_JAPANESE_DLCS_HERE/NPJH50343"
fi
patches_dir="patches/DLC"
patched_dir="3_GET_PATCHED_CONTENT_HERE/NPJH50343"

for i in "${dlcs[@]}"; do
	name="DL$i"
	if [ -f "$base_dir/${name}/${name}_DATA.EDAT" ]; then
		if [ ! -d "$patched_dir/${name}" ]; then
			mkdir -p "./$patched_dir/${name}"
		fi
		echo "Patching $name"
		xdelta3 -d -f -s "$base_dir/${name}/${name}_DATA.EDAT" "$patches_dir/${name}_DATA.EDAT.xdelta" "$patched_dir/${name}/${name}_DATA.EDAT"
		cp "$base_dir/${name}/${name}.EDAT" "$patched_dir/${name}"
		if [ -d "$base_dir/${name}/S" ]; then
			cp -a "$base_dir/${name}/S" "$patched_dir/${name}"
		fi
	else
		echo "Missing original DLC for: $name. Check your DLC source, you're missing a file!"
	fi
done

echo "Completed."
echo "Copy the contents of '$patched_dir' to 'memstick\PSP\GAME\NPJH50343' directory."
echo "Note that the patch excluded duplicates of E2 on-disk content."
echo "If you have a prior installation of DLCs in memstick, delete them first."