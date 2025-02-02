{ config, pkgs, lib, ... }:
let
  enabled = config.molyuu.home-manager.theme.dotfile == "end-4";
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

        # theming tools
        gradience

        # hyprland
        brightnessctl
        ddcutil
        cliphist
        fuzzel
        grim
        hyprpicker
        tesseract
        pavucontrol
        playerctl
        swappy
        slurp
        swww
        wl-clipboard
        wf-recorder
      ];
    };
  };
}
