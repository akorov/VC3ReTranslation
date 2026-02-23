#

This repository is for [Valkyria Chronicles 3 Extra Edition](https://en.wikipedia.org/wiki/Valkyria_Chronicles_III) translation project.
This is a different translation from the old incomplete 2014 project. Refer to changelist [here](../doc/Changelist from 2014 TL.md).
You might also want

# Patching instructions

Download the latest release on Releases page. Ignore the source zip. Only the release will contain everything needed for patching.

1. You will need original Japanese PSN ISO dump, as well as DLCs.
```
ISO CRC32: 279895E4
ISO MD5: 02CD1C0BB42181BD34D2FE711FB0558D
```

2. The release will contain three folders with self-explanatory names.
3. Put your ISO into `1_PUT_JAPANESE_ISO_HERE`. You don't need to rename it in any special way, just make sure it's the only *.iso file in there.
4. Put your DLCs into `2_PUT_JAPANESE_DLCS_HERE`, either with or without `NPJH50343`.
You should have structure like this:

```
2_PUT_JAPANESE_DLCS_HERE
|
|-DL1B
|  |-DL1B.EDAT
|  |-DL1B_DATA.EDAT
|
|-DL1C
|  |-DL1C.EDAT
|  |-DL1C_DATA.EDAT
...
```
or, alternatively, like this:
```
2_PUT_JAPANESE_DLCS_HERE
|
|-NPJH50343
    |
    |-DL1B
    |  |-DL1B.EDAT
    |  |-DL1B_DATA.EDAT
    |
    |-DL1C
    |  |-DL1C.EDAT
    |  |-DL1C_DATA.EDAT
...
```

5. Right click on the file `patch_everything.ps1` -> `Run with PowerShell`. Wait for patching to complete.
You should have a new ISO and a `NPJH50343` directory with DLCs in `3_GET_PATCHED_CONTENT_HERE`.

6. To install DLCs in PPSSPP emulator, put `NPJH50343` into `memstick\PSP\GAME\`.
If you don't know where memstick is, use `File->Open Memory Stick` in the emulator.
If you have a prior installation of DLCs in there - **delete it entirely**. This patch trims duplicate content that was moved onto E2 disk.