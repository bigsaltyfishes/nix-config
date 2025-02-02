{ config, lib, pkgs, ... }:
let
  cfg = config.molyuu.desktop.gnome;
in
{
  options.molyuu.desktop.gnome = {
    enable = lib.mkEnableOption "Enable GNOME";
    gdm = {
      enable = lib.mkEnableOption "Enable GDM";
    };
  };

  # Base GNOME Desktop
  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      desktopManager.xterm.enable = false;
      displayManager.gdm.enable = lib.mkIf cfg.gdm.enable true;
    };

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ 
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator 
    ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    xdg.portal.enable = true;
    services.flatpak.enable = true;
    
    # Use ibus for GNOME
    molyuu.i18n.inputMethod.ibus.enable = true;
  };
}
