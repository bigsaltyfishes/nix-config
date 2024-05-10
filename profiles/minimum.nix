{ lib, ... }:
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

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    nix.settings.auto-optimise-store = true;

    nix.settings.substituters = [ "https://cernet.mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/" "https://cuda-maintainers.cachix.org" ];
    nix.settings.trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

    molyuu.system.profile.select = lib.mkDefault "minimum";

    system.stateVersion = "23.11";
    services.sshd.enable = true;
    networking.hostName = "molyuu";

    programs.zsh.enable = true;
  };
}
