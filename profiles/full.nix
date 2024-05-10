{ ... }:
{
  imports = [
    ./minimum.nix
    ../modules/desktop/pantheon.nix
    ../modules/network/networkmanager.nix
    ../modules/network/bluetooth.nix
    ../modules/programs/gaming/steam.nix
  ];

  molyuu.system.profile.select = "full";
  molyuu.hardware.kernel.enable = true;
  molyuu.hardware.kernel.withGrub = true;
  programs.steam.proton-ge.enable = true;
}
