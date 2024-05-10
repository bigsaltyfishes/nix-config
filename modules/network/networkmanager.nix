{ lib, ... }:
{
  networking.wireless.enable = lib.mkForce false;
  systemd.services.wpa_supplicant.wantedBy = lib.mkForce [ ];

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
