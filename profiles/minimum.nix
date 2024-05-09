{ config, lib, ... }:
{
  imports = [
    ../users/molyuu.nix
    ../modules/network/ntp.nix
    ../modules/locale/i18n.nix
    ../modules/security/sudo.nix
    ../modules/programs/dev/rust-toolchains.nix
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.substituters = [ "https://cernet.mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;
    
    molyuu.system.profile.select = "minimum";

    system.stateVersion = "23.11";
    services.sshd.enable = true;
    networking.hostName = "molyuu";

    programs.zsh.enable = true;
  };
}