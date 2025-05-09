{ config, pkgs, lib, ...}: 
let
  enabled = config.molyuu.home-manager.theme.dotfile == "molyuu";
in
{
  config = lib.mkIf enabled {
    # greetd display manager
    services.greetd = let
      session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "molyuu";
      };
    in {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    # unlock GPG keyring on login
    security.pam.services.greetd.enableGnomeKeyring = true;

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "molyuu";
  };
}