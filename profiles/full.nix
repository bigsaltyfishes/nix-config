{ ... }:
{
  imports = [
    ./minimum.nix
    ../modules/desktop/default.nix
    ../modules/network/networkmanager.nix
    ../modules/network/bluetooth.nix
    ../modules/programs/gaming/default.nix
  ];

  molyuu.home-manager.profile.extraFeatures = [ "full" ];
  molyuu.hardware.kernel.enable = true;
  molyuu.hardware.kernel.grub.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.steam.proton-ge.enable = true;
}
