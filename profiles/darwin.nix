{ config, lib, ... }:
let
  cfg = config.molyuu.system.profiles;
in
{
  config = lib.mkIf (lib.elem "darwin" cfg) {
    molyuu.home-manager.profile.extraFeatures = [ "baseDevel" "extraDevel" ];
  };
}
