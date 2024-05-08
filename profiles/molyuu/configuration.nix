# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/firmware/default.nix
    ../../modules/hardware/graphics/common.nix
    ../../modules/hardware/graphics/intel.nix
    ../../modules/hardware/graphics/nvidia.nix
    ../../modules/hardware/bootloader.nix
    ../../modules/hardware/kernel/kernel.nix
    ../../modules/hardware/kernel/intel.nix
    ../../modules/desktop/pantheon.nix
    ../../modules/network/networkmanager.nix
    ../../modules/network/ntp.nix
    ../../modules/network/bluetooth.nix
    ../../modules/locale/i18n.nix
    ../../modules/security/sudo.nix
    ../../modules/programs/gaming/steam.nix
    ../../modules/programs/dev/rust-toolchains.nix
    ../../users/molyuu.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cernet.mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  programs.steam.proton-ge.enable = true;

  system.stateVersion = "23.11";
  services.sshd.enable = true;
  networking.hostName = "molyuu";

  programs.zsh.enable = true;
}
