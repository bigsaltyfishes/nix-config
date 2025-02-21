{ lib, ... }:
{
  imports = [
    ./configuration.nix
  ];

  jovian.steam.autoStart = lib.mkForce false;
  molyuu.desktop.pantheon.lightdm.enable = lib.mkForce true;
  molyuu.hardware.kernel.grub.enable = lib.mkForce false;
}
