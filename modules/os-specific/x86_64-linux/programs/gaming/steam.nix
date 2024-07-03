{ config, lib, pkgs, ... }:
let
  cfg = config.programs.steam.cefDebug;
in
{
  options.programs.steam.cefDebug = {
    enable = lib.mkEnableOption "Enable CEF Remote Debugging API for Steam, Decky Loader requires this";
  };

  config.systemd.user.services.steam-cef-debug = lib.mkIf cfg.enable {
    description = "Enable Steam CEF Remote Debugging API";
    wantedBy = [ "default.target" "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.steam/steam && ${pkgs.coreutils}/bin/mkdir -p %h/.steam/steam || ${pkgs.coreutils}/bin/true"
      '';
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.steam/steam/.cef-enable-remote-debugging && ${pkgs.coreutils}/bin/touch %h/.steam/steam/.cef-enable-remote-debugging || ${pkgs.coreutils}/bin/true"
      '';
    };
  };
}