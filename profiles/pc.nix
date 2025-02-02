{ config, lib, ... }:
let
  cfg = config.molyuu.system.profiles;
in
{
  config = lib.mkIf (lib.elem "pc" cfg) {
    molyuu.hardware.kernel.enable = true;
    molyuu.hardware.kernel.grub.enable = true;
    molyuu.hardware.audio.enable = true;
    
    molyuu.system.network.enable = true;
    molyuu.system.network.ntp.enable = true;

    services.openssh.enable = true;
    
    molyuu.home-manager.profile.extraFeatures = [ "full" ];
  };
}
