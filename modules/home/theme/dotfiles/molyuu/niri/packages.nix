{ osConfig, lib, pkgs, ... }:
let
  enabled = osConfig.molyuu.home-manager.theme.dotfile == "molyuu";
in
{
  config = lib.mkIf enabled {
    home.packages = with pkgs; [
      swww
      wl-clipboard
      gnome-control-center
    ];
  };
}