{ lib, osConfig, ... }:
{
  options.molyuu.home-manager.theme = {
    dotfile = lib.mkOption {
      type = lib.types.str;
      default = osConfig.molyuu.home-manager.theme.dotfile;
      description = "The dotfile to use";
    };
  };

  imports = [
    ./dotfiles
  ];
}
