{ lib, ... }:
{
  options.molyuu.system.profiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      List of features to enable in the system configuration.
    '';
    example = [ "pc" "gaming" ];
  };

  imports = [
    ./minimum.nix
    ./pc.nix
    ./gaming.nix
  ];
}
