{ pkgs, lib, system, ... }:
{
  imports = [
    ../../../modules/home
  ];

  home.username = "molyuu";
  home.homeDirectory = if (system == "x86_64-darwin") then "/Users/molyuu" else "/home/molyuu";

  home.packages = with pkgs; [
    gh
    vim
    wget
    fastfetch
    zinit
    nixos-generators
  ];

  programs.git = {
    enable = true;
    userName = "bigsaltyfishes";
    userEmail = "bigsaltyfishes@gmail.com";
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
