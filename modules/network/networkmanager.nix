{ lib, ... }:
{
  networking.wireless.enable = lib.mkForce false;
  systemd.services.wpa_supplicant.enable = lib.mkForce false;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
