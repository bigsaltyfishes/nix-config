{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}:
let
  profile = osConfig.molyuu.home-manager.profile;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  config =
    lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
      {
        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.dribbblish;
          colorScheme = "gruvbox-material-dark";
        };
      };
}
