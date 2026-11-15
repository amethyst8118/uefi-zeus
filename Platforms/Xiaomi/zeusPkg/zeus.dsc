##
#  Copyright (c) 2011 - 2022, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2020, Intel Corporation. All rights reserved.
#  Copyright (c) 2018, Bingxing Wang. All rights reserved.
#  Copyright (c) Microsoft Corporation.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = zeus
  PLATFORM_GUID                  = 4B1D6C2E-8E77-4C2A-9B6A-2D7D3E1A5C10
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/zeusPkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = RELEASE|DEBUG
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = zeusPkg/zeus.fdf
  USE_CUSTOM_DISPLAY_DRIVER      = 0

  #
  # 0 = Mu drivers only. ABL's scan-out keeps the panel alive, so the boot
  #     manager and the UniXNU menu are visible without vendor drivers.
  # 1 = load the stock vendor hardware drivers from Binaries/zeus.
  #     Not wired yet: cupid's stock UEFI modules must be imported first.
  #
  ZEUS_VENDOR_HW                = 0

  #
  # SM8450 (waipio), the only SoC this platform targets.
  #
  SOC_TYPE                       = 0

!include WaipioPkg/WaipioPkg.dsc.inc

!if ($(USE_CUSTOM_DISPLAY_DRIVER) == 1) && ($(ZEUS_VENDOR_HW) == 0)
  !error The stock display chain needs ZEUS_VENDOR_HW = 1
!endif

[PcdsFixedAtBuild]
  #
  # DDR Memory
  #
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000

  #
  # UEFI Stack
  #
  gArmPlatformTokenSpaceGuid.PcdCPUCoresStackBase|0xA760D000
  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x40000

  #
  # SMBIOS
  #
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemManufacturer|"Xiaomi"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemModel|"Xiaomi 12 Pro"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailModel|"zeus"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailSku|"zeus"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemBoardModel|"Xiaomi 12 Pro"

  #
  # Simple Frame Buffer
  #
  # zeus panel: 1440x3200, qcom,mdss_dsi_l2_38_0c_0a_dsc_cmd (measured from
  # /proc/cmdline and the live FDT on the phone, 2026-11-16). ABL leaves the
  # cont_splash framebuffer at 0xB8000000 (0x2B00000) scanning out; 32 bpp,
  # stride 1440*4 = 5760 bytes. SimpleFbDxe publishes a GOP on it.
  #
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferWidth|1440
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferHeight|3200
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferColorDepth|32
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferFontScale|4
  # 0.25 s per console line so a phone video captures driver errors, and
  # errors only so the UNIXNURAMDISK diagnostics are not lost in the noise.
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferDelay|250000
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000000

  #
  # Platform PEI
  #
  gQcomPkgTokenSpaceGuid.PcdPlatformType|"LA"
!if $(ZEUS_VENDOR_HW) == 0
  gQcomPkgTokenSpaceGuid.PcdBuildXblHobs|FALSE
!endif

[LibraryClasses]
  #
  # Memory Libraries
  #
  MemoryMapLib|zeusPkg/Library/MemoryMapLib/MemoryMapLib.inf

  #
  # QCOM Libraries
  #
  ConfigurationMapLib|zeusPkg/Library/ConfigurationMapLib/ConfigurationMapLib.inf

[Components]
  #
  # UniXNU and the XNU loader
  #
  UniXNUPkg/Application/UniXNU/UniXNU.inf
  UniXNUPkg/Driver/UniXNUDxe/UniXNUDxe.inf
  UniXNUPkg/Driver/UniXNURamDiskDxe/UniXNURamDiskDxe.inf
  DarwinBootPkg/Driver/DarwinBoot.inf

[LibraryClasses]
  UniXNULib|UniXNUPkg/Library/UniXNULib/UniXNULib.inf
  FdtLib|MdePkg/Library/BaseFdtLib/BaseFdtLib.inf
