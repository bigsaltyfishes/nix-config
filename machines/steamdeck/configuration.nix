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
      inputMethod = {
        enable = true;
        methods = [ "pinyin" ];
      };
    };
    devices.steamdeck.enable = true;
    decky-loader = {
      enable = true;
      user = "molyuu";
      extraPackages = with pkgs; [
        curl
        unzip
        util-linux
        gnugrep

        readline.out
        procps
        pciutils
        libpulseaudio

        ryzenadj
        kmod
      ];
      extraPythonPackages = pythonPackages: with pythonPackages; [
        pyyaml
      ];
    };
    hardware.has.amd.gpu = true;
  };

  programs.steam.cefDebug.enable = true;
}
