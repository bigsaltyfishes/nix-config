{ lib, ... }:
{
  imports = [
    ./minimum.nix
    ../modules/hardware/firmware/default.nix
    ../modules/hardware/graphics/common.nix
    ../modules/hardware/bootloader.nix
    ../modules/hardware/kernel/kernel.nix
    ../modules/hardware/kernel/intel.nix
    ../modules/desktop/pantheon.nix
    ../modules/network/networkmanager.nix
    ../modules/network/bluetooth.nix
    ../modules/programs/gaming/steam.nix
  ];

  molyuu.system.profile.select = "full";
  programs.steam.proton-ge.enable = lib.mkIf (cfg.select == "full") true;
}
