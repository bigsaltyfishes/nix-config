{
  lib,
  osConfig,
  ...
}:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  config =
    lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
      {
        programs.ghostty = {
          enable = true;
          settings = {
            "font-family" = "JetBrainsMono Nerd Font";
            "font-thicken" = true;
            "font-size" = 12;

            "window-padding-x" = 10;
            "window-padding-y" = 10;
            "window-decoration" = true;
          };
        };
      };
}
