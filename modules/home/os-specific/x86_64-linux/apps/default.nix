{ lib, inputs, pkgs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    programs.direnv.enable = true;
    programs.zed-editor = {
      enable = true;
      userSettings = {
        terminal = {
          font_family = "JetBrainsMono Nerd Font";
        };
        ui_font_family = "JetBrainsMono Nerd Font";
      };
    };
    home.packages = with pkgs; [
      warp-terminal
      pavucontrol
      google-chrome
      gparted
      wpsoffice-cn
      wechat-uos
    ] ++ lib.optionals (lib.elem "gaming" profile.extraFeatures || lib.elem "full" profile.extraFeatures) [
      protontricks
      lutris-unwrapped
      moonlight-qt
    ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
