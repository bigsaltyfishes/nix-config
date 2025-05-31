# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.desktop.gnome = {
    enable = true;
    gdm.enable = true;
  };
  
  molyuu.hardware.kernel.enable = true;
  molyuu.hardware.kernel.grub.enable = true;
  molyuu.hardware.audio.enable = true;

  molyuu.system.network.ntp.enable = true;

  services.openssh.enable = true;

  virtualisation.vmware.guest.enable = true;

  molyuu.home-manager.profile.extraFeatures = [ "extraDevel" ];
}
