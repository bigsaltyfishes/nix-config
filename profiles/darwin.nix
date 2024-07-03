{ config, lib, ... }:
let
  cfg = config.molyuu.system.profiles;
in
{
  config = lib.mkIf (lib.elem "pc" cfg) {
    homebrew = {
      enable = true;
      casks = [
        "clash-verge-rev"
        "spotify"
        "google-chrome"
        "warp"
        "wechat"
        "qq"
      ];
    };
    molyuu.home-manager.profile.extraFeatures = [ "baseDevel" "extraDevel" ];
    system.stateVersion = 4;
  };
}
