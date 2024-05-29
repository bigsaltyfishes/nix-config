# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/deck.nix
  ];

  molyuu.desktop.pantheon.enable = true;

  jovian.steam.desktopSession = "pantheon";
  jovian.devices.steamdeck.enable = true;
  jovian.hardware.has.amd.gpu = true;

  services.xserver.displayManager.startx.enable = true;
  services.libinput.enable = true;

  molyuu.system.services.mihomo.enable = true;

  jovian.decky-loader.enable = true;
  programs.steam.cefDebug.enable = true;

  molyuu.system.autoMount.enable = true;

  environment.systemPackages = with pkgs; [
    steamdeck-firmware
    jupiter-dock-updater-bin
  ];

  services.openssh.enable = true;

  # Extra IBus Engine for Steam Virtual Keyboard
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ anthy table-chinese ];
}
