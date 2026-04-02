 #!/usr/bin/env bash
echo "======= Patching VC3 ISO ======="
./patch_iso.ps1
echo ""
echo "======= Patching VC3 DLCS ======="
./patch_dlcs.ps1
read -n 1 -s -r -p "Press any key to quit"