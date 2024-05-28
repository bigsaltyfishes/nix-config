{ ... }:
{
  imports = [
    ./minimum.nix
    ../modules/desktop/default.nix
    ../modules/network/networkmanager.nix
    ../modules/network/bluetooth.nix
    ../modules/programs/gaming/default.nix
    ../modules/services/mihomo.nix
  ];

  molyuu.home-manager.profile.extraFeatures =  [ "full" ];
  molyuu.hardware.kernel.grub.enable = true;

  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.user = "molyuu";

  services.clash-verge.enable = true;

  molyuu.desktop.pantheon.lightdm.enable = false;
  programs.steam.proton-ge.enable = true;
}
