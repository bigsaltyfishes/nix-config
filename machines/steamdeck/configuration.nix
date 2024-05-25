# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/deck.nix
  ];

  jovian.steam.desktopSession = "pantheon";
  jovian.devices.steamdeck.enable = true;
  jovian.hardware.has.amd.gpu = true;

  jovian.decky-loader.user = "molyuu";
  jovian.decky-loader.enable = true;

  environment.systemPackages = with pkgs; [
    steamdeck-firmware
    jupiter-dock-updater-bin
  ];

  # Extra IBus Engine for Steam Virtual Keyboard
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ anthy table-chinese ];
}
