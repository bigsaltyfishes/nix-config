{ inputs, pkgs, ... }:
{
  imports = [
    ../users/molyuu
    ../modules/network/ntp.nix
    ../modules/locale/i18n.nix
    ../modules/security/sudo.nix
    ../modules/programs/appimage.nix
    ../modules/programs/dev/c-toolchains.nix
    ../modules/programs/dev/rust-toolchains.nix
    ../modules/services/clash-verge-service.nix
    ../modules/services/mihomo/mihomo.nix
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.settings.auto-optimise-store = true;

    nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://cache.nixos.org/" "https://cuda-maintainers.cachix.org" ];
    nix.settings.trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

    environment.systemPackages = with inputs.nix-alien.packages.${pkgs.system}; [
      nix-alien
    ];
    programs.nix-ld.enable = true;

    system.stateVersion = "unstable";
    services.sshd.enable = true;
    networking.hostName = "molyuu";

    programs.zsh.enable = true;
  };
}
