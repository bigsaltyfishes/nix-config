# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.desktop.hyprland = {
    enable = true;
    sddm.enable = true;
    monitors = [ "eDP-1,1920x1080@60.00,0x0,1" ];
  };

  molyuu.system.profiles = [
    "pc"
    "gaming"
  ];
}
