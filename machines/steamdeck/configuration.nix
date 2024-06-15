# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  molyuu.system.profiles = [ "pc" "gaming" ];

  services.clash-verge.enable = true;

  environment.systemPackages = [
    (pkgs.steamdeck-firmware or null)
    (pkgs.jupiter-dock-updater-bin or null)
    pkgs.steam-im-modules
  ];

  molyuu.hardware.kernel.enable = lib.mkForce false;

  molyuu.system.autoMount.enable = true;

  services.libinput.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;

  jovian = {
    steam = {
      desktopSession = "pantheon";
      enable = true;
      autoStart = true;
      user = "molyuu";
    };
    devices.steamdeck.enable = true;
    decky-loader.enable = true;
    hardware.has.amd.gpu = true;
  };

  programs.steam.cefDebug.enable = true;

  # Extra IBus Engine for Steam Virtual Keyboard
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ anthy table table-cangjie-lite pinyin ];
}
