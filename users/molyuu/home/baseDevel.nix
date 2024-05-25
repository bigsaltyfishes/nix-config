{ lib, pkgs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  config = lib.mkIf (lib.elem "baseDevel" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
      python3
    ];
  };
}
