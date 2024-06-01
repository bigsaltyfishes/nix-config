{ lib, ... }:
{
  options.molyuu.home-manager.profile.extraFeatures = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "baseDevel" "extraDevel" "extraApps" ];
  };

  imports = [
    ./molyuu
  ];
}