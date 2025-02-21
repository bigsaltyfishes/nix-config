{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./fastfetch
    ./zeditor.nix
    ./spicetify.nix
  ];

  config =
    lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
      {
        home.packages =
          with pkgs;
          [
            warp-terminal
            pavucontrol
            google-chrome
            gparted
            wpsoffice-cn
            wechat-uos
          ]
          ++
            lib.optionals (lib.elem "gaming" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
              [
                protontricks
                lutris-unwrapped
                moonlight-qt
              ];
      };
}
