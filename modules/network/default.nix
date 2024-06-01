{ config, lib, ... }:
let
  cfg = config.molyuu.system.network;
in
{
  options.molyuu.system.network = {
    enable = lib.mkEnableOption "Enable Network Support";
    bluetooth = {
      enable = lib.mkEnableOption "Enable Bluetooth";
    };
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
    ./bluetooth.nix
    ./networkmanager.nix
  ];
}