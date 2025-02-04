{ config, inputs, pkgs, lib, ... }:
let
  enabled = config.molyuu.home-manager.theme.dotfile == "end-4";
  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      "Gabarito"
      "Lexend"
      "Chakra Petch"
      "Crimson Text"
      "Alfa Slab One"
    ];
  });
  cursor-theme = "Bibata-Modern-Ice";
  cursor-package = pkgs.bibata-cursors;
in
{
  # Import Other Components
  imports = [
    inputs.ags.homeManagerModules.default
    ./anyrun.nix
    ./fastfetch.nix
    ./foot.nix
    ./fuzzel.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./kitty.nix
    ./packages.nix
    ./wlogout.nix
    ./zsh.nix
  ];

  config = lib.mkIf enabled {
    # Dependencies expose to Home
    programs.fish.enable = true;
    home.packages = (with pkgs; [
      bc
      xdg-user-dirs
      ollama
      pywal
      dart-sass
      illogical-impulse-oneui4-icons

      adwaita-qt6
      adw-gtk3
      bibata-cursors
      morewaita-icon-theme
    ]) ++ (with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      google-fonts
      cascadia-code
      material-symbols
    ]) ++ (with pkgs.nerd-fonts; [
      ubuntu
      ubuntu-mono
      jetbrains-mono
      caskaydia-cove
      fantasque-sans-mono
      mononoki
      space-mono
    ]);

    # Python Packages Expose to Home
    molyuu.home-manager.python-packages = with pkgs.python3Packages; [
      setproctitle
      materialyoucolor
      material-color-utilities
      pywayland
    ];

    # Fonts
    fonts.fontconfig.enable = true;

    # Cursor
    home.sessionVariables = {
      XCURSOR_THEME = cursor-theme;
      XCURSOR_SIZE = 24;
    };

    home.pointerCursor = {
      package = cursor-package;
      name = cursor-theme;
      size = 24;
      gtk.enable = true;
    };

    home.file.".local/share/icons/MoreWaita" = {
      source = "${pkgs.morewaita-icon-theme}/share/icons";
    };

    # AGS Configuration
    home.file.".config/ags" = {
      source = "${pkgs.end-4-ags}/ags";
      recursive = true;
    };

    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [
        gtksourceview
        gtksourceview4
        webkitgtk
        webp-pixbuf-loader
        ydotool
      ];
    };
  };
}
