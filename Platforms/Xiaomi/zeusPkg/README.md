# zeus firmware platform

UEFI firmware for the **Xiaomi 12 Pro** (`zeus`, Qualcomm **SM8450**) for UniXNU, derived from
`cupidPkg` (Xiaomi 12, same SoC) in obaosp's uefi-cupid fork of Mu-Silicium.

| Item | Value |
| --- | --- |
| SoC package | `Silicon/Qualcomm/WaipioPkg` (SM8450) |
| Vendor hardware | off (`ZEUS_VENDOR_HW = 0`) |
| Display | `SimpleFbDxe` on ABL's scan-out at 0xB8000000, **1440x3200**, 32 bpp, font scale 4 |
| FD window | 0xA7000000 + 0x2A2000 (cupid's; started fine on zeus 2026-11-16) |
| Boot image header | v4, 4096-byte pages (`Resources/Configs/zeus.toml`) |

Differences from cupidPkg: platform name, SMBIOS model, framebuffer size. The memory map
(`Library/MemoryMapLib`) is still cupid's/ingres's; zeus's measured reserved-memory map is in the
iOS-Zeus workspace (`logs/phase1/reserved-memory-map.txt`) and matches the SoC carve-outs, but
should be compared entry by entry before relying on it.

Built by the UniXNU-zeus device repository (`board.toml [firmware]`).
