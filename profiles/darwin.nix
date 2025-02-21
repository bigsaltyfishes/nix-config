{
  config,
  lib,
  system,
  ...
}:
let
  cfg = config.molyuu.system.profiles;
in
{
  config = lib.mkIf (lib.elem "pc" cfg) {
    homebrew = {
      enable = true;
      casks = [
        "spotify"
        "google-chrome"
        "warp"
      ];
    };
    services.nix-daemon.enable = true;
    nixpkgs.hostPlatform = system;
    molyuu.home-manager.profile.extraFeatures = [
      "baseDevel"
      "extraDevel"
    ];
    system.stateVersion = 4;
  };
}
