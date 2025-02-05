{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.desktop.hyprland = {
    enable = true;
    sddm.enable = true;
    monitor = [ "DP-1,1920x1080@165.00,0x0,1" ];
  };
  molyuu.home-manager.theme.dotfile = "end-4";
  molyuu.hardware.graphics.amdgpu.enable = true;
  hardware.bluetooth.enable = true;
  molyuu.system.profiles = [ "pc" "gaming" ];
}
