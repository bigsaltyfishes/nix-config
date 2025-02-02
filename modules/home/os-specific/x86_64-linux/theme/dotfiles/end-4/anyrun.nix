{ config, inputs, lib, pkgs, ... }:
let
  enabled = config.molyuu.home-manager.theme.dotfile == "end-4";
in
{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  config = lib.mkIf enabled {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          randr
          rink
          shell
          symbols
        ];

        x = { fraction = 0.500000; };
        y = { absolute = 15; };
        width = { fraction = 0.300000; };
        height = { absolute = 0; };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = true;
        closeOnClick = true;
        showResultsImmediately = false;
        maxEntries = null;
      };
    };
  };
}