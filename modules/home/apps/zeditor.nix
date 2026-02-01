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
        programs.direnv.enable = true;
        programs.zed-editor = {
          enable = true;
          userSettings = {
            terminal = {
              font_family = "JetBrainsMono Nerd Font";
            };
            ui_font_family = "JetBrainsMono Nerd Font";
            features = {
              edit_prediction_provider = "copilot";
            };
          };
        };
      };
}
