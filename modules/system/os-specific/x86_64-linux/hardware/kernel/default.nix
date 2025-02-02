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
    grub.enable = lib.mkEnableOption "Install Grub bootloader";
  };

  config = {
    boot.kernelPackages = lib.mkIf cfg.enable cfg.package;
    boot.supportedFilesystems = lib.mkIf cfg.enable cfg.supportedFilesystems;

    hardware.enableAllFirmware = lib.mkIf cfg.enable true;

    boot.loader = lib.mkIf cfg.grub.enable {
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
