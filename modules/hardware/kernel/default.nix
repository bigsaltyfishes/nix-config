{ config, lib, pkgs, ... }:
let
  cfg = config.molyuu.hardware.kernel;
in
{
  options.molyuu.hardware.kernel = {
    enable = lib.mkEnableOption "Install Kernel";
    package = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_zen;
      description = "Kernel Package to use";
    };
    supportedFilesystems = lib.mkOption {
      default = [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
      type = lib.types.listOf lib.types.str;
      description = "Kernel supported filesystems";
    };
    withGrub = lib.mkEnableOption "Install Grub bootloader";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = cfg.package;
    boot.supportedFilesystems = cfg.supportedFilesystems;

    hardware.enableAllFirmware = true;

    boot.loader = lib.mkIf cfg.withGrub {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 10;
      };
    };
  };
}
