{ lib, system, ... }:
{
  options.molyuu.system.profiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      List of features to enable in the system configuration.
    '';
    example = [ "pc" "gaming" ];
  };

  config = {
    programs.zsh.enable = true;
  };

  imports = [
    ./nix-config.nix
  ] ++ (lib.optionals (system == "x86_64-linux") [
    ./minimum.nix
    ./pc.nix
    ./gaming.nix
  ]) ++ (lib.optionals (system == "x86_64-darwin") [
    ./darwin.nix
  ]);
}
