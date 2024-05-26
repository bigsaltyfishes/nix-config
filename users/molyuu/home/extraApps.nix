{ lib, pkgs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  config = lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];

    home.packages = with pkgs; [
      pavucontrol
      spotify
      google-chrome
      gparted
      moonlight-qt
      wpsoffice-cn
      wechat-uos
      clash-verge-rev
    ];
  };
}
