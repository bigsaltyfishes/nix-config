{ config, lib, pkgs, ... }:
let
  cfg = config.molyuu.desktop.pantheon.lightdm;
in
{
  imports = [
    ./pipewire.nix
  ];

  options.molyuu.desktop.pantheon.lightdm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable LightDM";
    };
  };

  # Base Pantheon Desktop
  config = {
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.pantheon.enable = true;
      desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
        wingpanel-indicator-ayatana
        monitor
      ];
      desktopManager.xterm.enable = false;
      displayManager.lightdm.enable = lib.mkIf cfg.enable true;
      displayManager.lightdm.greeters.pantheon.enable = lib.mkIf cfg.enable true;
    };

    programs.pantheon-tweaks.enable = true;

    # App indicator
    environment.pathsToLink = [ "/libexec" ];
    environment.systemPackages = with pkgs; [ indicator-application-gtk3 ];

    systemd.user.services.indicatorapp = {
      description = "indicator-application-gtk3";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
      };
    };

    # Flatpak
    services.flatpak.enable = true;

    # Blueman
    services.blueman.enable = true;
  };
}
