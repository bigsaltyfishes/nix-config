{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "353f1f71";
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zpool/NixOS/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/NixOS/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "zpool/NixOS/var";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/NixOS/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/755e40d9-c427-4e10-a97a-33546ed771c1";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/9A17-D820";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/169034c9-9a54-444a-80b1-45e440acb01b"; }
  ];

  # Patch for hda jack retask
  hardware.firmware = [
    (pkgs.writeTextDir "lib/firmware/hda-jack-retask.fw" ''
      [codec]
      0x10ec0897 0x104387fb 0

      [pincfg]
      0x11 0x90460150
      0x12 0x4037c000
      0x14 0x01014010
      0x15 0x411111f0
      0x16 0x411111f0
      0x17 0x411111f0
      0x18 0x01a19030
      0x19 0x01014010
      0x1a 0x0181303f
      0x1b 0x02214020
      0x1c 0x411111f0
      0x1d 0x4044c601
      0x1e 0x411111f0
      0x1f 0x411111f0
    '')
  ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=hda-jack-retask.fw
  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
