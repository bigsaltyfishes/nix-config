{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = osConfig.molyuu.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          hyprland = {
            default = [
              "gtk"
              "hyprland"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome " ];
            "org.freedesktop.impl.portal.OpenURI" = [ "gnome" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      systemd.enable = true;
      xwayland.enable = true;
    };
  };
}
