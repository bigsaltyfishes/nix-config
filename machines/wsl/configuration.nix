# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ../../profiles/minimum.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "molyuu";
  wsl.nativeSystemd = true;
  wsl.interop.register = true;

  virtualisation.docker.storageDriver = "overlay2";

  molyuu.home-manager.profile.extraFeatures = [ "baseDevel" ];
}
