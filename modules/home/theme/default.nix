{ lib, osConfig, ... }:
{
  options.molyuu.home-manager.theme = {
    dotfile = lib.mkOption {
      type = lib.types.str;
      default = osConfig.molyuu.home-manager.theme.dotfile;
      description = "The dotfile to use";
    };

    wallpaperEngine = {
      enable = lib.mkOption {
        description = "Enable Wallpaper Engine integration";
        default = osConfig.molyuu.home-manager.theme.wallpaperEngine.enable;
      };
      monitor = lib.mkOption {
        type = lib.types.str;
        default = osConfig.molyuu.home-manager.theme.wallpaperEngine.monitor;
        description = "The monitor to set the wallpaper on (e.g. 'DP-1')";
      };
      scaling = lib.mkOption {
        type = lib.types.str;
        default = osConfig.molyuu.home-manager.theme.wallpaperEngine.scaling;
        description = "The scaling mode for the wallpaper";
      };
      wallpaperId = lib.mkOption {
        type = lib.types.str;
        default = osConfig.molyuu.home-manager.theme.wallpaperEngine.wallpaperId;
        description = "The Wallpaper Engine wallpaper ID to use";
      };
    };
  };

  imports = [
    ./dotfiles
    ./wallpaper-engine.nix
  ];
}
