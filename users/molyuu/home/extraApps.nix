{ lib, pkgs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  config = lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    home.packages = with pkgs; [
      pavucontrol
      spotify
      google-chrome
      gparted
      wpsoffice-cn
      wechat-uos
      clash-verge-rev
    ];
  };
}
