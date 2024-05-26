{ lib, pkgs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  config = lib.mkIf (lib.elem "gaming" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    home.packages = with pkgs; [
      protontricks
      lutris-unwrapped
      moonlight-qt
    ];
  };
}
