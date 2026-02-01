{ pkgs, ... }:
let
  kernel = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.desktop.hyprland = {
    enable = true;
    sddm.enable = true;
    monitors = [ "DP-1,1920x1080@165.00,0x0,1" ];
  };

  molyuu.home-manager.theme.dotfile = "caelestia";

  virtualisation.docker.storageDriver = "zfs";
  molyuu.hardware.graphics.amdgpu.enable = true;
  molyuu.hardware.kernel.package = kernel;
  boot.zfs.package = kernel.zfs_cachyos;

  hardware.bluetooth.enable = true;
  molyuu.system.profiles = [
    "pc"
    "gaming"
  ];
}
