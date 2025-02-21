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
  config.programs.steam = lib.mkIf (lib.elem "gaming" cfg) {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for local network game transfers
  };
}
