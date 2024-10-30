{ config, lib, pkgs, ... }:
let
  cfg = config.services.clash-verge;
in
{
  options.services.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge Service";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.clash-verge-service = {
      description = "Clash Verge Service helps to launch Clash Core.";
      after = [ "network-online.target" "nftables.service" "iptables.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-service";
        Restart = "always";
        RestartSec = "5";
        Type = "simple";
      };
    };
  };
}
