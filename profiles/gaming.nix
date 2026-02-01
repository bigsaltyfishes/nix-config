{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.system.profiles;
in
{
  config = lib.mkIf (lib.elem "gaming" cfg) {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for local network game transfers
    };
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
    virtualisation.waydroid.enable = true;
  };
}
