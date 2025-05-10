# Based on https://github.com/linuxmobile/kaku
{ inputs, pkgs, ... }: {
  imports = [
    inputs.niri.homeModules.niri
    ./niri
    ./hyprlock.nix
    ./kitty.nix
    ./packages.nix
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
  };
}
