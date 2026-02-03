{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.desktop.hyprland;
in
{
  options.molyuu.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    sddm = {
      enable = lib.mkEnableOption "Enable SDDM";
    };
    monitors = lib.mkOption {
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
    wallpaperEngine = {
      enable = lib.mkEnableOption "Enable Wallpaper Engine integration";
      monitor = lib.mkOption {
        type = lib.types.str;
        default = "DP-1";
        description = "The monitor to set the wallpaper on (e.g. 'DP-1')";
      };
      scaling = lib.mkOption {
        type = lib.types.str;
        default = "fit";
        description = "The scaling mode for the wallpaper";
      };
      wallpaperId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The Wallpaper Engine wallpaper ID to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    services.xserver.enable = true;
    services.flatpak.enable = true;
    molyuu.desktop.themedDisplayManager.sddm.enable = cfg.sddm.enable;
    security.pam.services.sddm.enableGnomeKeyring = cfg.sddm.enable;

    environment.systemPackages = with pkgs; [
      nautilus
    ];
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    # Use fcitx5 for Hyprland
    molyuu.i18n.inputMethod.fcitx5.enable = true;
  };
}
