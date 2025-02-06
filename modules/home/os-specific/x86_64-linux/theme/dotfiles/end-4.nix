{ inputs, osConfig, pkgs, ... }:
let
  hypr = inputs.hyprland.packages.${pkgs.system};
in
{
  imports = [
    inputs.illogical-impulse.homeManagerModules.default
  ];
  
  illogical-impulse = {
    enable = osConfig.molyuu.home-manager.theme.dotfile == "end-4";
    hyprland = {
      monitor = osConfig.molyuu.desktop.hyprland.monitor;
      package = hypr.hyprland;
      xdgPortalPackage = hypr.xdg-desktop-portal-hyprland;
      ozoneWayland.enable = true;
    };
  };
}