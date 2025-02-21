{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.desktop.themedDisplayManager.sddm;
  astronaut = (pkgs.sddm-astronaut.override { embeddedTheme = cfg.theme; }).overrideAttrs (prev: {
    propagatedUserEnvPkgs = prev.propagatedBuildInputs;
    propagatedBuildInputs = [ ];

    installPhase =
      prev.installPhase
      + ''

        themeDir="$out/share/sddm/themes/sddm-astronaut-theme"

        mkdir -p $out/share/fonts
        cp -r $out/share/sddm/themes/sddm-astronaut-theme/Fonts/* $out/share/fonts/
      '';
  });
in
{
  options.molyuu.desktop.themedDisplayManager.sddm = {
    enable = lib.mkEnableOption "Enable Themed SDDM Display Manager (Astronaut)";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "hyprland_kath";
      description = "Specify a theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
        bibata-cursors
      ])
      ++ [
        astronaut
      ];

    fonts.packages = [ astronaut ];

    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ];
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Ice";
        };
      };
    };
  };
}
