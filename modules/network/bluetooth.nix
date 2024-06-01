{ config, lib, ... }:
let
  cfg = config.molyuu.system.network;
in
{
  config = lib.mkIf (cfg.enable && cfg.bluetooth.enable) {
    hardware.bluetooth.enable = true;
    environment.etc."wireplumber/wireplumber.conf.d/50-bluez.conf" = {
      enable = config.services.pipewire.wireplumber.enable;
      text = ''
        monitor.bluez.rules = [
          {
            matches = [
              {
                ## This matches all bluetooth devices.
                device.name = "~bluez_card.*"
              }
            ]
            actions = {
              update-props = {
                bluez5.auto-connect = [ a2dp_sink ]
                bluez5.hw-volume = [ a2dp_sink ]
              }
            }
          }
        ]

        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink ]
          bluez5.hfphsp-backend = "none"
        }
      '';
    };
  };
}
