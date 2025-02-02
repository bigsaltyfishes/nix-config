{ config, lib, ... }:
let
  profile = config.molyuu.home-manager.profile;
in
{
  config = lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    programs.clash-verge.enable = true;
  };
}