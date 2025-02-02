{ config, lib, ... }:
let
  cfg = config.molyuu.system.network;
in
{
  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
