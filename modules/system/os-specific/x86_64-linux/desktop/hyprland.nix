{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.molyuu.desktop.hyprland;
  xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
in
{
  options.molyuu.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    sddm = {
      enable = lib.mkEnableOption "Enable SDDM";
    };
    monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ",preferred,auto,1" ];
      description = "The monitors to use";
    };
  };

  options.molyuu.home-manager.theme = {
    dotfile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The AGS theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    services.udisks2.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    xdg = {
      portal = {
        enable = true;
        wlr.enable = true;
        xdgOpenUsePortal = true;
        config = {
          common.default = [ "gtk" ];
          hyprland.default = [ "gtk" "hyprland" ];
        };
        configPackages = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal
        ];
        extraPortals = [ 
          pkgs.xdg-desktop-portal-gtk 
          pkgs.xdg-desktop-portal
          xdg-desktop-portal-hyprland
        ];
      };
    };
    services.xserver.enable = true;
    services.flatpak.enable = true;
    molyuu.desktop.themedDisplayManager.sddm.enable = cfg.sddm.enable;

    # Use fcitx5 for Hyprland
    molyuu.i18n.inputMethod.fcitx5.enable = true;
  };
}