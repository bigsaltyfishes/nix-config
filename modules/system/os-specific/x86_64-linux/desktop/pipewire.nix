{ config, lib, ... }:
let
  cfg = config.molyuu.hardware.audio;
in
{
  options.molyuu.hardware.audio = {
    enable = lib.mkEnableOption "Enable Audio Support";
  };

  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
          };
          "monitor.bluez.properties" = {
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];
          };
        };
      };
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
