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
    ./ghostty.nix
    ./spicetify.nix
  ];

  config =
    lib.mkIf (lib.elem "extraApps" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
      {
        home.packages =
          with pkgs;
          [
            pavucontrol
            google-chrome
            gparted
            wpsoffice-cn
            wechat
            peazip
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
