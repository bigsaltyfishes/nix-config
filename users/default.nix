{ lib, ... }:
{
  options.molyuu.home-manager.profile.extraFeatures = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [
      "baseDevel"
      "extraDevel"
      "extraApps"
    ];
  };

  options.molyuu.home-manager.profile.shell = lib.mkOption {
    type = lib.types.str;
    default = "zsh";
    description = "Select a default shell";
  };

  imports = [
    ./molyuu
  ];
}
