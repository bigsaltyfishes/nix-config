{ config, lib, pkgs, ... }:
let
  cfg = config.programs.steam.proton-ge;
in
{
  options.programs.steam.proton-ge = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install GE Proton for Steam";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.proton-ge-bin;
      description = "GE Proton package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam.extraCompatPackages = [
      cfg.package
    ];
  };
}
