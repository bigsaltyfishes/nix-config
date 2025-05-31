{
  config,
  lib,
  pkgs,
  ...
}:
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
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = lib.mkIf cfg.gdm.enable true;

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      gnomeExtensions.appindicator
    ];
    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

    xdg.portal.enable = true;
    services.flatpak.enable = true;

    # Use ibus for GNOME
    molyuu.i18n.inputMethod.ibus.enable = true;
  };
}
