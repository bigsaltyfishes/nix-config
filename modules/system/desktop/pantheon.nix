{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.desktop.pantheon;
in
{
  options.molyuu.desktop.pantheon = {
    enable = lib.mkEnableOption "Enable Pantheon";
    lightdm = {
      enable = lib.mkEnableOption "Enable LightDM";
    };
  };

  # Base Pantheon Desktop
  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.pantheon.enable = true;
      desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
        wingpanel-indicator-ayatana
        monitor
      ];
      desktopManager.xterm.enable = false;
      displayManager.lightdm.enable = lib.mkIf cfg.lightdm.enable true;
      displayManager.lightdm.greeters.pantheon.enable = lib.mkIf cfg.lightdm.enable true;
    };

    # App indicator and Tweaks
    environment.pathsToLink = [ "/libexec" ];
    environment.systemPackages = with pkgs; [
      indicator-application-gtk3
      pantheon-tweaks
    ];

    systemd.user.services.indicatorapp = {
      description = "indicator-application-gtk3";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
      };
    };

    xdg.portal.enable = true;
    services.flatpak.enable = true;

    # Use ibus for Pantheon
    molyuu.i18n.inputMethod.ibus.enable = true;
  };
}
