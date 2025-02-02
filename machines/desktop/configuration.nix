{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.desktop.hyprland = {
    enable = true;
    sddm.enable = true;
  };
  molyuu.home-manager.theme.dotfile = "end-4";
  molyuu.hardware.graphics.amdgpu.enable = true;
  hardware.bluetooth.enable = true;
  molyuu.system.profiles = [ "pc" "gaming" ];
}
