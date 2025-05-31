{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.desktop.cosmic;
in
{
  options.molyuu.desktop.cosmic = {
    enable = lib.mkEnableOption "Enable COSMIC";
    greeter = {
      enable = lib.mkEnableOption "Enable COSMIC Greeter";
    };
  };

  # Base GNOME Desktop
  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = lib.mkIf cfg.greeter.enable true;

    environment.systemPackages = with pkgs; [
      cosmic-bg
      cosmic-osd
      cosmic-term
      cosmic-edit
      cosmic-comp
      cosmic-store
      cosmic-randr
      cosmic-panel
      cosmic-icons
      cosmic-files
      cosmic-session
      cosmic-greeter
      cosmic-applets
      cosmic-settings
      cosmic-launcher
      cosmic-protocols
      cosmic-screenshot
      cosmic-applibrary
      cosmic-design-demo
      cosmic-notifications
      cosmic-settings-daemon
      cosmic-workspaces-epoch
      xdg-desktop-portal-cosmic
      rPackages.cosmicsig
      rPackages.COSMIC_67
    ];

    xdg.portal.enable = true;
    services.flatpak.enable = true;
    services.geoclue2.enable = true;

    # Use ibus for GNOME
    molyuu.i18n.inputMethod.ibus.enable = true;
  };
}
