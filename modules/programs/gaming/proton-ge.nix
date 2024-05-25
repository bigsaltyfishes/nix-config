{ config, lib, ... }:
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
      default = config.nur.repos.ataraxiasjel.proton-ge;
      description = "GE Protonpackage to use.";
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.enable [
      cfg.package
    ];

    environment.sessionVariables = lib.mkIf cfg.enable {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${cfg.package}";
    };
  };
}
