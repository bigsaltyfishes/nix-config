{ config, lib, ... }:
let
  cfg = config.molyuu.system.network;
in
{
  options.molyuu.system.network = {
    enable = lib.mkEnableOption "Enable Network Support";
    ntp = {
      enable = lib.mkEnableOption "Enable NTP service";
    };
  };

  config = {
    networking.wireless.enable = lib.mkForce false;
    systemd.services.wpa_supplicant.enable = lib.mkForce false;
    services.chrony.enable = cfg.enable && cfg.ntp.enable;
  };

  imports = [
    ./networkmanager.nix
  ];
}