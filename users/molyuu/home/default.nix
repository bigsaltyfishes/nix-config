{ pkgs, lib, system, ... }:
{
  imports = [
    ../../../modules/home
  ];

  home.username = "molyuu";
  home.homeDirectory = if (system == "x86_64-darwin") then "/Users/molyuu" else "/home/molyuu";

  home.packages = with pkgs; [
    vim
    wget
    fastfetch
    zinit
    nixos-generators
  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "bigsaltyfishes";
    userEmail = "bigsaltyfishes@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
