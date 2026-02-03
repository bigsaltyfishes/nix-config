{ config, lib, ... }:
let
  cfg = config.molyuu.home-manager.theme.wallpaperEngine;
in
{
  config = lib.mkIf cfg.enable {
    services.linux-wallpaperengine = {
      enable = true;
      wallpapers = [
        {
          monitor = cfg.monitor;
          wallpaperId = cfg.wallpaperId;
          scaling = cfg.scaling;
          audio = {
            silent = true;
            processing = false;
          };
        }
      ];
    };
  };
}
