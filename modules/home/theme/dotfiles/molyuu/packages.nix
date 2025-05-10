{ osConfig, pkgs, lib, ... }:
let
  enabled = osConfig.molyuu.home-manager.theme.dotfile == "molyuu";
  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      "Gabarito"
      "Lexend"
      "Chakra Petch"
      "Crimson Text"
      "Alfa Slab One"
    ];
  });
in
{
  config = lib.mkIf enabled {
    home = {
      packages = with pkgs; with nodePackages_latest; with gnome; with libsForQt5; [
        # gui
        blueberry
        pkgs.nautilus
        yad

        # tools
        ripgrep
        jq
        libnotify
        glib
        foot
        kitty
        ydotool

        # themes
        adwaita-qt6
        adw-gtk3
        morewaita-icon-theme

        # fonts
        noto-fonts
        noto-fonts-cjk-sans
        google-fonts
        cascadia-code
        material-symbols
      ] ++ (with pkgs.nerd-fonts; [
        # nerd fonts
        ubuntu
        ubuntu-mono
        jetbrains-mono
        caskaydia-cove
        fantasque-sans-mono
        mononoki
        space-mono
      ]);
    };
  };
}